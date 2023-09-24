import {
  Column,
  Entity,
  PrimaryGeneratedColumn,
  CreateDateColumn,
  UpdateDateColumn,
  OneToMany,
} from "typeorm";
import { timestamptzColumnOptions } from "../constants";
import { Post } from "../posts/post.entity";

@Entity()
export class User {
  @PrimaryGeneratedColumn("uuid")
  id: string;

  @Column({ unique: true })
  email: string;

  @Column()
  fullName: string;

  @CreateDateColumn(timestamptzColumnOptions)
  createdAt: Date;

  @UpdateDateColumn(timestamptzColumnOptions)
  updatedAt: Date;

  @OneToMany(() => Post, (post) => post.user)
  posts: Post[];
}
