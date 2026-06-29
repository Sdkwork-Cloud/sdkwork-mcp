import type { McpPromptRecord } from './mcp-prompt-record';
import type { PageInfo } from './page-info';

export interface McpListPromptsResponse {
  code: 0;
  data: unknown & Record<string, unknown>;
  /** Server-owned request correlation id. */
  traceId: string;
}
