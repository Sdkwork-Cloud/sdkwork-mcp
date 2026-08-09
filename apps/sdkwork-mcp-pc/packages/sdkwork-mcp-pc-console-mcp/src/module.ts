/**
 * Console capability module metadata for the MCP PC application root.
 * The webserver host composes this module through its own module entries.
 */
export const mcpConsoleModule = {
  id: 'console-mcp',
  label: 'My MCP Servers',
  surface: 'app-console',
  entries: [
    {
      resource: 'mcp',
      label: 'My MCP Servers',
      description: 'MCP servers registered by the authenticated user',
      order: 1,
    },
  ],
} as const;
