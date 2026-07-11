//! Shared HTTP helpers and record builders for MCP route crates.

pub mod health;
pub mod http;
pub mod list_query;
pub mod record_builders;
mod response;
mod service_ops;

pub use health::{healthz_with_state, livez, readyz_with_state, DbReadinessCheck};
pub use http::{resolve_tenant_id, SharedMcpService, TENANT_HEADER};
pub use list_query::{McpInvocationListQuery, SdkWorkListQuery};
pub use response::{
    finish_api_json, item_data, ok_json, page_data, paginate_items, ApiProblem, ApiResult,
};
pub use service_ops::{
    append_invocation, delete_connector, delete_server, get_server, get_tool, list_categories,
    list_connectors, list_invocations, list_prompts, list_resources, list_servers, list_tools,
    upsert_category, upsert_connector, upsert_prompt, upsert_resource, upsert_server, upsert_tool,
};

use axum::Router;

pub fn gateway_mount() -> axum::Router {
    axum::Router::new()
}
