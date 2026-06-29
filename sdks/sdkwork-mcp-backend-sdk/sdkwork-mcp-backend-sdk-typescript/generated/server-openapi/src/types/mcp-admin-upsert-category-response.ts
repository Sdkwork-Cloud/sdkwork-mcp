import type { McpServerCategoryRecord } from './mcp-server-category-record';

export interface McpAdminUpsertCategoryResponse {
  code: 0;
  data: unknown & Record<string, unknown>;
  /** Server-owned request correlation id. */
  traceId: string;
}
