import Fastify from "fastify";
import { userRepository } from "./users/user.repository";
import { initializeDatabases } from "./initializeDatabases";
import { initialSeed } from "./seed/seedUsers";

const app = Fastify({
  logger: true,
});

app.get("/ping", async function handler(request, reply) {
  return "pong";
});

app.get("/users", async function handler(request, reply) {
  return userRepository.find({ relations: ["posts"] });
});

app.get("/helpers/seed", async function handler(request, reply) {
  await initialSeed();
  return { message: "Database seeded successfully" };
});

const start = async () => {
  await initializeDatabases();

  try {
    await app.listen({
      port: Number(process.env.MAIN_API_SERVICE_PORT),
      host: "0.0.0.0",
    });
  } catch (err) {
    app.log.error(err, "App listen error");
    process.exit(1);
  }
};

start();
