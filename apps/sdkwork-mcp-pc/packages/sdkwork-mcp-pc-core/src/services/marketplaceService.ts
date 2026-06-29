import type {
  McpInvocationRecord,
  McpPromptRecord,
  McpResourceRecord,
  McpServerCategoryRecord,
  McpServerRecord,
  McpToolRecord,
} from 'sdkwork-mcp-app-sdk-generated-typescript/src/types';

import type { MCPClients } from '../clients';
import { unwrapSdkWorkPage } from '../sdk/sdkPage';

export async function fetchMarketplaceCatalog(clients: MCPClients) {
  const [categoryResponse, serverResponse] = await Promise.all([
    clients.app.mcp.listCategories(),
    clients.app.mcp.listServers(),
  ]);
  return {
    categories: unwrapSdkWorkPage<McpServerCategoryRecord>(categoryResponse).items,
    servers: unwrapSdkWorkPage<McpServerRecord>(serverResponse).items,
  };
}

export async function fetchServerDetail(clients: MCPClients, serverKey: string) {
  const server = await clients.app.mcp.getServer(serverKey);
  const serverId = String(server.id);
  const [tools, resources, prompts] = await Promise.all([
    clients.app.mcp.listTools(serverId),
    clients.app.mcp.listResources(serverId),
    clients.app.mcp.listPrompts(serverId),
  ]);
  return {
    server,
    tools: unwrapSdkWorkPage<McpToolRecord>(tools).items,
    resources: unwrapSdkWorkPage<McpResourceRecord>(resources).items,
    prompts: unwrapSdkWorkPage<McpPromptRecord>(prompts).items,
  };
}

export async function fetchConsoleOverview(clients: MCPClients) {
  const [servers, invocations] = await Promise.all([
    clients.app.mcp.listServers(),
    clients.app.mcp.listInvocations(),
  ]);
  return {
    servers: unwrapSdkWorkPage<McpServerRecord>(servers).items,
    invocations: unwrapSdkWorkPage<McpInvocationRecord>(invocations).items.slice(0, 20),
  };
}
