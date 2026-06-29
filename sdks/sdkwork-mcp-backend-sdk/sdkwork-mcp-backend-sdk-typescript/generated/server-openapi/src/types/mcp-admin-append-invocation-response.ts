import type { McpInvocationRecord } from './mcp-invocation-record';

export interface McpAdminAppendInvocationResponse {
  code: 0;
  data: unknown & Record<string, unknown>;
  /** Server-owned request correlation id. */
  traceId: string;
}
