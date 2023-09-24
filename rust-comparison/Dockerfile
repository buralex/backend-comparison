ARG BASE_IMAGE=rust:1.72.1-slim

################# Step 1 #################
FROM $BASE_IMAGE As builder-step
WORKDIR /home/src/app
COPY Cargo.* ./
COPY src src
RUN cargo build --release

################# Step 2 #################
FROM debian:12.1-slim as production-step

RUN groupadd -r appuser && useradd -r -g appuser appuser

WORKDIR /home/src/app
RUN apt-get update && apt-get install -y curl
COPY --chown=appuser:appuser --from=builder-step /home/src/app/target/release/rust-comparison ./rust-comparison

USER appuser

CMD ["./rust-comparison"]