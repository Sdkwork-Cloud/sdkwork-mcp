import { backendApiPath } from './paths';
import type { HttpClient } from '../http/client';

import type { AppendMcpInvocationCommand, CreateMcpServerCommand, McpConnectorRecord, McpInvocationRecord, McpPromptRecord, McpResourceRecord, McpServerCategoryRecord, McpServerRecord, McpToolRecord, PageInfo, UpdateMcpServerCommand, UpsertMcpConnectorCommand, UpsertMcpPromptCommand, UpsertMcpResourceCommand, UpsertMcpServerCategoryCommand, UpsertMcpToolCommand } from '../types';


export class McpMcpAdminApi {
  private client: HttpClient;

  constructor(client: HttpClient) {
    this.client = client;
  }


/** MCP mcpAdmin.listCategories */
  async listCategories(): Promise<Record<string, unknown>> {
    return this.client.get<Record<string, unknown>>(backendApiPath(`/mcp/categories`));
  }

/** MCP mcpAdmin.upsertCategory */
  async upsertCategory(body: UpsertMcpServerCategoryCommand): Promise<McpServerCategoryRecord> {
    return this.client.post<McpServerCategoryRecord>(backendApiPath(`/mcp/categories`), body, undefined, undefined, 'application/json');
  }

/** MCP mcpAdmin.listServers */
  async listServers(): Promise<Record<string, unknown>> {
    return this.client.get<Record<string, unknown>>(backendApiPath(`/mcp/servers`));
  }

/** MCP mcpAdmin.createServer */
  async createServer(body: CreateMcpServerCommand): Promise<McpServerRecord> {
    return this.client.post<McpServerRecord>(backendApiPath(`/mcp/servers`), body, undefined, undefined, 'application/json');
  }

/** MCP mcpAdmin.updateServer */
  async updateServer(serverKey: string, body: UpdateMcpServerCommand): Promise<McpServerRecord> {
    return this.client.put<McpServerRecord>(backendApiPath(`/mcp/servers/${serializePathParameter(serverKey, { name: 'serverKey', style: 'simple', explode: false })}`), body, undefined, undefined, 'application/json');
  }

/** MCP mcpAdmin.deleteServer */
  async deleteServer(serverKey: string): Promise<McpServerRecord> {
    return this.client.delete<McpServerRecord>(backendApiPath(`/mcp/servers/${serializePathParameter(serverKey, { name: 'serverKey', style: 'simple', explode: false })}`));
  }

/** MCP mcpAdmin.listConnectors */
  async listConnectors(serverId: string): Promise<Record<string, unknown>> {
    return this.client.get<Record<string, unknown>>(backendApiPath(`/mcp/servers/${serializePathParameter(serverId, { name: 'serverId', style: 'simple', explode: false })}/connectors`));
  }

/** MCP mcpAdmin.upsertConnector */
  async upsertConnector(serverId: string, body: UpsertMcpConnectorCommand): Promise<Record<string, unknown>> {
    return this.client.post<Record<string, unknown>>(backendApiPath(`/mcp/servers/${serializePathParameter(serverId, { name: 'serverId', style: 'simple', explode: false })}/connectors`), body, undefined, undefined, 'application/json');
  }

/** MCP mcpAdmin.deleteConnector */
  async deleteConnector(serverId: string, connectorKey: string): Promise<Record<string, unknown>> {
    return this.client.delete<Record<string, unknown>>(backendApiPath(`/mcp/servers/${serializePathParameter(serverId, { name: 'serverId', style: 'simple', explode: false })}/connectors/${serializePathParameter(connectorKey, { name: 'connectorKey', style: 'simple', explode: false })}`));
  }

/** MCP mcpAdmin.upsertTool */
  async upsertTool(serverId: string, body: UpsertMcpToolCommand): Promise<Record<string, unknown>> {
    return this.client.post<Record<string, unknown>>(backendApiPath(`/mcp/servers/${serializePathParameter(serverId, { name: 'serverId', style: 'simple', explode: false })}/tools`), body, undefined, undefined, 'application/json');
  }

/** MCP mcpAdmin.upsertResource */
  async upsertResource(serverId: string, body: UpsertMcpResourceCommand): Promise<Record<string, unknown>> {
    return this.client.post<Record<string, unknown>>(backendApiPath(`/mcp/servers/${serializePathParameter(serverId, { name: 'serverId', style: 'simple', explode: false })}/resources`), body, undefined, undefined, 'application/json');
  }

/** MCP mcpAdmin.upsertPrompt */
  async upsertPrompt(serverId: string, body: UpsertMcpPromptCommand): Promise<Record<string, unknown>> {
    return this.client.post<Record<string, unknown>>(backendApiPath(`/mcp/servers/${serializePathParameter(serverId, { name: 'serverId', style: 'simple', explode: false })}/prompts`), body, undefined, undefined, 'application/json');
  }

/** MCP mcpAdmin.listInvocations */
  async listInvocations(): Promise<Record<string, unknown>> {
    return this.client.get<Record<string, unknown>>(backendApiPath(`/mcp/invocations`));
  }

/** MCP mcpAdmin.appendInvocation */
  async appendInvocation(body: AppendMcpInvocationCommand): Promise<McpInvocationRecord> {
    return this.client.post<McpInvocationRecord>(backendApiPath(`/mcp/invocations`), body, undefined, undefined, 'application/json');
  }
}

