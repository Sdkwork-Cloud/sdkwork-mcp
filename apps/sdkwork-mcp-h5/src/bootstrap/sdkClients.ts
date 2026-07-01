import {
  createMCPAppSdkClientConfig,
  getMCPAppSdkClient,
  initMCPAppSdkClient,
  type SdkworkMCPAppClient,
} from "@sdkwork/mcp-h5-core/sdk/mcpAppSdkClient";
import { getSdkworkChatGlobalTokenManager } from "@sdkwork/mcp-h5-core/session";

import { resolveEnvironment } from "./environment";

export interface SdkworkMcpH5SdkClientInventory {
  apiBaseUrl: string;
  backendApiBaseUrl: string;
  app: SdkworkMCPAppClient;
  sdkFamilies: {
    app: string[];
  };
}

export function bootstrapSdkClients(): SdkworkMcpH5SdkClientInventory {
  const environment = resolveEnvironment();
  getSdkworkChatGlobalTokenManager();
  initMCPAppSdkClient(createMCPAppSdkClientConfig());

  return {
    apiBaseUrl: environment.apiBaseUrl,
    backendApiBaseUrl: environment.backendApiBaseUrl,
    app: getMCPAppSdkClient(),
    sdkFamilies: {
      app: ["sdkwork-mcp-app-sdk"],
    },
  };
}
