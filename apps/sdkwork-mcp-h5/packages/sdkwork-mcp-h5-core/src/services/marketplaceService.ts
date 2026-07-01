import type {
  McpPromptRecord,
  McpResourceRecord,
  McpServerCategoryRecord,
  McpServerRecord,
  McpToolRecord,
} from 'sdkwork-mcp-app-sdk-generated-typescript/src/types';

import { getMCPAppSdkClientWithSession } from '../sdk/mcpAppSdkClient';
import { unwrapSdkWorkPage } from '../sdk/sdkPage';

const catalogListParams = { pageSize: 200 } as const;

export async function fetchMarketplaceCatalog() {
  const client = getMCPAppSdkClientWithSession();
  const [categoryResponse, serverResponse] = await Promise.all([
    client.mcp.listCategories(catalogListParams),
    client.mcp.listServers(catalogListParams),
  ]);
  return {
    categories: unwrapSdkWorkPage<McpServerCategoryRecord>(categoryResponse).items,
    servers: unwrapSdkWorkPage<McpServerRecord>(serverResponse).items,
  };
}

export async function fetchServerDetail(serverKey: string) {
  const client = getMCPAppSdkClientWithSession();
  const server = await client.mcp.getServer(serverKey);
  const serverId = String(server.id);
  const [tools, resources, prompts] = await Promise.all([
    client.mcp.listTools(serverId, catalogListParams),
    client.mcp.listResources(serverId, catalogListParams),
    client.mcp.listPrompts(serverId, catalogListParams),
  ]);
  return {
    server,
    tools: unwrapSdkWorkPage<McpToolRecord>(tools).items,
    resources: unwrapSdkWorkPage<McpResourceRecord>(resources).items,
    prompts: unwrapSdkWorkPage<McpPromptRecord>(prompts).items,
  };
}
