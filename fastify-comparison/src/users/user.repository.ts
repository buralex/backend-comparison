// import "reflect-metadata";
import { mainDataSource } from "../mainDb/mainDataSource";
import { User } from "./user.entity";

export const userRepository = mainDataSource.getRepository(User);
