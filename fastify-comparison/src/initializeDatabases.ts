import { mainDataSource } from "./mainDb/mainDataSource";
import { delay } from "./utils";

export const initializeDatabases = async () => {
  const maxRetries = 10;
  const retryInterval = 5000;
  let retries = 0;

  while (retries < maxRetries) {
    try {
      await mainDataSource.initialize();
      console.info("Main database connected");
      break;
    } catch (error) {
      console.error(error, "Main database connection error");
      retries++;
      if (retries < maxRetries) {
        console.info(
          `Retrying to connect to main database in ${
            retryInterval / 1000
          } seconds (attempt ${retries})`
        );
        await delay(retryInterval);
      } else {
        console.error(
          "Max retries to connect to main database reached. Exiting"
        );
        process.exit(1);
      }
    }
  }
};
