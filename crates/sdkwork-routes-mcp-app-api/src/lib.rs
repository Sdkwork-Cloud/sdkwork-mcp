use std::sync::Arc;

mod handlers;
mod health;
pub mod http_route_manifest;
mod paths;
mod ports;
mod web_bootstrap;

use axum::{
    extract::{Extension, Path, Query, State},
    http::{HeaderMap, StatusCode},
    response::Response,
    routing::get,
    Json, Router,
};
use sdkwork_intelligence_mcp_service::McpService;
use sdkwork_web_core::{HttpRouteManifest, WebRequestContext};
use sqlx::PgPool;

pub use handlers::{
    finish_api_json, get_server, get_tool, list_categories, list_invocations, list_prompts,
    list_resources, list_servers, list_tools, ok_json, resolve_tenant_id, McpInvocationListQuery,
    SdkWorkListQuery, SharedMcpService,
};
pub use health::DbReadinessCheck;
pub use http_route_manifest::app_route_manifest;
pub use ports::McpAppRequestContext;
pub use web_bootstrap::{
    mcp_public_path_prefixes, wrap_router_with_web_framework, wrap_router_with_web_framework_from_env,
};

#[derive(Clone)]
pub struct AppState<R: sdkwork_intelligence_mcp_service::McpRepository> {
    pub service: SharedMcpService<R>,
    pub default_tenant_id: u64,
    pub readiness: Option<DbReadinessCheck>,
}

fn business_routes<R>() -> Router<AppState<R>>
where
    R: sdkwork_intelligence_mcp_service::McpRepository + Clone + Send + Sync + 'static,
{
    Router::new()
        .route(paths::CATEGORIES_LIST, get(list_categories_handler))
        .route(paths::SERVERS_LIST, get(list_servers_handler))
        .route(paths::SERVER_GET, get(get_server_handler))
        .route(paths::SERVER_TOOLS_LIST, get(list_tools_handler))
        .route(paths::SERVER_TOOL_GET, get(get_tool_handler))
        .route(paths::SERVER_RESOURCES_LIST, get(list_resources_handler))
        .route(paths::SERVER_PROMPTS_LIST, get(list_prompts_handler))
        .route(paths::INVOCATIONS_LIST, get(list_invocations_handler))
}

pub fn business_router<R>(state: AppState<R>) -> Router
where
    R: sdkwork_intelligence_mcp_service::McpRepository + Clone + Send + Sync + 'static,
{
    business_routes::<R>().with_state(state)
}

pub fn router<R>(state: AppState<R>) -> Router
where
    R: sdkwork_intelligence_mcp_service::McpRepository + Clone + Send + Sync + 'static,
{
    Router::new()
        .route(paths::LIVEZ, get(health::livez))
        .route(paths::READYZ, get(readyz_handler::<R>))
        .route(paths::HEALTHZ, get(healthz_handler::<R>))
        .merge(business_routes::<R>())
        .with_state(state)
}

async fn readyz_handler<R>(
    State(state): State<AppState<R>>,
) -> Result<Json<serde_json::Value>, (StatusCode, String)>
where
    R: sdkwork_intelligence_mcp_service::McpRepository + Send + Sync,
{
    health::readyz_with_state(state.readiness.clone()).await
}

async fn healthz_handler<R>(
    State(state): State<AppState<R>>,
) -> Result<Json<serde_json::Value>, (StatusCode, String)>
where
    R: sdkwork_intelligence_mcp_service::McpRepository + Send + Sync,
{
    health::healthz_with_state(state.readiness.clone()).await
}

fn resolve_request_tenant_id(
    context: Option<&Extension<McpAppRequestContext>>,
    headers: &HeaderMap,
    default_tenant_id: u64,
) -> u64 {
    context
        .map(|extension| extension.0.tenant_id)
        .unwrap_or_else(|| resolve_tenant_id(headers, default_tenant_id))
}

async fn list_categories_handler<R>(
    ctx: WebRequestContext,
    State(state): State<AppState<R>>,
    headers: HeaderMap,
    Query(query): Query<SdkWorkListQuery>,
    context: Option<Extension<McpAppRequestContext>>,
) -> Response
where
    R: sdkwork_intelligence_mcp_service::McpRepository + Send + Sync,
{
    finish_api_json(
        &ctx,
        async {
            let tenant_id =
                resolve_request_tenant_id(context.as_ref(), &headers, state.default_tenant_id);
            ok_json(list_categories(state.service.as_ref(), tenant_id, &query).await?)
        }
        .await,
    )
}

async fn list_servers_handler<R>(
    ctx: WebRequestContext,
    State(state): State<AppState<R>>,
    headers: HeaderMap,
    Query(query): Query<SdkWorkListQuery>,
    context: Option<Extension<McpAppRequestContext>>,
) -> Response
where
    R: sdkwork_intelligence_mcp_service::McpRepository + Send + Sync,
{
    finish_api_json(
        &ctx,
        async {
            let tenant_id =
                resolve_request_tenant_id(context.as_ref(), &headers, state.default_tenant_id);
            ok_json(list_servers(state.service.as_ref(), tenant_id, &query).await?)
        }
        .await,
    )
}

async fn get_server_handler<R>(
    ctx: WebRequestContext,
    State(state): State<AppState<R>>,
    headers: HeaderMap,
    Path(server_key): Path<String>,
    context: Option<Extension<McpAppRequestContext>>,
) -> Response
where
    R: sdkwork_intelligence_mcp_service::McpRepository + Send + Sync,
{
    finish_api_json(
        &ctx,
        async {
            let tenant_id =
                resolve_request_tenant_id(context.as_ref(), &headers, state.default_tenant_id);
            ok_json(
                get_server(state.service.as_ref(), tenant_id, server_key.as_str()).await?,
            )
        }
        .await,
    )
}

