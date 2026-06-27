FROM rust:1-bookworm AS builder
WORKDIR /app
COPY . .
RUN cargo build --release -p sdkwork-mcp-standalone-gateway

FROM debian:bookworm-slim
COPY --from=builder /app/target/release/sdkwork-mcp-standalone-gateway /usr/local/bin/sdkwork-mcp-standalone-gateway
EXPOSE 18110
CMD ["sdkwork-mcp-standalone-gateway"]
