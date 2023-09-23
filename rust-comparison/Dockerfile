ARG BASE_IMAGE=rust:1.72.1-slim

################# Step 1 #################
FROM $BASE_IMAGE As builder-step
WORKDIR /home/src/app
COPY . .
RUN cargo build --release


################# Step 2 #################
FROM $BASE_IMAGE as production-step
WORKDIR /home/src/app
RUN apt-get update && apt-get install -y curl
COPY --from=builder-step /home/src/app/target ./target

CMD ["./target/release/rust-comparison"]