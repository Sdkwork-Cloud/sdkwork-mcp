import type {
  AppendMcpInvocationCommand,
  CreateMcpServerCommand,
  McpConnectorRecord,
  McpInvocationRecord,
  McpPromptRecord,
  McpResourceRecord,
  McpServerCategoryRecord,
  McpServerRecord,
  McpToolRecord,
  UpdateMcpServerCommand,
  UpsertMcpConnectorCommand,
  UpsertMcpPromptCommand,
  UpsertMcpResourceCommand,
  UpsertMcpServerCategoryCommand,
  UpsertMcpToolCommand,
} from 'sdkwork-mcp-backend-sdk-generated-typescript/src/types';

import type { MCPClients } from '../clients';
import { unwrapSdkWorkPage } from '../sdk/sdkPage';

const catalogListParams = { pageSize: 200 } as const;

export async function listAdminCategories(clients: MCPClients) {
  const response = await clients.backend.mcp.mcpAdmin.listCategories(catalogListParams);
  return unwrapSdkWorkPage<McpServerCategoryRecord>(response).items;
}

export async function upsertAdminCategory(
  clients: MCPClients,
  command: UpsertMcpServerCategoryCommand,
) {
  return clients.backend.mcp.mcpAdmin.upsertCategory(command);
}

export async function listAdminServers(clients: MCPClients) {
  const response = await clients.backend.mcp.mcpAdmin.listServers(catalogListParams);
  return unwrapSdkWorkPage<McpServerRecord>(response).items;
}

export async function createAdminServer(clients: MCPClients, command: CreateMcpServerCommand) {
  return clients.backend.mcp.mcpAdmin.createServer(command);
}

export async function updateAdminServer(
  clients: MCPClients,
  serverKey: string,
  command: UpdateMcpServerCommand,
) {
  return clients.backend.mcp.mcpAdmin.updateServer(serverKey, command);
}

export async function deleteAdminServer(clients: MCPClients, serverKey: string) {
  return clients.backend.mcp.mcpAdmin.deleteServer(serverKey);
}

export async function listAdminConnectors(clients: MCPClients, serverId: string) {
  const response = await clients.backend.mcp.mcpAdmin.listConnectors(serverId, catalogListParams);
  return unwrapSdkWorkPage<McpConnectorRecord>(response).items;
}

export async function upsertAdminConnector(
  clients: MCPClients,
  serverId: string,
  command: UpsertMcpConnectorCommand,
) {
  const response = await clients.backend.mcp.mcpAdmin.upsertConnector(serverId, command);
  return unwrapSdkWorkPage<McpConnectorRecord>(response).items;
}

export async function deleteAdminConnector(
  clients: MCPClients,
  serverId: string,
  connectorKey: string,
) {
  const response = await clients.backend.mcp.mcpAdmin.deleteConnector(serverId, connectorKey);
  return unwrapSdkWorkPage<McpConnectorRecord>(response).items;
}

export async function upsertAdminTool(
  clients: MCPClients,
  serverId: string,
  command: UpsertMcpToolCommand,
) {
  const response = await clients.backend.mcp.mcpAdmin.upsertTool(serverId, command);
  return unwrapSdkWorkPage<McpToolRecord>(response).items;
}

export async function upsertAdminResource(
  clients: MCPClients,
  serverId: string,
  command: UpsertMcpResourceCommand,
) {
  const response = await clients.backend.mcp.mcpAdmin.upsertResource(serverId, command);
  return unwrapSdkWorkPage<McpResourceRecord>(response).items;
}

export async function upsertAdminPrompt(
  clients: MCPClients,
  serverId: string,
  command: UpsertMcpPromptCommand,
) {
  const response = await clients.backend.mcp.mcpAdmin.upsertPrompt(serverId, command);
  return unwrapSdkWorkPage<McpPromptRecord>(response).items;
}

export async function listAdminInvocations(clients: MCPClients) {
  const response = await clients.backend.mcp.mcpAdmin.listInvocations({ pageSize: 100 });
  return unwrapSdkWorkPage<McpInvocationRecord>(response).items;
}

export async function appendAdminInvocation(
  clients: MCPClients,
  command: AppendMcpInvocationCommand,
) {
  return clients.backend.mcp.mcpAdmin.appendInvocation(command);
}
