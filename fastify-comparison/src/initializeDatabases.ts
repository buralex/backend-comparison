import { mainDataSource } from "./mainDb/mainDataSource";
import { delay } from "./utils";

export const initializeDatabases = async () => {
  const maxAttempts = 10;
  const retryIntervalMs = 3000;

  for (let attempt = 1; attempt <= maxAttempts; attempt++) {
    console.info(`Trying to connect to main database (attempt ${attempt})`);
    try {
      await mainDataSource.initialize();
      console.info("Main database connected");
      return;
    } catch (error) {
      console.error(error, "Main database connection error");
      await delay(retryIntervalMs);
    }
  }

  console.info("All reconnection attempts to main database failed. Exiting");
  process.exit(1);
};
