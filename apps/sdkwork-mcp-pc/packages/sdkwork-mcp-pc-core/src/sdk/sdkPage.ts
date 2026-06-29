import type { PageInfo } from 'sdkwork-mcp-app-sdk-generated-typescript/src/types/page-info';

export type SdkWorkPage<T> = {
  items: T[];
  pageInfo?: PageInfo;
};

export function unwrapSdkWorkPage<T>(value: Record<string, unknown>): SdkWorkPage<T> {
  return value as SdkWorkPage<T>;
}
