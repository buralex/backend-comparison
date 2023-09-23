FROM rust:1.72.1-slim

RUN apt-get update && apt-get install -y curl

WORKDIR /home/src/app

COPY . .
RUN cargo build --release

ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}

CMD ["./target/release/rust-comparison"]