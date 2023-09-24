import {
  Column,
  Entity,
  PrimaryGeneratedColumn,
  CreateDateColumn,
  UpdateDateColumn,
  ManyToOne,
} from "typeorm";
import { timestamptzColumnOptions } from "../constants";
import { User } from "../users/user.entity";

@Entity()
export class Post {
  @PrimaryGeneratedColumn("uuid")
  id: string;

  @Column()
  title: string;

  @CreateDateColumn(timestamptzColumnOptions)
  createdAt: Date;

  @UpdateDateColumn(timestamptzColumnOptions)
  updatedAt: Date;

  @ManyToOne(() => User, (user) => user.posts)
  user: User;
}
