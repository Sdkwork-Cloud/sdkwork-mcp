# crates

Rust workspace members for **sdkwork-mcp** (MCP platform backend).

## Layer map

| Crate | Role |
|-------|------|
| `sdkwork-mcp-contract` | Domain records, enums, validation errors |
| `sdkwork-intelligence-mcp-service` | Business logic, repository trait, `sdkwork-drive-contract` icon validation |
| `sdkwork-intelligence-mcp-repository-sqlx` | PostgreSQL persistence (`ai_mcp_*`) |
| `sdkwork-routes-mcp-shared` | `SdkWorkApiResponse` mapping, service ops, record builders |
| `sdkwork-routes-mcp-app-api` | App-facing read routes (`/app/v3/api/mcp/*`) |
| `sdkwork-routes-mcp-backend-api` | Admin write/read routes (`/backend/v3/api/mcp/*`) |
| `sdkwork-mcp-standalone-gateway` | Axum server binary / bootstrap |
| `sdkwork-mcp-database-host` | Database host integration |
| `sdkwork-mcp-gateway-assembly` | Gateway cloud bundle assembly |

## Conventions

- Snowflake IDs via `sdkwork-id-core`; UUIDs via `sdkwork_utils_rust::uuid`
- Entity lifecycle: `lifecycle_status`; connector publish: `publish_status`
- HTTP success bodies use `SdkWorkApiResponse`; lists use `data.items` + `data.pageInfo`; singles use `data.item`
- Route crates delegate business logic to `sdkwork-routes-mcp-shared` (no duplicated HTTP/service glue)
- File icons: clients upload through `@sdkwork/drive-app-sdk`; service layer validates `icon_ref` via `sdkwork-drive-contract`

## Verification

```bash
cargo test --workspace
```
