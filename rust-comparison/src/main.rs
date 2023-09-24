mod config {
    use serde::Deserialize;
    #[derive(Debug, Default, Deserialize)]
    pub struct ExampleConfig {
        pub main_api_service_port: String,
        pub pg: deadpool_postgres::Config,
    }
}

mod models {
    use serde::{Deserialize, Serialize};
    use tokio_pg_mapper_derive::PostgresMapper;

    #[derive(Deserialize, PostgresMapper, Serialize)]
    #[pg_mapper(table = "app_user")]
    pub struct User {
        pub email: String,
        pub first_name: String,
        pub last_name: String,
        pub username: String,
    }
}

mod errors {
    use actix_web::{HttpResponse, ResponseError};
    use deadpool_postgres::PoolError;
    use derive_more::{Display, From};
    use tokio_pg_mapper::Error as PGMError;
    use tokio_postgres::error::Error as PGError;

    #[derive(Display, From, Debug)]
    pub enum MyError {
        NotFound,
        PGError(PGError),
        PGMError(PGMError),
        PoolError(PoolError),
    }
    impl std::error::Error for MyError {}

    impl ResponseError for MyError {
        fn error_response(&self) -> HttpResponse {
            match *self {
                MyError::NotFound => HttpResponse::NotFound().finish(),
                MyError::PoolError(ref err) => {
                    HttpResponse::InternalServerError().body(err.to_string())
                }
                _ => HttpResponse::InternalServerError().finish(),
            }
        }
    }
}

mod db {
    use deadpool_postgres::Client;
    use tokio_pg_mapper::FromTokioPostgresRow;

    use crate::{errors::MyError, models::User};

    pub async fn get_users(client: &Client) -> Result<Vec<User>, MyError> {
        let stmt = include_str!("./sql/get_users.sql");
        let stmt = stmt.replace("$table_fields", &User::sql_table_fields());
        let stmt = client.prepare(&stmt).await.unwrap();

        let results = client
            .query(&stmt, &[])
            .await?
            .iter()
            .map(|row| User::from_row_ref(row).unwrap())
            .collect::<Vec<User>>();

        Ok(results)
    }

    pub async fn add_user(client: &Client, user_info: User) -> Result<User, MyError> {
        let _stmt = include_str!("./sql/add_user.sql");
        let _stmt = _stmt.replace("$table_fields", &User::sql_table_fields());
        // println!("statement: {:?}", &_stmt);

        let stmt = client.prepare(&_stmt).await.unwrap();

        client
            .query(
                &stmt,
                &[
                    &user_info.email,
                    &user_info.first_name,
                    &user_info.last_name,
                    &user_info.username,
                ],
            )
            .await?
            .iter()
            .map(|row| User::from_row_ref(row).unwrap())
            .collect::<Vec<User>>()
            .pop()
            .ok_or(MyError::NotFound) // more applicable for SELECTs
    }

    pub async fn sleep_10_sec(client: &Client) -> Result<Vec<tokio_postgres::Row>, MyError> {
        let stmt = include_str!("./sql/sleep_10_sec.sql");
        let stmt = client.prepare(&stmt).await?;

        let results = client.query(&stmt, &[]).await?;

        Ok(results)
    }

    pub async fn init_db_schema(client: &Client) -> Result<(), MyError> {
        let schema_sql = include_str!("./sql/schema.sql");
        client.batch_execute(schema_sql).await?;

        Ok(())
    }
}

mod handlers {
    use actix_web::{web, Error, HttpResponse};
    use deadpool_postgres::{Client, Pool};

    use crate::{db, errors::MyError, models::User};

    pub async fn get_users(db_pool: web::Data<Pool>) -> Result<HttpResponse, Error> {
        let client: Client = db_pool.get().await.map_err(MyError::PoolError)?;
        let users = db::get_users(&client).await?;
        Ok(HttpResponse::Ok().json(users))
    }

    pub async fn add_user(
        user: web::Json<User>,
        db_pool: web::Data<Pool>,
    ) -> Result<HttpResponse, Error> {
        let user_info: User = user.into_inner();

        let client: Client = db_pool.get().await.map_err(MyError::PoolError)?;

        let new_user = db::add_user(&client, user_info).await?;

        Ok(HttpResponse::Ok().json(new_user))
    }

    pub async fn seed_users(db_pool: web::Data<Pool>) -> Result<HttpResponse, Error> {
        let client: Client = db_pool.get().await.map_err(MyError::PoolError)?;

        for i in 0..5 {
            let user_number = i + 1;
            let unique_username = format!("user{}", user_number);

            let user_info = User {
                email: format!("user{}@example.com", user_number),
                first_name: format!("John{}", user_number),
                last_name: "Doe".to_string(),
                username: unique_username,
            };

            db::add_user(&client, user_info).await?;
        }

        Ok(HttpResponse::Ok().json("Users seeded successfully"))
    }

    pub async fn sleep_db(db_pool: web::Data<Pool>) -> Result<HttpResponse, Error> {
        let client: Client = db_pool.get().await.map_err(MyError::PoolError)?;

        db::sleep_10_sec(&client).await?;

        Ok(HttpResponse::Ok().json("success"))
    }
}

use ::config::Config;
use actix_web::{get, middleware::Logger, post, web, App, HttpResponse, HttpServer, Responder};
use db::init_db_schema;
use deadpool_postgres::Client;
use env_logger::Env;
use handlers::{add_user, get_users, seed_users, sleep_db};
use tokio_postgres::NoTls;

use crate::config::ExampleConfig;

#[get("/ping")]
async fn ping() -> impl Responder {
    HttpResponse::Ok().body("pong")
}

#[post("/echo")]
async fn echo(req_body: String) -> impl Responder {
    HttpResponse::Ok().body(req_body)
}

async fn manual_hello() -> impl Responder {
    HttpResponse::Ok().body("Hey there!")
}

fn fibonacci(n: u32) -> u64 {
    match n {
        0 => 0,
        1 => 1,
        _ => fibonacci(n - 1) + fibonacci(n - 2),
    }
}

#[get("/fib/{n}")]
async fn calculate_fibonacci(path: web::Path<u32>) -> impl Responder {
    let n = path.into_inner();
    let result = fibonacci(n);
    HttpResponse::Ok().body(format!("Fibonacci({n}) = {result}"))
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    let config_ = Config::builder()
        .add_source(::config::Environment::default().separator("__"))
        .build()
        .unwrap();

    let config: ExampleConfig = config_.try_deserialize().unwrap();

    let pool = config.pg.create_pool(None, NoTls).unwrap();

    let client: Client = pool.get().await.unwrap();
    init_db_schema(&client)
        .await
        .expect("Failed to apply schema");

    env_logger::init_from_env(Env::default().default_filter_or("info"));

    let server = HttpServer::new(move || {
        App::new()
            .wrap(Logger::default())
            .app_data(web::Data::new(pool.clone()))
            .service(
                web::resource("/users")
                    .route(web::post().to(add_user))
                    .route(web::get().to(get_users)),
            )
            .service(ping)
            .service(echo)
            .service(calculate_fibonacci)
            .route("/hey", web::get().to(manual_hello))
            .route("/helpers/seed", web::get().to(seed_users))
            .route("/helpers/sleep-db", web::get().to(sleep_db))
    })
    .bind(format!("0.0.0.0:{}", config.main_api_service_port))?
    .run();
    println!(
        "Server running at http://0.0.0.0:{}",
        config.main_api_service_port
    );

    server.await
}
