use axum::http::HeaderMap;

pub const TENANT_HEADER: &str = "x-sdkwork-tenant-id";

pub type SharedMcpService<R> = std::sync::Arc<sdkwork_intelligence_mcp_service::McpService<R>>;

pub fn resolve_tenant_id(headers: &HeaderMap, default_tenant_id: u64) -> u64 {
    headers
        .get(TENANT_HEADER)
        .and_then(|value| value.to_str().ok())
        .and_then(|value| value.parse::<u64>().ok())
        .unwrap_or(default_tenant_id)
}
