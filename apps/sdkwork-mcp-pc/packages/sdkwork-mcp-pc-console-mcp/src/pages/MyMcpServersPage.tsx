import { useEffect, useState } from 'react';
import { Link } from 'react-router-dom';
import {
  Badge,
  DataPanel,
  EmptyState,
  ErrorAlert,
  formatMcpHealth,
  healthTone,
  LoadingState,
  PageHeader,
} from '@sdkwork/mcp-pc-commons';
import {
  deleteOwnMcpServer,
  listOwnedMcpServers,
  useAsyncResource,
  useMCPClients,
} from '@sdkwork/mcp-pc-core';

export function MyMcpServersPage() {
  const clients = useMCPClients();
  const { data, error, loading, reload } = useAsyncResource(
    () => listOwnedMcpServers(clients),
    [clients],
  );
  const [actionError, setActionError] = useState<string | null>(null);

  if (loading) {
    return <LoadingState label="Loading your MCP servers…" />;
  }

  if (error) {
    return <ErrorAlert message={error} />;
  }

  async function onDelete(serverKey: string) {
    setActionError(null);
    try {
      await deleteOwnMcpServer(clients, serverKey);
      await reload();
    } catch (cause) {
      setActionError(cause instanceof Error ? cause.message : String(cause));
    }
  }

  return (
    <div>
      <PageHeader
        title="My MCP Servers"
        description="MCP servers you registered are active in your workspace. Marketplace publication is managed by administrators."
      />
      <p className="mb-4">
        <Link
          to="/console/mcp/register"
          className="text-sm font-medium text-blue-600 hover:text-blue-700"
        >
          Register a new MCP server
        </Link>
      </p>
      {actionError ? <ErrorAlert message={actionError} /> : null}
      {!data || data.length === 0 ? (
        <EmptyState title="You have not registered any MCP servers yet" />
      ) : (
        <div className="grid gap-3">
          {data.map((server) => (
            <DataPanel key={server.id}>
              <div className="flex items-center justify-between gap-3 p-4">
                <div>
                  <p className="font-medium text-slate-900">{server.name}</p>
                  <p className="mt-1 text-xs text-slate-500">
                    {server.server_key} · {server.transport} · {server.visibility}
                  </p>
                </div>
                <div className="flex items-center gap-3">
                  <Badge tone={healthTone(server.health_status)}>
                    {formatMcpHealth(server.health_status)}
                  </Badge>
                  <button
                    type="button"
                    onClick={() => onDelete(server.server_key)}
                    className="rounded-lg px-3 py-1.5 text-sm font-medium text-rose-600 ring-1 ring-rose-200 hover:bg-rose-50"
                  >
                    Delete
                  </button>
                </div>
              </div>
            </DataPanel>
          ))}
        </div>
      )}
    </div>
  );
}
