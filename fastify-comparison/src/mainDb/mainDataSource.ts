import { DataSource, DataSourceOptions } from "typeorm";

export const mainDataSourceOptions: DataSourceOptions = {
  type: "postgres",
  host: process.env.POSTGRES_HOST,
  port:
    process.env.POSTGRES_HOST !== "localhost"
      ? 5432
      : Number(process.env.POSTGRES_PORT),
  username: process.env.POSTGRES_USER,
  password: process.env.POSTGRES_PASSWORD,
  database: process.env.POSTGRES_DB,
  synchronize: false,
  migrationsRun: true,
  logging: process.env.TYPEORM_LOG === "true",
  entities: [__dirname + "/../**/*.entity{.js,.ts}"],
  migrations: [__dirname + "/migrations/*{.js,.ts}"],
};

export const mainDataSource = new DataSource(mainDataSourceOptions);
