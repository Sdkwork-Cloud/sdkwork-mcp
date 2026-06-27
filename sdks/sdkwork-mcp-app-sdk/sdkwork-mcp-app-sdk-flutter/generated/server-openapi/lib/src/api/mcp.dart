import '../http/client.dart';
import '../models.dart';

import 'paths.dart';
import 'response_helpers.dart';


class McpApi {
  final HttpClient _client;

  McpApi(this._client);

  /// MCP mcp.listCategories
  Future<McpServerCategoryListResponse?> listCategories() async {
    final response = await _client.get(ApiPaths.appPath('/mcp/categories'));
    return (() {
      final map = sdkworkResponseAsMap(response);
      return map == null ? null : McpServerCategoryListResponse.fromJson(map);
    })();
  }

  /// MCP mcp.listServers
  Future<McpServerListResponse?> listServers() async {
    final response = await _client.get(ApiPaths.appPath('/mcp/servers'));
    return (() {
      final map = sdkworkResponseAsMap(response);
      return map == null ? null : McpServerListResponse.fromJson(map);
    })();
  }

  /// MCP mcp.getServer
  Future<McpServerRecordResponse?> getServer(String serverKey) async {
    final response = await _client.get(ApiPaths.appPath('/mcp/servers/${serializePathParameter(serverKey, const PathParameterSpec('serverKey', 'simple', false))}'));
    return (() {
      final map = sdkworkResponseAsMap(response);
      return map == null ? null : McpServerRecordResponse.fromJson(map);
    })();
  }

  /// MCP mcp.listTools
  Future<McpToolListResponse?> listTools(int serverId) async {
    final response = await _client.get(ApiPaths.appPath('/mcp/servers/${serializePathParameter(serverId, const PathParameterSpec('serverId', 'simple', false))}/tools'));
    return (() {
      final map = sdkworkResponseAsMap(response);
      return map == null ? null : McpToolListResponse.fromJson(map);
    })();
  }

  /// MCP mcp.getTool
  Future<McpToolRecordResponse?> getTool(int serverId, String toolKey) async {
    final response = await _client.get(ApiPaths.appPath('/mcp/servers/${serializePathParameter(serverId, const PathParameterSpec('serverId', 'simple', false))}/tools/${serializePathParameter(toolKey, const PathParameterSpec('toolKey', 'simple', false))}'));
    return (() {
      final map = sdkworkResponseAsMap(response);
      return map == null ? null : McpToolRecordResponse.fromJson(map);
    })();
  }

  /// MCP mcp.listResources
  Future<McpResourceListResponse?> listResources(int serverId) async {
    final response = await _client.get(ApiPaths.appPath('/mcp/servers/${serializePathParameter(serverId, const PathParameterSpec('serverId', 'simple', false))}/resources'));
    return (() {
      final map = sdkworkResponseAsMap(response);
      return map == null ? null : McpResourceListResponse.fromJson(map);
    })();
  }

  /// MCP mcp.listPrompts
  Future<McpPromptListResponse?> listPrompts(int serverId) async {
    final response = await _client.get(ApiPaths.appPath('/mcp/servers/${serializePathParameter(serverId, const PathParameterSpec('serverId', 'simple', false))}/prompts'));
    return (() {
      final map = sdkworkResponseAsMap(response);
      return map == null ? null : McpPromptListResponse.fromJson(map);
    })();
  }

  /// MCP mcp.listInvocations
  Future<McpInvocationListResponse?> listInvocations() async {
    final response = await _client.get(ApiPaths.appPath('/mcp/invocations'));
    return (() {
      final map = sdkworkResponseAsMap(response);
      return map == null ? null : McpInvocationListResponse.fromJson(map);
    })();
  }
}

class PathParameterSpec {
  final String name;
  final String style;
  final bool explode;

  const PathParameterSpec(this.name, this.style, this.explode);
}

String serializePathParameter(dynamic value, PathParameterSpec spec) {
  if (value == null) return '';
  final style = spec.style.trim().isEmpty ? 'simple' : spec.style;
  if (value is Iterable) {
    return serializePathArray(spec.name, value, style, spec.explode);
  }
  if (value is Map) {
    return serializePathObject(spec.name, value, style, spec.explode);
  }
  return pathPrimitivePrefix(spec.name, style) + Uri.encodeComponent(value.toString());
}

String serializePathArray(String name, Iterable values, String style, bool explode) {
  final serialized = values.where((item) => item != null).map((item) => Uri.encodeComponent(item.toString())).toList();
  if (serialized.isEmpty) return pathPrefix(name, style);
  if (style == 'matrix') {
    if (explode) {
      return serialized.map((item) => ';$name=$item').join();
    }
    return ';$name=${serialized.join(',')}';
  }
  final separator = explode ? '.' : ',';
  return pathPrefix(name, style) + serialized.join(separator);
}

String serializePathObject(String name, Map values, String style, bool explode) {
  final entries = <String>[];
  final exploded = <String>[];
  values.forEach((key, value) {
    if (value == null) return;
    final escapedKey = Uri.encodeComponent(key.toString());
    final escapedValue = Uri.encodeComponent(value.toString());
    if (explode) {
      if (style == 'matrix') {
        exploded.add(';$escapedKey=$escapedValue');
      } else {
        exploded.add('$escapedKey=$escapedValue');
      }
    } else {
      entries.add(escapedKey);
      entries.add(escapedValue);
    }
  });
  if (style == 'matrix') {
    if (explode) return exploded.join();
    return ';$name=${entries.join(',')}';
  }
  if (explode) {
    final separator = style == 'label' ? '.' : ',';
    return pathPrefix(name, style) + exploded.join(separator);
  }
  return pathPrefix(name, style) + entries.join(',');
}

String pathPrefix(String name, String style) {
  if (style == 'label') return '.';
  if (style == 'matrix') return ';$name';
  return '';
}

String pathPrimitivePrefix(String name, String style) {
  return style == 'matrix' ? ';$name=' : pathPrefix(name, style);
}
