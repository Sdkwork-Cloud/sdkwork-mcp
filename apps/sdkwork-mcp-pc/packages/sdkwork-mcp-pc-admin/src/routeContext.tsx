import { createContext, useContext, type ReactNode } from "react";

export interface McpAdminRouteContextValue {
  /**
   * Base path of the admin server list. The module's own PC root mounts at
   * `/admin/servers`; composing hosts may remount the admin surface at a
   * different resource path (for example `/admin/mcp/servers`) and supply
   * their base through {@link McpAdminRouteProvider}.
   */
  serversBasePath: string;
}

const McpAdminRouteContext = createContext<McpAdminRouteContextValue>({
  serversBasePath: "/admin/servers",
});

export function McpAdminRouteProvider({
  serversBasePath,
  children,
}: McpAdminRouteContextValue & { children: ReactNode }) {
  return (
    <McpAdminRouteContext.Provider value={{ serversBasePath }}>
      {children}
    </McpAdminRouteContext.Provider>
  );
}

export function useMcpAdminServersBasePath(): string {
  return useContext(McpAdminRouteContext).serversBasePath;
}
