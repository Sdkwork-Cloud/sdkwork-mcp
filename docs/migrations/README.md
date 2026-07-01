# Migrations

Database migrations for **sdkwork-mcp** live under repository `database/`:

- Baseline DDL: `database/ddl/baseline/postgres/0001_mcp_baseline.sql`
- Contract: `database/contract/schema.yaml` (version **1.1.0**)
- Validation: `pnpm db:validate`

Application-level migration notes belong in this directory only when a release requires operator-facing steps beyond DDL.
