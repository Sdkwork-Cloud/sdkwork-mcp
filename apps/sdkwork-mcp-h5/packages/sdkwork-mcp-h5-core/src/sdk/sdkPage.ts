import type { SdkWorkPageData } from '@sdkwork/utils';

export type SdkWorkPage<T> = SdkWorkPageData<T>;

export function unwrapSdkWorkPage<T>(value: Record<string, unknown>): SdkWorkPage<T> {
  return value as SdkWorkPage<T>;
}
