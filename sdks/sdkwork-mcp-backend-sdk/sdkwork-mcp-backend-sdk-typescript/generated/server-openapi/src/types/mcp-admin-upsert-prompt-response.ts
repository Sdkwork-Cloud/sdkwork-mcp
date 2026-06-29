import type { McpPromptRecord } from './mcp-prompt-record';
import type { PageInfo } from './page-info';

export interface McpAdminUpsertPromptResponse {
  code: 0;
  data: unknown & Record<string, unknown>;
  /** Server-owned request correlation id. */
  traceId: string;
}