async fn list_tools_handler<R>(
    ctx: WebRequestContext,
    State(state): State<AppState<R>>,
    headers: HeaderMap,
    Path(server_id): Path<u64>,
    Query(query): Query<SdkWorkListQuery>,
    context: Option<Extension<McpAppRequestContext>>,
) -> Response
where
    R: sdkwork_intelligence_mcp_service::McpRepository + Send + Sync,
{
    finish_api_json(
        &ctx,
        async {
            let tenant_id =
                resolve_request_tenant_id(context.as_ref(), &headers, state.default_tenant_id);
            ok_json(list_tools(state.service.as_ref(), tenant_id, server_id, &query).await?)
        }
        .await,
    )
}

async fn get_tool_handler<R>(
    ctx: WebRequestContext,
    State(state): State<AppState<R>>,
    headers: HeaderMap,
    Path((server_id, tool_key)): Path<(u64, String)>,
    context: Option<Extension<McpAppRequestContext>>,
) -> Response
where
    R: sdkwork_intelligence_mcp_service::McpRepository + Send + Sync,
{
    finish_api_json(
        &ctx,
        async {
            let tenant_id =
                resolve_request_tenant_id(context.as_ref(), &headers, state.default_tenant_id);
            ok_json(
                get_tool(
                    state.service.as_ref(),
                    tenant_id,
                    server_id,
                    tool_key.as_str(),
                )
                .await?,
            )
        }
        .await,
    )
}

async fn list_resources_handler<R>(
    ctx: WebRequestContext,
    State(state): State<AppState<R>>,
    headers: HeaderMap,
    Path(server_id): Path<u64>,
    Query(query): Query<SdkWorkListQuery>,
    context: Option<Extension<McpAppRequestContext>>,
) -> Response
where
    R: sdkwork_intelligence_mcp_service::McpRepository + Send + Sync,
{
    finish_api_json(
        &ctx,
        async {
            let tenant_id =
                resolve_request_tenant_id(context.as_ref(), &headers, state.default_tenant_id);
            ok_json(list_resources(state.service.as_ref(), tenant_id, server_id, &query).await?)
        }
        .await,
    )
}

async fn list_prompts_handler<R>(
    ctx: WebRequestContext,
    State(state): State<AppState<R>>,
    headers: HeaderMap,
    Path(server_id): Path<u64>,
    Query(query): Query<SdkWorkListQuery>,
    context: Option<Extension<McpAppRequestContext>>,
) -> Response
where
    R: sdkwork_intelligence_mcp_service::McpRepository + Send + Sync,
{
    finish_api_json(
        &ctx,
        async {
            let tenant_id =
                resolve_request_tenant_id(context.as_ref(), &headers, state.default_tenant_id);
            ok_json(list_prompts(state.service.as_ref(), tenant_id, server_id, &query).await?)
        }
        .await,
    )
}

async fn list_invocations_handler<R>(
    ctx: WebRequestContext,
    State(state): State<AppState<R>>,
    headers: HeaderMap,
    Query(query): Query<McpInvocationListQuery>,
    context: Option<Extension<McpAppRequestContext>>,
) -> Response
where
    R: sdkwork_intelligence_mcp_service::McpRepository + Send + Sync,
{
    finish_api_json(
        &ctx,
        async {
            let tenant_id =
                resolve_request_tenant_id(context.as_ref(), &headers, state.default_tenant_id);
            ok_json(list_invocations(state.service.as_ref(), tenant_id, &query).await?)
        }
        .await,
    )
}

pub fn build_router<R>(service: Arc<McpService<R>>, default_tenant_id: u64) -> Router
where
    R: sdkwork_intelligence_mcp_service::McpRepository + Clone + Send + Sync + 'static,
{
    router(AppState {
        service,
        default_tenant_id,
        readiness: None,
    })
}

pub fn build_router_with_readiness<R>(
    service: Arc<McpService<R>>,
    default_tenant_id: u64,
    pool: PgPool,
) -> Router
where
    R: sdkwork_intelligence_mcp_service::McpRepository + Clone + Send + Sync + 'static,
{
    router(AppState {
        service,
        default_tenant_id,
        readiness: Some(DbReadinessCheck::new(pool)),
    })
}

pub async fn build_router_with_web_framework_from_env<R>(
    service: Arc<McpService<R>>,
    default_tenant_id: u64,
    pool: PgPool,
) -> Router
where
    R: sdkwork_intelligence_mcp_service::McpRepository + Clone + Send + Sync + 'static,
{
    wrap_router_with_web_framework_from_env(build_router_with_readiness(
        service,
        default_tenant_id,
        pool,
    ))
    .await
}

pub fn gateway_route_manifest() -> HttpRouteManifest {
    app_route_manifest()
}

pub async fn gateway_mount_business<R>(
    service: Arc<McpService<R>>,
    default_tenant_id: u64,
) -> Router
where
    R: sdkwork_intelligence_mcp_service::McpRepository + Clone + Send + Sync + 'static,
{
    wrap_router_with_web_framework_from_env(business_router(AppState {
        service,
        default_tenant_id,
        readiness: None,
    }))
    .await
}

pub async fn gateway_mount<R>(
    service: Arc<McpService<R>>,
    default_tenant_id: u64,
    pool: PgPool,
) -> Router
where
    R: sdkwork_intelligence_mcp_service::McpRepository + Clone + Send + Sync + 'static,
{
    build_router_with_web_framework_from_env(service, default_tenant_id, pool).await
}
