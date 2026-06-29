import type { McpResourceRecord } from './mcp-resource-record';
import type { PageInfo } from './page-info';

export interface McpAdminUpsertResourceResponse {
  code: 0;
  data: unknown & Record<string, unknown>;
  /** Server-owned request correlation id. */
  traceId: string;
}
