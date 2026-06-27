import 'package:flutter/material.dart';
import 'package:sdkwork_mcp_app_sdk_generated_flutter/src/models.dart';
import 'package:sdkwork_mcp_flutter_mobile_core/sdkwork_mcp_flutter_mobile_core.dart';

import '../bootstrap/sdk_clients.dart';
import '../bootstrap/routes.dart';

class MarketplacePage extends StatefulWidget {
  const MarketplacePage({super.key});

  @override
  State<MarketplacePage> createState() => _MarketplacePageState();
}

class _MarketplacePageState extends State<MarketplacePage> {
  late Future<MarketplaceCatalog> _catalogFuture;
  String _query = '';
  String? _categoryCode;
  String? _transport;

  @override
  void initState() {
    super.initState();
    _catalogFuture = _loadCatalog();
  }

  Future<MarketplaceCatalog> _loadCatalog() {
    final client = getMcpAppClient();
    if (client == null) {
      return Future.error(StateError('MCP app client is not initialized'));
    }
    return fetchMarketplaceCatalog(client);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<MarketplaceCatalog>(
      future: _catalogFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Text('Loading MCP marketplace…', style: TextStyle(color: Colors.white70)),
            ),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                snapshot.error.toString(),
                style: const TextStyle(color: Color(0xFFF87171)),
              ),
            ),
          );
        }
        final data = snapshot.data;
        if (data == null) {
          return const SizedBox.shrink();
        }
        final filteredServers = filterMarketplaceServers(
          data.servers,
          MarketplaceFilterState(
            query: _query,
            categoryCode: _categoryCode,
            transport: _transport,
          ),
        );
        final transports = uniqueTransports(data.servers);

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'MCP Marketplace',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Browse governed MCP servers for your tenant.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70),
            ),
            const SizedBox(height: 16),
            TextField(
              onChanged: (value) => setState(() => _query = value),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search servers, tags, keys…',
                hintStyle: const TextStyle(color: Colors.white38),
                filled: true,
                fillColor: const Color(0xFF1F1F1F),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.white12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.white12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _FilterChip(
                  label: 'All categories',
                  selected: _categoryCode == null,
                  onSelected: () => setState(() => _categoryCode = null),
                ),
                for (final category in data.categories)
                  _FilterChip(
                    label: category.name,
                    selected: _categoryCode == category.categoryCode,
                    onSelected: () => setState(() => _categoryCode = category.categoryCode),
                  ),
              ],
            ),
            if (transports.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _FilterChip(
                    label: 'All transports',
                    selected: _transport == null,
                    onSelected: () => setState(() => _transport = null),
                  ),
                  for (final value in transports)
                    _FilterChip(
                      label: formatMcpTransport(value),
                      selected: _transport == value,
                      onSelected: () => setState(() => _transport = value),
                    ),
                ],
              ),
            ],
            const SizedBox(height: 16),
            if (filteredServers.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'No MCP servers match the current filters.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white54),
                ),
              )
            else
              ...filteredServers.map(
                (server) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _ServerCard(
                    server: server,
                    onTap: () => Navigator.of(context).pushNamed(
                      McpRoutes.serverDetailFor(server.serverKey),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(),
      selectedColor: const Color(0xFF2563EB),
      labelStyle: TextStyle(
        color: selected ? Colors.white : Colors.white70,
        fontSize: 12,
      ),
      backgroundColor: Colors.white10,
      side: BorderSide.none,
      showCheckmark: false,
    );
  }
}

class _ServerCard extends StatelessWidget {
  const _ServerCard({required this.server, required this.onTap});

  final McpServerRecord server;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tone = healthTone(server.healthStatus);
    return Material(
      color: const Color(0xFF1F1F1F),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white12),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      server.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: healthToneBackground(tone),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      formatMcpHealth(server.healthStatus),
                      style: TextStyle(
                        color: healthToneColor(tone),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              if (server.description?.isNotEmpty ?? false) ...[
                const SizedBox(height: 8),
                Text(
                  server.description!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white60,
                        height: 1.4,
                      ),
                ),
              ],
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _MetaChip(label: formatMcpTransport(server.transport)),
                  _MetaChip(label: formatMcpVisibility(server.visibility)),
                  _MetaChip(label: server.serverKey, monospace: true),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.label, this.monospace = false});

  final String label;
  final bool monospace;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white70,
          fontSize: 11,
          fontFamily: monospace ? 'monospace' : null,
        ),
      ),
    );
  }
}
