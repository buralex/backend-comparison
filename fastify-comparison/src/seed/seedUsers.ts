import { Post } from "../posts/post.entity";
import { mainDataSource } from "../mainDb/mainDataSource";
import { User } from "../users/user.entity";

const createOneUser = async ({ userRepository, email, fullName }) => {
  let user = await userRepository.findOneBy({ email });
  if (!user) {
    user = await userRepository.save({
      email,
      fullName,
    });
  }
  return user;
};

const createUsers = async (userRepository) => {
  const usersNumber = 5;
  const users: User[] = [];
  for (let index = 0; index < usersNumber; index++) {
    const email = `user_${index + 1}@gmail.com`;
    const fullName = `user_${index + 1} surname_${index + 1}`;
    const user = await createOneUser({ userRepository, email, fullName });
    users.push(user);
  }
  return users;
};

const createPosts = async ({ users }) => {
  const postRepository = mainDataSource.getRepository(Post);

  for (const user of users) {
    for (let index = 0; index < 2; index++) {
      await postRepository.save(
        postRepository.create({
          title: `${user.fullName} post ${index + 1}`,
          user: user,
        })
      );
    }
  }
};

export const initialSeed = async () => {
  const userRepository = mainDataSource.getRepository(User);
  const users = await createUsers(userRepository);
  await createPosts({ users });
};
