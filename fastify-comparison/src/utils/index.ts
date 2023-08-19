export enum NodeEnv {
  "production" = "production",
  "test" = "test",
}

export const isProduction = process.env.NODE_ENV === NodeEnv.production;

export const delay = (milliseconds: number) =>
  new Promise((resolve) => {
    setTimeout(resolve, milliseconds);
  });
