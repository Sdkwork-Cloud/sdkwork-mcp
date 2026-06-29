//! Shared HTTP helpers and record builders for MCP route crates.

pub mod http;
pub mod record_builders;
mod response;
mod service_ops;

pub use http::{resolve_tenant_id, SharedMcpService, TENANT_HEADER};
pub use response::{finish_api_json, item_data, list_data, ok_json, ApiProblem, ApiResult};
pub use service_ops::{
    append_invocation, delete_connector, delete_server, get_server, get_tool, list_categories,
    list_connectors, list_invocations, list_prompts, list_resources, list_servers, list_tools,
    upsert_category, upsert_connector, upsert_prompt, upsert_resource, upsert_server, upsert_tool,
};
