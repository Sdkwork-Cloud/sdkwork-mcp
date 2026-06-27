use sdkwork_mcp_gateway_assembly::assemble_application_router;
use sdkwork_mcp_standalone_gateway::serve_router;
use tracing_subscriber::EnvFilter;

#[tokio::main]
async fn main() {
    tracing_subscriber::fmt()
        .with_env_filter(EnvFilter::from_default_env())
        .init();

    let listen_addr = std::env::var("SDKWORK_MCP_APPLICATION_PUBLIC_INGRESS_BIND")
        .unwrap_or_else(|_| "127.0.0.1:18092".to_string());

    let router = assemble_application_router()
        .await
        .expect("assemble sdkwork-mcp gateway router")
        .router;
    serve_router(&listen_addr, "sdkwork-mcp-standalone-gateway", router).await;
}
