import { useEffect, useState, type FormEvent } from 'react';
import { Link, useNavigate, useParams } from 'react-router-dom';
import { isBlank, trim } from '@sdkwork/utils';
import {
  Button,
  ErrorAlert,
  Field,
  LoadingState,
  PageHeader,
  TextArea,
  TextInput,
} from '@sdkwork/mcp-pc-commons';
import {
  listOwnedMcpServers,
  updateOwnMcpServer,
  useMCPClients,
  type UpdateOwnMcpServerCommand,
} from '@sdkwork/mcp-pc-core';

export function EditMcpServerPage() {
  const { serverKey: routeServerKey = '' } = useParams<{ serverKey: string }>();
  const serverKey = decodeURIComponent(routeServerKey);
  const clients = useMCPClients();
  const navigate = useNavigate();
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [form, setForm] = useState({
    name: '',
    description: '',
    categoryCode: '',
    tags: '',
    iconRef: '',
  });

  useEffect(() => {
    let active = true;
    setLoading(true);
    setError(null);
    void listOwnedMcpServers(clients)
      .then((servers) => {
        if (!active) return;
        const record = servers.find((item) => item.server_key === serverKey);
        if (!record) {
          setError(`MCP server ${serverKey} was not found in your workspace.`);
          return;
        }
        setForm({
          name: record.name ?? '',
          description: record.description ?? '',
          categoryCode: record.category_code ?? '',
          tags: (record.tags ?? []).join(', '),
          iconRef: record.icon_ref ?? '',
        });
      })
      .catch((cause: unknown) => {
        if (active) {
          setError(cause instanceof Error ? cause.message : String(cause));
        }
      })
      .finally(() => {
        if (active) setLoading(false);
      });
    return () => {
      active = false;
    };
  }, [clients, serverKey]);

  async function onSubmit(event: FormEvent) {
    event.preventDefault();
    setError(null);
    const command: UpdateOwnMcpServerCommand = {
      name: trim(form.name),
      ...(trim(form.description) ? { description: trim(form.description) } : {}),
      ...(trim(form.categoryCode) ? { category_code: trim(form.categoryCode) } : {}),
      tags: form.tags
        .split(',')
        .map((value) => trim(value))
        .filter((value) => value.length > 0),
      ...(trim(form.iconRef) ? { icon_ref: trim(form.iconRef) } : {}),
    };
    try {
      await updateOwnMcpServer(clients, serverKey, command);
      navigate('/console/mcp');
    } catch (cause) {
      setError(cause instanceof Error ? cause.message : String(cause));
    }
  }

  if (loading) {
    return <LoadingState label="Loading MCP server…" />;
  }

  return (
    <div>
      <PageHeader
        title={`Edit ${serverKey}`}
        description="Update metadata for an MCP server you own. Transport and server key stay immutable."
      />
      <p className="mb-4">
        <Link to="/console/mcp" className="text-sm font-medium text-blue-600 hover:text-blue-700">
          Back to My MCP Servers
        </Link>
      </p>
      {error ? <ErrorAlert message={error} /> : null}
      <form onSubmit={onSubmit} className="grid max-w-2xl gap-4">
        <Field label="Display name">
          <TextInput
            value={form.name}
            onChange={(event) => setForm({ ...form, name: event.target.value })}
            required
          />
        </Field>
        <Field label="Description">
          <TextArea
            value={form.description}
            onChange={(event) => setForm({ ...form, description: event.target.value })}
          />
        </Field>
        <Field label="Category code">
          <TextInput
            value={form.categoryCode}
            onChange={(event) => setForm({ ...form, categoryCode: event.target.value })}
          />
        </Field>
        <Field label="Tags" hint="Comma separated">
          <TextInput
            value={form.tags}
            onChange={(event) => setForm({ ...form, tags: event.target.value })}
          />
        </Field>
        <Field label="Icon reference">
          <TextInput
            value={form.iconRef}
            onChange={(event) => setForm({ ...form, iconRef: event.target.value })}
            placeholder="drive://spaces/.../nodes/..."
          />
        </Field>
        <div>
          <Button type="submit" disabled={isBlank(trim(form.name))}>
            Save changes
          </Button>
        </div>
      </form>
    </div>
  );
}
