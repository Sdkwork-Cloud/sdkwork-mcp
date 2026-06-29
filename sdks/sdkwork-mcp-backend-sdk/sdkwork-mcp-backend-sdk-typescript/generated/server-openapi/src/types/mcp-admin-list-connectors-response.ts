import type { McpConnectorRecord } from './mcp-connector-record';
import type { PageInfo } from './page-info';

export interface McpAdminListConnectorsResponse {
  code: 0;
  data: unknown & Record<string, unknown>;
  /** Server-owned request correlation id. */
  traceId: string;
}
