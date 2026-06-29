use sdkwork_intelligence_mcp_service::{McpRepository, McpService, McpServiceError};
use sdkwork_mcp_contract::{
    McpConnectorRecord, McpInvocationRecord, McpPromptRecord, McpResourceRecord,
    McpServerCategoryRecord, McpServerRecord, McpToolRecord,
};
use sdkwork_utils_rust::{SdkWorkPageData, SdkWorkResourceData};

use crate::response::{item_data, list_data, ApiProblem, ApiResult};

impl From<McpServiceError> for ApiProblem {
    fn from(error: McpServiceError) -> Self {
        match error {
            McpServiceError::NotFound(message) => ApiProblem::not_found(message),
            McpServiceError::InvalidArgument(message) => ApiProblem::bad_request(message),
            McpServiceError::Repository(message) => ApiProblem::internal_server_error(message),
        }
    }
}

pub async fn list_categories<R: McpRepository>(
    service: &McpService<R>,
    tenant_id: u64,
) -> ApiResult<SdkWorkPageData<McpServerCategoryRecord>> {
    let items = service.list_categories(tenant_id).await?;
    Ok(list_data(items))
}

pub async fn list_servers<R: McpRepository>(
    service: &McpService<R>,
    tenant_id: u64,
) -> ApiResult<SdkWorkPageData<McpServerRecord>> {
    let items = service.list_servers(tenant_id).await?;
    Ok(list_data(items))
}

pub async fn get_server<R: McpRepository>(
    service: &McpService<R>,
    tenant_id: u64,
    server_key: &str,
) -> ApiResult<SdkWorkResourceData<McpServerRecord>> {
    let record = service.get_server(tenant_id, server_key).await?;
    Ok(item_data(record))
}

pub async fn list_connectors<R: McpRepository>(
    service: &McpService<R>,
    tenant_id: u64,
    server_id: u64,
) -> ApiResult<SdkWorkPageData<McpConnectorRecord>> {
    let items = service.list_connectors(tenant_id, server_id).await?;
    Ok(list_data(items))
}

pub async fn list_tools<R: McpRepository>(
    service: &McpService<R>,
    tenant_id: u64,
    server_id: u64,
) -> ApiResult<SdkWorkPageData<McpToolRecord>> {
    let items = service.list_tools(tenant_id, server_id).await?;
    Ok(list_data(items))
}

pub async fn get_tool<R: McpRepository>(
    service: &McpService<R>,
    tenant_id: u64,
    server_id: u64,
    tool_key: &str,
) -> ApiResult<SdkWorkResourceData<McpToolRecord>> {
    let record = service.get_tool(tenant_id, server_id, tool_key).await?;
    Ok(item_data(record))
}

pub async fn list_resources<R: McpRepository>(
    service: &McpService<R>,
    tenant_id: u64,
    server_id: u64,
) -> ApiResult<SdkWorkPageData<McpResourceRecord>> {
    let items = service.list_resources(tenant_id, server_id).await?;
    Ok(list_data(items))
}

pub async fn list_prompts<R: McpRepository>(
    service: &McpService<R>,
    tenant_id: u64,
    server_id: u64,
) -> ApiResult<SdkWorkPageData<McpPromptRecord>> {
    let items = service.list_prompts(tenant_id, server_id).await?;
    Ok(list_data(items))
}

pub async fn list_invocations<R: McpRepository>(
    service: &McpService<R>,
    tenant_id: u64,
    server_id: Option<u64>,
    limit: u32,
) -> ApiResult<SdkWorkPageData<McpInvocationRecord>> {
    let items = service.list_invocations(tenant_id, server_id, limit).await?;
    Ok(list_data(items))
}

pub async fn append_invocation<R: McpRepository>(
    service: &McpService<R>,
    record: McpInvocationRecord,
) -> ApiResult<SdkWorkResourceData<McpInvocationRecord>> {
    let saved = service.append_invocation(record).await?;
    Ok(item_data(saved))
}

pub async fn upsert_category<R: McpRepository>(
    service: &McpService<R>,
    record: McpServerCategoryRecord,
) -> ApiResult<SdkWorkResourceData<McpServerCategoryRecord>> {
    let saved = service.upsert_category(record).await?;
    Ok(item_data(saved))
}

pub async fn upsert_server<R: McpRepository>(
    service: &McpService<R>,
    record: McpServerRecord,
) -> ApiResult<SdkWorkResourceData<McpServerRecord>> {
    let saved = service.upsert_server(record).await?;
    Ok(item_data(saved))
}

pub async fn delete_server<R: McpRepository>(
    service: &McpService<R>,
    tenant_id: u64,
    server_key: &str,
) -> ApiResult<SdkWorkResourceData<McpServerRecord>> {
    let deleted = service.delete_server(tenant_id, server_key).await?;
    Ok(item_data(deleted))
}

pub async fn upsert_connector<R: McpRepository>(
    service: &McpService<R>,
    record: McpConnectorRecord,
) -> ApiResult<SdkWorkResourceData<McpConnectorRecord>> {
    let saved = service.upsert_connector(record).await?;
    Ok(item_data(saved))
}

pub async fn delete_connector<R: McpRepository>(
    service: &McpService<R>,
    tenant_id: u64,
    server_id: u64,
    connector_key: &str,
) -> ApiResult<SdkWorkResourceData<McpConnectorRecord>> {
    let deleted = service
        .delete_connector(tenant_id, server_id, connector_key)
        .await?;
    Ok(item_data(deleted))
}

pub async fn upsert_tool<R: McpRepository>(
    service: &McpService<R>,
    record: McpToolRecord,
) -> ApiResult<SdkWorkResourceData<McpToolRecord>> {
    let saved = service.upsert_tool(record).await?;
    Ok(item_data(saved))
}

pub async fn upsert_resource<R: McpRepository>(
    service: &McpService<R>,
    record: McpResourceRecord,
) -> ApiResult<SdkWorkResourceData<McpResourceRecord>> {
    let saved = service.upsert_resource(record).await?;
    Ok(item_data(saved))
}

pub async fn upsert_prompt<R: McpRepository>(
    service: &McpService<R>,
    record: McpPromptRecord,
) -> ApiResult<SdkWorkResourceData<McpPromptRecord>> {
    let saved = service.upsert_prompt(record).await?;
    Ok(item_data(saved))
}
