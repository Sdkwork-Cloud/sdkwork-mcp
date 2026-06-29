import type { McpInvocationRecord } from './mcp-invocation-record';
import type { PageInfo } from './page-info';

export interface McpListInvocationsResponse {
  code: 0;
  data: unknown & Record<string, unknown>;
  /** Server-owned request correlation id. */
  traceId: string;
}
