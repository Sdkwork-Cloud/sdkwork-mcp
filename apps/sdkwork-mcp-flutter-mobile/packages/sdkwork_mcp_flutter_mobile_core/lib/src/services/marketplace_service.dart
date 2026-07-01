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

List<T> _readPageItems<T>(
  dynamic data,
  T Function(Map<String, dynamic> json) fromJson,
) {
  if (data is! Map) {
    return const [];
  }
  final items = data['items'];
  if (items is! List) {
    return const [];
  }
  return items
      .whereType<Map>()
      .map((entry) => fromJson(Map<String, dynamic>.from(entry)))
      .toList(growable: false);
}

McpServerRecord? _readResourceItem(dynamic data) {
  if (data is! Map) {
    return null;
  }
  final item = data['item'];
  if (item is! Map) {
    return null;
  }
  return McpServerRecord.fromJson(Map<String, dynamic>.from(item));
}

const _catalogPageSize = 200;

Future<MarketplaceCatalog> fetchMarketplaceCatalog(SdkworkAppClient client) async {
  final categoriesResponse = await client.mcp.listCategories(null, _catalogPageSize);
  final serversResponse = await client.mcp.listServers(null, _catalogPageSize);
  return MarketplaceCatalog(
    categories: _readPageItems(
      categoriesResponse?.data,
      McpServerCategoryRecord.fromJson,
    ),
    servers: _readPageItems(
      serversResponse?.data,
      McpServerRecord.fromJson,
    ),
  );
}

Future<ServerDetailBundle> fetchServerDetail(
  SdkworkAppClient client,
  String serverKey,
) async {
  final serverResponse = await client.mcp.getServer(serverKey);
  final server = _readResourceItem(serverResponse?.data);
  if (server == null) {
    throw StateError('MCP server not found: $serverKey');
  }
  final serverId = server.id;
  final results = await Future.wait([
    client.mcp.listTools(serverId, null, _catalogPageSize),
    client.mcp.listResources(serverId, null, _catalogPageSize),
    client.mcp.listPrompts(serverId, null, _catalogPageSize),
  ]);
  return ServerDetailBundle(
    server: server,
    tools: _readPageItems(results[0]?.data, McpToolRecord.fromJson),
    resources: _readPageItems(results[1]?.data, McpResourceRecord.fromJson),
    prompts: _readPageItems(results[2]?.data, McpPromptRecord.fromJson),
  );
}
