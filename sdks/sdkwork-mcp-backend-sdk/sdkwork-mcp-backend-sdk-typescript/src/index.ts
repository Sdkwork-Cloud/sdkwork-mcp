import {
  createClient as createGeneratedMcpBackendClient,
  SdkworkBackendClient,
} from '../generated/server-openapi/src/index';
import type { SdkworkBackendConfig } from '../generated/server-openapi/src/types/common';

export { SdkworkBackendClient, createGeneratedMcpBackendClient };
export type { SdkworkBackendConfig };
export * from '../generated/server-openapi/src/types';
export * from '../generated/server-openapi/src/api';
export * from '../generated/server-openapi/src/http';
export * from '../generated/server-openapi/src/auth';

export type SdkworkMcpBackendClient = SdkworkBackendClient;

export function createMcpBackendClient(config: SdkworkBackendConfig): SdkworkMcpBackendClient {
  return createGeneratedMcpBackendClient(config);
}

export function createClient(config: SdkworkBackendConfig): SdkworkMcpBackendClient {
  return createMcpBackendClient(config);
}
