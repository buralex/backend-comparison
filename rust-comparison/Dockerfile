FROM rust:1.72.1-slim
COPY . .
RUN cargo build --release

RUN apt-get update && apt-get install -y curl
ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}

WORKDIR /home/node/app

CMD ["./target/release/rust-comparison"]