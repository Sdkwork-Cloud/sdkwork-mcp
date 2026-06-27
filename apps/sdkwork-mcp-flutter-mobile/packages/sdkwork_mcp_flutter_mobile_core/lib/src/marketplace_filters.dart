import 'package:sdkwork_mcp_app_sdk_generated_flutter/src/models.dart';

class MarketplaceFilterState {
  const MarketplaceFilterState({
    this.query = '',
    this.categoryCode,
    this.transport,
  });

  final String query;
  final String? categoryCode;
  final String? transport;
}

String _trim(String value) => value.trim();

bool _isBlank(String? value) => value == null || _trim(value).isEmpty;

List<McpServerRecord> filterMarketplaceServers(
  List<McpServerRecord> servers,
  MarketplaceFilterState filters,
) {
  final query = _trim(filters.query).toLowerCase();
  return servers.where((server) {
    if (filters.categoryCode != null && server.categoryCode != filters.categoryCode) {
      return false;
    }
    if (filters.transport != null && server.transport != filters.transport) {
      return false;
    }
    if (_isBlank(query)) {
      return true;
    }
    final haystack = [
      server.name,
      server.serverKey,
      server.description ?? '',
      server.categoryCode ?? '',
      ...(server.tags ?? const <String>[]),
    ].join(' ').toLowerCase();
    return haystack.contains(query);
  }).toList(growable: false);
}

List<String> uniqueTransports(List<McpServerRecord> servers) {
  return servers.map((server) => server.transport).toSet().toList()..sort();
}
