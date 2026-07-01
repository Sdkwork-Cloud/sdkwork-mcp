# Developer Guide

Local setup and verification for **sdkwork-mcp**.

## Prerequisites

- Node.js + pnpm (workspace root)
- Rust toolchain (API crates)
- PostgreSQL when exercising persistence locally

## Common commands

```powershell
pnpm verify
pnpm api:materialize
pnpm sdk:generate
pnpm sdk:generate:check
cargo test --workspace
node ../sdkwork-specs/tools/check-api-response-envelope.mjs --workspace .
```

## Surfaces

| Surface | Path | SDK |
| --- | --- | --- |
| PC | `apps/sdkwork-mcp-pc` | `@sdkwork/mcp-pc-*` + generated MCP SDKs |
| H5 | `apps/sdkwork-mcp-h5` | `@sdkwork/mcp-h5-*` + generated MCP SDKs |
| Flutter | `apps/sdkwork-mcp-flutter-mobile` | `sdkwork-mcp-app-sdk-flutter` |

## API rules

- App read API: `/app/v3/api/mcp/*`
- Admin API: `/backend/v3/api/mcp/*`
- Success bodies use `SdkWorkApiResponse` (`code`, `data`, `traceId`)
- Lists return `data.items` + `data.pageInfo`; singles return `data.item`
- List routes accept `page`, `page_size` (default 20, max 200), and `q` per `SdkWorkListQuery`
- Do not call MCP HTTP endpoints with raw fetch/axios in production surfaces; use generated SDKs
- File icons must use `drive://spaces/{spaceId}/nodes/{nodeId}` references; uploads go through `@sdkwork/drive-app-sdk` on PC admin only

## Rust layout

Business HTTP mapping lives in `crates/sdkwork-routes-mcp-shared` (`service_ops`, `response`, `health`, record builders). App and backend route crates only wire Axum routes and IAM context.

See also [../../architecture/tech/TECH_ARCHITECTURE.md](../../architecture/tech/TECH_ARCHITECTURE.md).
