#!/usr/bin/env node

import test from 'node:test';
import assert from 'node:assert/strict';
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const repoRoot = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '../..');

function readText(relativePath) {
  return fs.readFileSync(path.join(repoRoot, relativePath), 'utf8');
}

test('shared response layer uses SdkWorkApiResponse envelope helpers', () => {
  const response = readText('crates/sdkwork-routes-mcp-shared/src/response.rs');
  assert.match(response, /SdkWorkApiResponse::success/);
  assert.match(response, /SdkWorkPageData/);
  assert.match(response, /SdkWorkResourceData/);
  assert.match(response, /problem_response/);
  assert.doesNotMatch(response, /items_response|record_response/);
});

test('app and backend business handlers finish through finish_api_json', () => {
  for (const crate of ['sdkwork-routes-mcp-app-api', 'sdkwork-routes-mcp-backend-api']) {
    const lib = readText(`crates/${crate}/src/lib.rs`);
    assert.match(lib, /finish_api_json/);
    assert.match(lib, /WebRequestContext/);
    const legacyMatches =
      lib.match(/Result<Json<serde_json::Value>, \(StatusCode, String\)>/g) ?? [];
    assert.equal(
      legacyMatches.length,
      2,
      `${crate} should only use legacy Json tuples on readyz/healthz probes`,
    );
  }
});

test('service ops return typed page and resource payloads', () => {
  const serviceOps = readText('crates/sdkwork-routes-mcp-shared/src/service_ops.rs');
  assert.match(serviceOps, /SdkWorkPageData/);
  assert.match(serviceOps, /SdkWorkResourceData/);
  assert.match(serviceOps, /paginate_items\(/);
  assert.match(serviceOps, /page_data\(/);
  assert.match(serviceOps, /SdkWorkListQuery/);
  assert.match(serviceOps, /\.tags/);
});
