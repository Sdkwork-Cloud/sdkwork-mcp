import { useRef, useState, type FormEvent } from 'react';
import { isBlank, trim } from '@sdkwork/utils';
import {
  Button,
  ErrorAlert,
  Field,
  PageHeader,
  SelectInput,
  TextArea,
  TextInput,
} from '@sdkwork/mcp-pc-commons';
import {
  createOwnMcpServer,
  uploadServerIcon,
  useMCPClients,
  type CreateOwnMcpServerCommand,
} from '@sdkwork/mcp-pc-core';

type TransportKind = 'stdio' | 'sse' | 'http' | 'streamable-http';

const EMPTY_FORM = {
  serverKey: '',
  name: '',
  description: '',
  transport: 'streamable-http' as TransportKind,
  categoryCode: '',
  tags: '',
  iconRef: '',
  endpointUrl: '',
  commandRef: '',
};

export function RegisterMcpServerPage() {
  const clients = useMCPClients();
  const iconInputRef = useRef<HTMLInputElement>(null);
  const [form, setForm] = useState(EMPTY_FORM);
  const [error, setError] = useState<string | null>(null);
  const [uploading, setUploading] = useState(false);
  const [created, setCreated] = useState<string | null>(null);

  async function onUploadIcon() {
    const file = iconInputRef.current?.files?.[0];
    if (!file) {
      setError('Select an icon image to upload through sdkwork-drive.');
      return;
    }
    setUploading(true);
    setError(null);
    try {
      const iconRef = await uploadServerIcon(clients.drive, file);
      setForm((current) => ({ ...current, iconRef }));
    } catch (cause) {
      setError(cause instanceof Error ? cause.message : String(cause));
    } finally {
      setUploading(false);
    }
  }

  async function onSubmit(event: FormEvent) {
    event.preventDefault();
    setError(null);
    setCreated(null);
    const command: CreateOwnMcpServerCommand = {
      server_key: trim(form.serverKey),
      name: trim(form.name),
      ...(trim(form.description) ? { description: trim(form.description) } : {}),
      transport: form.transport,
      ...(trim(form.categoryCode) ? { category_code: trim(form.categoryCode) } : {}),
      tags: form.tags
        .split(',')
        .map((value) => trim(value))
        .filter((value) => value.length > 0),
      ...(trim(form.iconRef) ? { icon_ref: trim(form.iconRef) } : {}),
    };
    try {
      const record = await createOwnMcpServer(clients, command);
      setCreated(record.server_key);
      setForm(EMPTY_FORM);
    } catch (cause) {
      setError(cause instanceof Error ? cause.message : String(cause));
    }
  }

  return (
    <div>
      <PageHeader
        title="Register MCP Server"
        description="Register an MCP server into your workspace. The server becomes tenant-visible immediately; publication scope stays admin-managed."
      />
      {error ? <ErrorAlert message={error} /> : null}
      {created ? (
        <p className="mb-4 rounded-lg bg-emerald-50 px-3 py-2 text-sm text-emerald-800">
          Registered MCP server {created}.
        </p>
      ) : null}
      <form onSubmit={onSubmit} className="grid max-w-2xl gap-4">
        <Field label="Server key">
          <TextInput
            value={form.serverKey}
            onChange={(event) => setForm({ ...form, serverKey: event.target.value })}
            placeholder="mcp.my-workspace-server"
            required
          />
        </Field>
        <Field label="Display name">
          <TextInput
            value={form.name}
            onChange={(event) => setForm({ ...form, name: event.target.value })}
            placeholder="My Workspace Server"
            required
          />
        </Field>
        <Field label="Description">
          <TextArea
            value={form.description}
            onChange={(event) => setForm({ ...form, description: event.target.value })}
            placeholder="What this MCP server provides"
          />
        </Field>
        <Field label="Transport">
          <SelectInput
            value={form.transport}
            onChange={(event) =>
              setForm({ ...form, transport: event.target.value as TransportKind })
            }
          >
            <option value="streamable-http">streamable-http</option>
            <option value="http">http</option>
            <option value="stdio">stdio</option>
            <option value="sse">sse</option>
          </SelectInput>
        </Field>
        {form.transport === 'stdio' ? (
          <Field label="Command reference" hint="Drive reference to the local command descriptor">
            <TextInput
              value={form.commandRef}
              onChange={(event) => setForm({ ...form, commandRef: event.target.value })}
              placeholder="drive://spaces/.../nodes/..."
            />
          </Field>
        ) : (
          <Field label="Endpoint URL">
            <TextInput
              value={form.endpointUrl}
              onChange={(event) => setForm({ ...form, endpointUrl: event.target.value })}
              placeholder="https://mcp.example.com/sse"
              type="url"
            />
          </Field>
        )}
        <Field label="Category code">
          <TextInput
            value={form.categoryCode}
            onChange={(event) => setForm({ ...form, categoryCode: event.target.value })}
            placeholder="general"
          />
        </Field>
        <Field label="Tags" hint="Comma separated">
          <TextInput
            value={form.tags}
            onChange={(event) => setForm({ ...form, tags: event.target.value })}
            placeholder="workspace, tools"
          />
        </Field>
        <Field label="Icon" hint="Uploaded through sdkwork-drive">
          <div className="flex items-center gap-3">
            <input ref={iconInputRef} type="file" accept="image/*" />
            <Button type="button" variant="secondary" onClick={onUploadIcon} disabled={uploading}>
              {uploading ? 'Uploading...' : 'Upload Icon'}
            </Button>
          </div>
          {trim(form.iconRef) ? (
            <span className="text-xs text-slate-500">{form.iconRef}</span>
          ) : null}
        </Field>
        <div>
          <Button type="submit" disabled={isBlank(trim(form.serverKey)) || uploading}>
            Register Server
          </Button>
        </div>
      </form>
    </div>
  );
}
