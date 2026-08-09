export interface CreateOwnMcpServerCommand {
  server_key: string;
  name: string;
  description?: string;
  transport: string;
  category_id?: string;
  category_code?: string;
  tags?: string[];
  icon_ref?: string;
}
