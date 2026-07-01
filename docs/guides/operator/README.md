# Operator Guide

Deployment and health checks for **sdkwork-mcp**.

## Health endpoints

Both app and backend route surfaces expose:

| Route | Purpose |
| --- | --- |
| `/livez` | Process liveness |
| `/readyz` | Dependency readiness (PostgreSQL when configured) |
| `/healthz` | Alias of readyz |

Health probes return simple JSON (`{ "status": "ok" }`) and are exempt from business `SdkWorkApiResponse` envelopes.

## Runtime configuration

- Database URL: `MCP_DATABASE_URL` (see `specs/topology.spec.json`)
- Gateway assembly: `crates/sdkwork-mcp-gateway-assembly`
- Standalone binary: `crates/sdkwork-mcp-standalone-gateway`

## Verification before release

```powershell
pnpm verify
pnpm topology:validate
pnpm db:validate
node ../sdkwork-specs/tools/check-api-response-envelope.mjs --workspace .
```

## Deployment assets

- Docker: `deployments/docker/Dockerfile`
- Workflow manifest: `sdkwork.workflow.json`

See [../../architecture/tech/TECH_ARCHITECTURE.md](../../architecture/tech/TECH_ARCHITECTURE.md) for topology profiles.
