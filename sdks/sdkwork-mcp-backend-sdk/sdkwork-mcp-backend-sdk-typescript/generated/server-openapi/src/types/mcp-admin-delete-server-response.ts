import type { McpServerRecord } from './mcp-server-record';

export interface McpAdminDeleteServerResponse {
  code: 0;
  data: unknown & Record<string, unknown>;
  /** Server-owned request correlation id. */
  traceId: string;
}
