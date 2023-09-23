use actix_web::{get, post, web, App, HttpResponse, HttpServer, Responder};

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
  HttpResponse::Ok().body(format!("Fibonacci({}) = {}", n, result))
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
  HttpServer::new(|| {
    App::new()
      .service(ping)
      .service(echo)
      .service(calculate_fibonacci)
      .route("/hey", web::get().to(manual_hello))
  })
  .bind(("0.0.0.0", 3030))?
  .run()
  .await
}