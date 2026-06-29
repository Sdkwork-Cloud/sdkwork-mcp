import type { PageInfo } from 'sdkwork-mcp-app-sdk-generated-typescript/src/types/page-info';
import type {
  McpPromptRecord,
  McpResourceRecord,
  McpServerCategoryRecord,
  McpServerRecord,
  McpToolRecord,
} from 'sdkwork-mcp-app-sdk-generated-typescript/src/types';

import { getMCPAppSdkClientWithSession } from '../sdk/mcpAppSdkClient';

type SdkWorkPage<T> = {
  items: T[];
  pageInfo?: PageInfo;
};

function unwrapSdkWorkPage<T>(value: Record<string, unknown>): SdkWorkPage<T> {
  return value as SdkWorkPage<T>;
}

export async function fetchMarketplaceCatalog() {
  const client = getMCPAppSdkClientWithSession();
  const [categoryResponse, serverResponse] = await Promise.all([
    client.mcp.listCategories(),
    client.mcp.listServers(),
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
    client.mcp.listTools(serverId),
    client.mcp.listResources(serverId),
    client.mcp.listPrompts(serverId),
  ]);
  return {
    server,
    tools: unwrapSdkWorkPage<McpToolRecord>(tools).items,
    resources: unwrapSdkWorkPage<McpResourceRecord>(resources).items,
    prompts: unwrapSdkWorkPage<McpPromptRecord>(prompts).items,
  };
}
