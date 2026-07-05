import {
  createClient as createGeneratedMcpAppClient,
  SdkworkAppClient,
} from '../generated/server-openapi/src/index';
import type { SdkworkAppConfig } from '../generated/server-openapi/src/types/common';

export { SdkworkAppClient, createGeneratedMcpAppClient };
export type { SdkworkAppConfig };
export * from '../generated/server-openapi/src/types';
export * from '../generated/server-openapi/src/api';
export * from '../generated/server-openapi/src/http';
export * from '../generated/server-openapi/src/auth';

export type SdkworkMcpAppClient = SdkworkAppClient;

export function createMcpAppClient(config: SdkworkAppConfig): SdkworkMcpAppClient {
  return createGeneratedMcpAppClient(config);
}

export function createClient(config: SdkworkAppConfig): SdkworkMcpAppClient {
  return createMcpAppClient(config);
}
