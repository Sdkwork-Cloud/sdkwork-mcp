import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'app.dart';
import 'bootstrap/app_auth.dart';
import 'bootstrap/environment.dart';
import 'bootstrap/iam_runtime.dart';
import 'bootstrap/sdk_clients.dart';

class McpAppAuthGate extends StatefulWidget {
  const McpAppAuthGate({super.key});

  @override
  State<McpAppAuthGate> createState() => _McpAppAuthGateState();
}

class _McpAppAuthGateState extends State<McpAppAuthGate> {
  McpAppSession? _session = loadAppSession();
  late McpAppSession _form = _session ?? defaultAppSession;
  final _environment = resolveEnvironment();
  final _appLinks = AppLinks();
  StreamSubscription<Uri>? _appLinkSubscription;

  final _accessTokenController = TextEditingController();
  final _authTokenController = TextEditingController();
  final _tenantIdController = TextEditingController();
  final _organizationIdController = TextEditingController();
  final _userIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _syncControllers();
    _appLinkSubscription = _appLinks.uriLinkStream.listen((uri) async {
      final callbackSession = await consumeAppbaseCallbackSession(uri);
      if (callbackSession == null || !mounted) {
        return;
      }
      createSdkClients(session: callbackSession);
      createIamRuntime(session: callbackSession);
      setState(() {
        _session = callbackSession;
        _form = callbackSession;
      });
    });
  }

  @override
  void dispose() {
    _appLinkSubscription?.cancel();
    _accessTokenController.dispose();
    _authTokenController.dispose();
    _tenantIdController.dispose();
    _organizationIdController.dispose();
    _userIdController.dispose();
    super.dispose();
  }

  void _syncControllers() {
    _accessTokenController.text = _form.accessToken;
    _authTokenController.text = _form.authToken;
    _tenantIdController.text = _form.tenantId;
    _organizationIdController.text = _form.organizationId;
    _userIdController.text = _form.userId;
  }

  Future<void> _activateSession(McpAppSession nextSession) async {
    if (nextSession.accessToken.isEmpty) {
      return;
    }
    await saveAppSession(nextSession);
    createSdkClients(session: nextSession);
    createIamRuntime(session: nextSession);
    setState(() {
      _session = nextSession;
      _form = nextSession;
    });
  }

  Future<void> _handleSubmit() async {
    await _activateSession(
      McpAppSession(
        accessToken: _accessTokenController.text.trim(),
        authToken: _authTokenController.text.trim().isEmpty
            ? _accessTokenController.text.trim()
            : _authTokenController.text.trim(),
        tenantId: _tenantIdController.text.trim().isEmpty
            ? defaultAppSession.tenantId
            : _tenantIdController.text.trim(),
        organizationId: _organizationIdController.text.trim().isEmpty
            ? defaultAppSession.organizationId
            : _organizationIdController.text.trim(),
        userId: _userIdController.text.trim().isEmpty
            ? defaultAppSession.userId
            : _userIdController.text.trim(),
      ),
    );
  }

  Future<void> _handleAppbaseLogin() async {
    final loginUri = buildAppbaseLoginUrl(
      loginUrl: _environment.appbaseLoginUrl,
      returnUrl: appbaseCallbackReturnUrl,
    );
    final launched = await launchUrl(loginUri, mode: LaunchMode.externalApplication);
    if (!launched && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to open Appbase login URL')),
      );
    }
  }

  Future<void> _handleSignOut() async {
    await clearAppSession();
    resetSdkClients();
    setState(() {
      _session = null;
      _form = defaultAppSession;
      _syncControllers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final session = _session;
    if (session != null) {
      return Column(
        children: [
          Material(
            color: const Color(0xFF134E4A),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Signed in as ${session.userId} (tenant ${session.tenantId})',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    TextButton(
                      onPressed: _handleSignOut,
                      child: const Text('Sign out', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Expanded(child: SdkworkMcpApp()),
        ],
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF141414),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Card(
                color: const Color(0xFF1F1F1F),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'MCP Mobile Sign In',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Sign in through Appbase IAM or provide local app-api credentials for development.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                      ),
                      const SizedBox(height: 16),
                      FilledButton(
                        onPressed: _handleAppbaseLogin,
                        child: const Text('Continue with Appbase'),
                      ),
                      const SizedBox(height: 16),
                      const Center(
                        child: Text(
                          'or use development credentials',
                          style: TextStyle(color: Colors.white54),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _accessTokenController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(labelText: 'Access Token'),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _authTokenController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(labelText: 'Auth Token'),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _tenantIdController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(labelText: 'Tenant ID'),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _organizationIdController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(labelText: 'Organization ID'),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _userIdController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(labelText: 'User ID'),
                      ),
                      const SizedBox(height: 20),
                      FilledButton(
                        onPressed: _handleSubmit,
                        child: const Text('Continue with Dev Credentials'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
