import { createClient as createDriveSdkClient, type SdkworkDriveAppClient } from '@sdkwork/drive-app-sdk';
import type { AuthTokenManager } from '@sdkwork/sdk-common';
import { createClient as createAppSdkClient, type SdkworkAppClient } from '@sdkwork/mcp-app-sdk';
import {
  createClient as createBackendSdkClient,
  type SdkworkBackendClient,
} from '@sdkwork/mcp-backend-sdk';
import { normalizeApiBaseUrl, readRuntimeEnv } from '@sdkwork/mcp-pc-commons/runtime';

import { createMCPTokenManager } from './session';

export type MCPClientConfig = {
  appApiBaseUrl?: string;
  backendApiBaseUrl?: string;
  driveAppApiBaseUrl?: string;
  /**
   * @deprecated Dual-token App/Backend clients must not send identity projection
   * headers such as `x-sdkwork-tenant-id` (IAM TECH-03 / surface classification).
   * Tenant scope is derived from the verified dual-token session.
   */
  tenantId?: string;
  tokenManager?: AuthTokenManager;
};

export type MCPClients = {
  app: SdkworkAppClient;
  backend: SdkworkBackendClient;
  drive: SdkworkDriveAppClient;
};

let cachedClients: MCPClients | null = null;

function resolveAppApiBaseUrl(config?: MCPClientConfig): string {
  return normalizeApiBaseUrl(
    config?.appApiBaseUrl ?? readRuntimeEnv('VITE_SDKWORK_MCP_APP_API_BASE_URL') ?? '',
  );
}

function resolveBackendApiBaseUrl(config?: MCPClientConfig): string {
  return normalizeApiBaseUrl(
    config?.backendApiBaseUrl ?? readRuntimeEnv('VITE_SDKWORK_MCP_BACKEND_API_BASE_URL') ?? '',
  );
}

function resolveDriveAppApiBaseUrl(config?: MCPClientConfig): string {
  return normalizeApiBaseUrl(
    config?.driveAppApiBaseUrl ??
      readRuntimeEnv('VITE_SDKWORK_DRIVE_APP_API_BASE_URL') ??
      readRuntimeEnv('VITE_SDKWORK_MCP_APP_API_BASE_URL') ??
      '',
  );
}

function createAuthenticatedClientConfig(
  baseUrl: string,
  tokenManager: AuthTokenManager,
) {
  // Match skills-pc-core / BirdCoder: dual-token only — never project
  // `x-sdkwork-tenant-id` (API_SPEC §10.2 / surface classification 40001).
  // Tenant scope is derived from the verified dual-token session.
  void configTenantIdUnused;
  return {
    baseUrl,
    authMode: 'dual-token' as const,
    platform: 'pc' as const,
    tokenManager,
  };
}

// Keep deprecated tenantId off the wire even if a host still passes it.
const configTenantIdUnused = undefined as string | undefined;

export function createMCPClients(config: MCPClientConfig = {}): MCPClients {
  // Intentionally ignore config.tenantId — dual-token surfaces must not send
  // identity projection headers.
  void config.tenantId;
  const tokenManager = config.tokenManager ?? createMCPTokenManager();

  const app = createAppSdkClient(
    createAuthenticatedClientConfig(resolveAppApiBaseUrl(config), tokenManager),
  );
  app.setTokenManager(tokenManager);

  const backend = createBackendSdkClient(
    createAuthenticatedClientConfig(resolveBackendApiBaseUrl(config), tokenManager),
  );
  backend.setTokenManager(tokenManager);

  const drive = createDriveSdkClient(
    createAuthenticatedClientConfig(resolveDriveAppApiBaseUrl(config), tokenManager),
  );
  drive.setTokenManager(tokenManager);

  return { app, backend, drive };
}

export function getMCPClients(): MCPClients {
  if (!cachedClients) {
    cachedClients = createMCPClients();
  }
  return cachedClients;
}

export function resetMCPClients(): void {
  cachedClients = null;
}
