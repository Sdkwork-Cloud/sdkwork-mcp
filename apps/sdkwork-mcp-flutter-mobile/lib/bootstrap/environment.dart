class McpEnvironment {
  const McpEnvironment({
    required this.apiBaseUrl,
    required this.backendApiBaseUrl,
    required this.driveAppApiBaseUrl,
    required this.appbaseLoginUrl,
  });

  final String apiBaseUrl;
  final String backendApiBaseUrl;
  final String driveAppApiBaseUrl;
  final String appbaseLoginUrl;
}

String _normalizeBaseUrl(String value, String fallback) {
  final normalized = value.trim();
  return normalized.isEmpty ? fallback : normalized;
}

String _deriveAppApiBaseUrl(String applicationPublicHttpUrl) {
  final normalized = applicationPublicHttpUrl.replaceAll(RegExp(r'/+$'), '');
  return '$normalized/app/v3/api';
}

String _deriveBackendApiBaseUrl(String applicationPublicHttpUrl) {
  final normalized = applicationPublicHttpUrl.replaceAll(RegExp(r'/+$'), '');
  return '$normalized/backend/v3/api';
}

McpEnvironment resolveEnvironment() {
  const applicationPublicHttpUrl = String.fromEnvironment(
    'SDKWORK_MCP_FLUTTER_APPLICATION_PUBLIC_HTTP_URL',
    defaultValue: 'http://127.0.0.1:8095',
  );

  return McpEnvironment(
    apiBaseUrl: _normalizeBaseUrl(
      const String.fromEnvironment('SDKWORK_MCP_FLUTTER_APP_API_BASE_URL'),
      _deriveAppApiBaseUrl(applicationPublicHttpUrl),
    ),
    backendApiBaseUrl: _normalizeBaseUrl(
      const String.fromEnvironment('SDKWORK_MCP_FLUTTER_BACKEND_API_BASE_URL'),
      _deriveBackendApiBaseUrl(applicationPublicHttpUrl),
    ),
    driveAppApiBaseUrl: _normalizeBaseUrl(
      const String.fromEnvironment('SDKWORK_MCP_FLUTTER_DRIVE_APP_API_BASE_URL'),
      _deriveAppApiBaseUrl(applicationPublicHttpUrl),
    ),
    appbaseLoginUrl: _normalizeBaseUrl(
      const String.fromEnvironment('SDKWORK_MCP_FLUTTER_APPBASE_LOGIN_URL'),
      'http://127.0.0.1:3900',
    ),
  );
}
