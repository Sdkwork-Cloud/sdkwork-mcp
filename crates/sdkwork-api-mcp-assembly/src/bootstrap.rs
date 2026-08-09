//! Gateway bootstrap for sdkwork-mcp.
//! Multi-surface merges mount shared infrastructure routes once at the assembly layer.

use axum::Router;
use sdkwork_intelligence_mcp_repository_sqlx::SqlxMcpRepository;
use sdkwork_intelligence_mcp_service::McpService;
use sdkwork_mcp_database_host::bootstrap_mcp_database_from_env;
use sdkwork_routes_mcp_app_api::DbReadinessCheck;
use sdkwork_web_bootstrap::{
    assemble_multi_surface_router, ApiAssemblyContribution, ServiceRouterConfig,
};
use sqlx::PgPool;
use std::sync::Arc;

pub struct ApiAssembly {
    pub router: Router,
}

struct McpRuntime {
    service: Arc<McpService<SqlxMcpRepository>>,
    default_tenant_id: u64,
    pool: PgPool,
}

impl McpRuntime {
    async fn bootstrap_from_env() -> Result<Self, String> {
        let host = bootstrap_mcp_database_from_env().await?;
        let pool = host
            .postgres_pool()
            .ok_or_else(|| "mcp runtime requires postgres database pool".to_string())?
            .clone();
        let repository = SqlxMcpRepository::new(pool.clone());
        let service = Arc::new(McpService::new(repository));
        let default_tenant_id = std::env::var("SDKWORK_MCP_TENANT_ID")
            .ok()
            .and_then(|value| value.parse::<u64>().ok())
            .unwrap_or(100_001);
        Ok(Self {
            service,
            default_tenant_id,
            pool,
        })
    }
}

pub async fn assemble_api_router() -> Result<ApiAssembly, String> {
    let runtime = McpRuntime::bootstrap_from_env().await?;
    let service = runtime.service.clone();
    let tenant_id = runtime.default_tenant_id;
    let pool = runtime.pool.clone();

    let app_router =
        sdkwork_routes_mcp_app_api::gateway_mount_business(service.clone(), tenant_id).await;
    let backend_router =
        sdkwork_routes_mcp_backend_api::gateway_mount_business(service, tenant_id).await;

    let router = assemble_multi_surface_router(
        [app_router, backend_router],
        ServiceRouterConfig::default().with_readiness_check(Arc::new(DbReadinessCheck::new(pool))),
    );

    Ok(ApiAssembly { router })
}

/// Builds the MCP App API as a composing-owner contribution. The returned
/// router carries only business routes; the composing gateway supplies the
/// web framework layer, domain context injection, and readiness aggregation.
pub async fn assemble_app_api_contribution() -> Result<ApiAssemblyContribution, String> {
    let runtime = McpRuntime::bootstrap_from_env().await?;
    let service = runtime.service.clone();
    let tenant_id = runtime.default_tenant_id;
    let pool = runtime.pool.clone();

    let route_manifest = sdkwork_routes_mcp_app_api::app_route_manifest();
    let router = sdkwork_routes_mcp_app_api::business_router(
        sdkwork_routes_mcp_app_api::AppState {
            service,
            default_tenant_id: tenant_id,
            readiness: None,
        },
    );
    ApiAssemblyContribution::from_manifest(
        "sdkwork-mcp",
        "SDKWork MCP App API",
        router,
        route_manifest,
        vec![Arc::new(sdkwork_routes_mcp_app_api::McpAppContextInjector)],
        Arc::new(DbReadinessCheck::new(pool)),
    )
}

/// Builds the MCP Backend API as a composing-owner contribution.
pub async fn assemble_backend_api_contribution() -> Result<ApiAssemblyContribution, String> {
    let runtime = McpRuntime::bootstrap_from_env().await?;
    let service = runtime.service.clone();
    let tenant_id = runtime.default_tenant_id;
    let pool = runtime.pool.clone();

    let route_manifest = sdkwork_routes_mcp_backend_api::backend_route_manifest();
    let router = sdkwork_routes_mcp_backend_api::business_router(
        sdkwork_routes_mcp_backend_api::BackendState {
            service,
            default_tenant_id: tenant_id,
            readiness: None,
        },
    );
    ApiAssemblyContribution::from_manifest(
        "sdkwork-mcp",
        "SDKWork MCP Backend API",
        router,
        route_manifest,
        vec![Arc::new(sdkwork_routes_mcp_backend_api::McpBackendContextInjector)],
        Arc::new(DbReadinessCheck::new(pool)),
    )
}