export class McpApi {
  private client: HttpClient;
  public readonly mcpAdmin: McpMcpAdminApi;

  constructor(client: HttpClient) {
    this.client = client;
    this.mcpAdmin = new McpMcpAdminApi(client);
  }

}

export function createMcpApi(client: HttpClient): McpApi {
  return new McpApi(client);
}

function appendQueryString(path: string, rawQueryString: string): string {
  const query = rawQueryString.replace(/^\?+/, '');
  if (!query) {
    return path;
  }
  return path.includes('?') ? `${path}&${query}` : `${path}?${query}`;
}

interface PathParameterSpec {
  name: string;
  style: string;
  explode: boolean;
}

function serializePathParameter(value: unknown, spec: PathParameterSpec): string {
  if (value === undefined || value === null) {
    return '';
  }

  const style = spec.style || 'simple';
  if (Array.isArray(value)) {
    return serializePathArray(spec.name, value, style, spec.explode);
  }
  if (typeof value === 'object') {
    return serializePathObject(spec.name, value as Record<string, unknown>, style, spec.explode);
  }
  return pathPrefix(spec.name, style, false) + encodePathValue(serializePathPrimitive(value));
}

function serializePathArray(name: string, values: unknown[], style: string, explode: boolean): string {
  const serialized = values
    .filter((item) => item !== undefined && item !== null)
    .map((item) => encodePathValue(serializePathPrimitive(item)));
  if (serialized.length === 0) {
    return pathPrefix(name, style, false);
  }
  if (style === 'matrix') {
    return explode
      ? serialized.map((item) => `;${name}=${item}`).join('')
      : `;${name}=${serialized.join(',')}`;
  }
  return pathPrefix(name, style, false) + serialized.join(explode ? '.' : ',');
}

function serializePathObject(name: string, value: Record<string, unknown>, style: string, explode: boolean): string {
  const entries = Object.entries(value).filter(([, entryValue]) => entryValue !== undefined && entryValue !== null);
  if (entries.length === 0) {
    return pathPrefix(name, style, true);
  }
  if (style === 'matrix') {
    return explode
      ? entries.map(([key, entryValue]) => `;${encodePathValue(key)}=${encodePathValue(serializePathPrimitive(entryValue))}`).join('')
      : `;${name}=${entries.flatMap(([key, entryValue]) => [encodePathValue(key), encodePathValue(serializePathPrimitive(entryValue))]).join(',')}`;
  }
  const serialized = explode
    ? entries.map(([key, entryValue]) => `${encodePathValue(key)}=${encodePathValue(serializePathPrimitive(entryValue))}`).join(style === 'label' ? '.' : ',')
    : entries.flatMap(([key, entryValue]) => [encodePathValue(key), encodePathValue(serializePathPrimitive(entryValue))]).join(',');
  return pathPrefix(name, style, true) + serialized;
}

function pathPrefix(name: string, style: string, _objectValue: boolean): string {
  if (style === 'label') return '.';
  if (style === 'matrix') return `;${name}`;
  return '';
}

function encodePathValue(value: string): string {
  return encodeURIComponent(value);
}

function serializePathPrimitive(value: unknown): string {
  if (value instanceof Date) {
    return value.toISOString();
  }
  if (typeof value === 'object') {
    return JSON.stringify(value);
  }
  return String(value);
}
