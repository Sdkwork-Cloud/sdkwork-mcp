class McpRoutes {
  static const marketplace = '/mcp/marketplace';
  static const serverDetailPrefix = '/mcp/servers/';

  static String serverDetailFor(String serverKey) => '$serverDetailPrefix$serverKey';

  static String? parseServerDetailKey(String? routeName) {
    if (routeName == null || !routeName.startsWith(serverDetailPrefix)) {
      return null;
    }
    final key = routeName.substring(serverDetailPrefix.length);
    return key.isEmpty ? null : key;
  }
}

void createRoutes() {}
