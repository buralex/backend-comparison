import Fastify from "fastify";
import { stdTimeFunctions } from "pino";
import { userRepository } from "./users/user.repository";
import { initializeDatabases } from "./initializeDatabases";
import { initialSeed } from "./seed/seedUsers";

const app = Fastify({
  logger: { timestamp: stdTimeFunctions.isoTime },
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

app.get<{ Params: { n: string } }>(
  "/fib-loop/:n",
  async function handler(request, reply) {
    const n = parseInt(request.params.n);
    let index;
    var fib = [0, 1]; // Initialize array!

    for (index = 2; index <= n; index++) {
      // Next fibonacci number = previous + one before previous
      // Translated to JavaScript:
      fib[index] = fib[index - 2] + fib[index - 1];
    }

    return `Fibonacci(${n}) = ${fib[fib.length - 1]}`;
  }
);

function fibonacci(n) {
  if (n <= 0) return 0;
  else if (n === 1) return 1;
  else return fibonacci(n - 1) + fibonacci(n - 2);
}

app.get<{ Params: { n: string } }>("/fib/:n", (req, res) => {
  const n = parseInt(req.params.n);
  const result = fibonacci(n);
  return `Fibonacci(${n}) = ${result}`;
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
