# Integrator Guide

Integration boundaries for **sdkwork-mcp** consumers.

## SDK families

| Family | Audience | Base path |
| --- | --- | --- |
| `sdkwork-mcp-app-sdk` | Marketplace/read clients (PC, H5, Flutter) | `/app/v3/api/mcp` |
| `sdkwork-mcp-backend-sdk` | Admin/operator consoles | `/backend/v3/api/mcp` |

Generated packages live under `sdks/`. Regenerate after OpenAPI changes:

```powershell
pnpm api:materialize
pnpm sdk:generate
```

## Response envelope

Generated TypeScript/Flutter clients unwrap `SdkWorkApiResponse.data` by default.

| Operation | `data` shape |
| --- | --- |
| List | `{ items: T[], pageInfo: PageInfo }` |
| Single resource | `{ item: T }` |
| Error | HTTP 4xx/5xx `application/problem+json` with numeric `code` and `traceId` |

## List query parameters

All MCP list routes accept `SdkWorkListQuery` query parameters per `API_SPEC.md` section 14.1:

| Parameter | Type | Default | Notes |
| --- | --- | --- | --- |
| `page` | integer | `1` | 1-based offset pagination |
| `page_size` | integer | `20` | Max `200` |
| `q` | string | — | Free-text filter (name, server key, description, category code, tags) |
| `cursor` | string | — | Rejected until cursor mode is implemented |

Invocation lists also accept optional `server_id` (backend admin and app-api).

Generated SDKs map `page_size` to `pageSize` (TypeScript) or the second positional argument (Flutter). Marketplace clients request `page_size=200` for catalog loads; console overview uses `page_size=20` for recent invocations.

## Auth and tenancy

- IAM session tokens via standard SDKWork web adapter headers
- Tenant context from authenticated principal; optional `x-sdkwork-tenant-id` for controlled overrides in admin flows

## File storage

MCP stores icon references only (`icon_ref`). Upload bytes through `@sdkwork/drive-app-sdk` on PC admin (`client.uploader.*`), then persist the returned `drive://` URI via admin MCP APIs. H5 and Flutter are browse-only until mobile admin/upload surfaces exist.

## Contract sources

- OpenAPI: `apis/app-api/mcp/`, `apis/backend-api/mcp/`
- Database: `database/contract/` (`ai_mcp_*` tables)
