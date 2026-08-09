//! Permission codes for the SDKWork MCP domain (all prefixed `mcp.`).

/// Read the tenant MCP marketplace catalog (categories, servers, capabilities).
pub const PERM_MARKETPLACE_READ: &str = "mcp.marketplace.read";
/// Read tenant MCP invocation activity.
pub const PERM_INVOCATIONS_READ: &str = "mcp.invocations.read";
/// Self-service create of MCP servers owned by the authenticated user.
pub const PERM_SERVERS_CREATE: &str = "mcp.servers.create";
/// Self-service update of MCP servers owned by the authenticated user.
pub const PERM_SERVERS_UPDATE: &str = "mcp.servers.update";
/// Self-service delete of MCP servers owned by the authenticated user.
pub const PERM_SERVERS_DELETE: &str = "mcp.servers.delete";
/// Self-service connector attachment to MCP servers owned by the authenticated user.
pub const PERM_CONNECTORS_CREATE: &str = "mcp.connectors.create";
/// Self-service connector removal from MCP servers owned by the authenticated user.
pub const PERM_CONNECTORS_DELETE: &str = "mcp.connectors.delete";
/// Admin manage of MCP servers, connectors, tools, resources, and prompts.
pub const PERM_ADMIN_SERVER_MANAGE: &str = "mcp.admin.server.manage";
/// Admin manage of MCP marketplace categories.
pub const PERM_ADMIN_CATEGORY_MANAGE: &str = "mcp.admin.category.manage";
/// Admin read of MCP invocation audit logs.
pub const PERM_ADMIN_INVOCATION_READ: &str = "mcp.admin.invocation.read";
/// Admin read of MCP marketplace admin metadata.
pub const PERM_ADMIN_MARKETPLACE_READ: &str = "mcp.admin.marketplace.read";
