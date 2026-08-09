export interface UpsertOwnMcpConnectorCommand {
  connector_key: string;
  transport: string;
  endpoint_url?: string;
  command_ref?: string;
  args_json?: string;
  env_schema_json?: string;
  auth_type?: string;
  secret_ref?: string;
  timeout_ms?: number;
  retry_policy_json?: string;
}
