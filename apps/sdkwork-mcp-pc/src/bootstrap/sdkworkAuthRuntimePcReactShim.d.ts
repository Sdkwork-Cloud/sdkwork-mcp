import type { IamRuntime } from '@sdkwork/iam-runtime';

export type SdkworkAppbasePcAuthRuntimeSdkClient = unknown;

export interface CreateSdkworkAppbasePcAuthRuntimeOptions {
  app: {
    appId: string;
    deploymentMode: string;
    environment: string;
    platform?: string;
  };
  baseUrls: {
    appbaseAppApiBaseUrl: string;
  };
  createAppbaseAppClient?: () => unknown;
  localeProvider?: () => string | undefined;
  sdkClients?: readonly SdkworkAppbasePcAuthRuntimeSdkClient[];
  sessionBridge?: {
    clearSession: () => void;
    commitSession: (session: unknown) => unknown;
    readSession: () => unknown;
  };
  tokenManager?: unknown;
}

export interface SdkworkAppbasePcAuthRuntimeComposition {
  appbaseApp: unknown;
  contextStore: unknown;
  getRuntime(): IamRuntime;
  runtime: IamRuntime;
  sessionBridge?: unknown;
  tokenManager: unknown;
  tokenStore: unknown;
}

export function createSdkworkAppbasePcAuthRuntime(
  options: CreateSdkworkAppbasePcAuthRuntimeOptions,
): SdkworkAppbasePcAuthRuntimeComposition;
