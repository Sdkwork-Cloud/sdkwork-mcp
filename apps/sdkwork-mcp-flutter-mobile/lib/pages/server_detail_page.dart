import 'package:flutter/material.dart';
import 'package:sdkwork_mcp_app_sdk_generated_flutter/src/models.dart';
import 'package:sdkwork_mcp_flutter_mobile_core/sdkwork_mcp_flutter_mobile_core.dart';

import '../bootstrap/sdk_clients.dart';

enum _DetailTab { tools, resources, prompts }

class ServerDetailPage extends StatefulWidget {
  const ServerDetailPage({super.key, required this.serverKey});

  final String serverKey;

  @override
  State<ServerDetailPage> createState() => _ServerDetailPageState();
}

class _ServerDetailPageState extends State<ServerDetailPage> {
  late Future<ServerDetailBundle> _detailFuture;
  _DetailTab _tab = _DetailTab.tools;

  @override
  void initState() {
    super.initState();
    _detailFuture = _loadDetail();
  }

  Future<ServerDetailBundle> _loadDetail() {
    final client = getMcpAppClient();
    if (client == null) {
      return Future.error(StateError('MCP app client is not initialized'));
    }
    return fetchServerDetail(client, widget.serverKey);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.serverKey.isEmpty) {
      return const Center(
        child: Text('Missing server key.', style: TextStyle(color: Color(0xFFF87171))),
      );
    }

    return FutureBuilder<ServerDetailBundle>(
      future: _detailFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Text('Loading MCP server…', style: TextStyle(color: Colors.white70)),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text(
              snapshot.error.toString(),
              style: const TextStyle(color: Color(0xFFF87171)),
            ),
          );
        }
        final data = snapshot.data;
        if (data == null) {
          return const SizedBox.shrink();
        }

        final tone = healthTone(data.server.healthStatus);
        final tabItems = switch (_tab) {
          _DetailTab.tools => data.tools,
          _DetailTab.resources => data.resources,
          _DetailTab.prompts => data.prompts,
        };

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextButton(
              onPressed: () => Navigator.of(context).maybePop(),
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Text('← Back to marketplace'),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.server.name,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        data.server.description ?? 'MCP server capability catalog.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.white70,
                              height: 1.4,
                            ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: healthToneBackground(tone),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    formatMcpHealth(data.server.healthStatus),
                    style: TextStyle(
                      color: healthToneColor(tone),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _InfoTile(label: 'Server key', value: data.server.serverKey, monospace: true),
            _InfoTile(label: 'Transport', value: formatMcpTransport(data.server.transport)),
            _InfoTile(label: 'Visibility', value: formatMcpVisibility(data.server.visibility)),
            const SizedBox(height: 16),
            Row(
              children: [
                _TabButton(
                  label: 'Tools (${data.tools.length})',
                  selected: _tab == _DetailTab.tools,
                  onTap: () => setState(() => _tab = _DetailTab.tools),
                ),
                _TabButton(
                  label: 'Resources (${data.resources.length})',
                  selected: _tab == _DetailTab.resources,
                  onTap: () => setState(() => _tab = _DetailTab.resources),
                ),
                _TabButton(
                  label: 'Prompts (${data.prompts.length})',
                  selected: _tab == _DetailTab.prompts,
                  onTap: () => setState(() => _tab = _DetailTab.prompts),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (tabItems.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'No ${_tab.name} published for this server.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white54),
                ),
              )
            else
              ...tabItems.map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _CapabilityCard(item: item),
                  )),
          ],
        );
      },
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.label,
    required this.value,
    this.monospace = false,
  });

  final String label;
  final String value;
  final bool monospace;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F1F),
        border: Border.all(color: Colors.white12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(color: Colors.white38, fontSize: 11, letterSpacing: 0.8),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontFamily: monospace ? 'monospace' : null,
            ),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          foregroundColor: selected ? Colors.white : Colors.white54,
          backgroundColor: selected ? Colors.white10 : Colors.transparent,
        ),
        child: Text(label, style: const TextStyle(fontSize: 12)),
      ),
    );
  }
}

class _CapabilityCard extends StatelessWidget {
  const _CapabilityCard({required this.item});

  final Object item;

  @override
  Widget build(BuildContext context) {
    final title = switch (item) {
      McpToolRecord tool => tool.name,
      McpResourceRecord resource => resource.name,
      McpPromptRecord prompt => prompt.name,
      _ => 'Capability',
    };
    final subtitle = switch (item) {
      McpToolRecord tool => tool.toolKey,
      McpResourceRecord resource => resource.resourceKey,
      McpPromptRecord prompt => prompt.promptKey,
      _ => '',
    };
    final description = switch (item) {
      McpToolRecord tool => tool.description,
      McpResourceRecord resource => resource.uri,
      McpPromptRecord() => null,
      _ => null,
    };

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F1F),
        border: Border.all(color: Colors.white12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(color: Colors.white54, fontFamily: 'monospace', fontSize: 12),
          ),
          if (description != null && description.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              description,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white60,
                    height: 1.4,
                  ),
            ),
          ],
        ],
      ),
    );
  }
}
