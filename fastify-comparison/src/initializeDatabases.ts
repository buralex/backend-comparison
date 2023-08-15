import { mainDataSource } from "./mainDb/mainDataSource";

export const initializeDatabases = async () => {
  await mainDataSource
    .initialize()
    .then(() => {
      console.error("Main database connected");
    })
    .catch((err) => {
      console.error(err, "Main database connection error");
    });
};
