import 'package:flutter/material.dart';

import 'bootstrap/routes.dart';
import 'pages/marketplace_page.dart';
import 'pages/server_detail_page.dart';

class SdkworkMcpApp extends StatelessWidget {
  const SdkworkMcpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SDKWork MCP',
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF0F766E),
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF141414),
      ),
      initialRoute: McpRoutes.marketplace,
      onGenerateRoute: (settings) {
        if (settings.name == McpRoutes.marketplace) {
          return MaterialPageRoute<void>(
            builder: (_) => const _MarketplaceShell(),
          );
        }
        final serverKey = McpRoutes.parseServerDetailKey(settings.name);
        if (serverKey != null) {
          return MaterialPageRoute<void>(
            builder: (_) => ServerDetailPage(serverKey: serverKey),
          );
        }
        return MaterialPageRoute<void>(
          builder: (_) => const _MarketplaceShell(),
        );
      },
    );
  }
}

class _MarketplaceShell extends StatelessWidget {
  const _MarketplaceShell();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SDKWork MCP'),
        backgroundColor: const Color(0xFF134E4A),
      ),
      body: const MarketplacePage(),
    );
  }
}
