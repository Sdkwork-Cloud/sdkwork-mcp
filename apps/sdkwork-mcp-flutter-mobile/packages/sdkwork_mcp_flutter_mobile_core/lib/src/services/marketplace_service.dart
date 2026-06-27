import 'package:sdkwork_mcp_app_sdk_generated_flutter/app_client.dart';
import 'package:sdkwork_mcp_app_sdk_generated_flutter/src/models.dart';

class MarketplaceCatalog {
  const MarketplaceCatalog({
    required this.categories,
    required this.servers,
  });

  final List<McpServerCategoryRecord> categories;
  final List<McpServerRecord> servers;
}

class ServerDetailBundle {
  const ServerDetailBundle({
    required this.server,
    required this.tools,
    required this.resources,
    required this.prompts,
  });

  final McpServerRecord server;
  final List<McpToolRecord> tools;
  final List<McpResourceRecord> resources;
  final List<McpPromptRecord> prompts;
}

Future<MarketplaceCatalog> fetchMarketplaceCatalog(SdkworkAppClient client) async {
  final results = await Future.wait([
    client.mcp.listCategories(),
    client.mcp.listServers(),
  ]);
  final categories = results[0] as McpServerCategoryListResponse?;
  final servers = results[1] as McpServerListResponse?;
  return MarketplaceCatalog(
    categories: categories?.items ?? const [],
    servers: servers?.items ?? const [],
  );
}

Future<ServerDetailBundle> fetchServerDetail(
  SdkworkAppClient client,
  String serverKey,
) async {
  final serverResponse = await client.mcp.getServer(serverKey);
  final server = serverResponse?.data;
  if (server == null) {
    throw StateError('MCP server not found: $serverKey');
  }
  final serverId = server.id;
  final results = await Future.wait([
    client.mcp.listTools(serverId),
    client.mcp.listResources(serverId),
    client.mcp.listPrompts(serverId),
  ]);
  final tools = results[0] as McpToolListResponse?;
  final resources = results[1] as McpResourceListResponse?;
  final prompts = results[2] as McpPromptListResponse?;
  return ServerDetailBundle(
    server: server,
    tools: tools?.items ?? const [],
    resources: resources?.items ?? const [],
    prompts: prompts?.items ?? const [],
  );
}
