export interface UpdateOwnMcpServerCommand {
  name?: string;
  description?: string;
  transport?: string;
  category_id?: string;
  category_code?: string;
  tags?: string[];
  icon_ref?: string;
}
