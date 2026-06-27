import 'package:sdkwork_mcp_app_sdk_generated_flutter/app_client.dart';

export 'package:sdkwork_mcp_app_sdk_generated_flutter/app_client.dart';

const appApiPrefix = '/app/v3/api';

McpAppClientBundle createMcpAppClient({
  required String apiBaseUrl,
  String? accessToken,
  String? authToken,
  String? tenantId,
  String? organizationId,
  String? userId,
  SdkworkAppClient? existingClient,
}) {
  final SdkworkAppClient client;
  if (existingClient != null) {
    client = existingClient;
    if (authToken != null && authToken.isNotEmpty) {
      client.setAuthToken(authToken);
    }
    if (accessToken != null && accessToken.isNotEmpty) {
      client.setAccessToken(accessToken);
    }
    if (tenantId != null && tenantId.isNotEmpty) {
      client.setHeader('x-sdkwork-tenant-id', tenantId);
    }
    if (organizationId != null && organizationId.isNotEmpty) {
      client.setHeader('x-sdkwork-organization-id', organizationId);
    }
    if (userId != null && userId.isNotEmpty) {
      client.setHeader('x-sdkwork-user-id', userId);
      client.setHeader('x-sdkwork-actor-id', userId);
    }
  } else {
    client = SdkworkAppClient.withBaseUrl(
      baseUrl: resolveAppApiBaseUrl(apiBaseUrl),
      authToken: authToken,
      accessToken: accessToken,
      headers: {
        if (tenantId != null && tenantId.isNotEmpty) 'x-sdkwork-tenant-id': tenantId,
        if (organizationId != null && organizationId.isNotEmpty)
          'x-sdkwork-organization-id': organizationId,
        if (userId != null && userId.isNotEmpty) ...{
          'x-sdkwork-user-id': userId,
          'x-sdkwork-actor-id': userId,
        },
      },
    );
  }

  return McpAppClientBundle(appClient: client);
}

String resolveAppApiBaseUrl(String configuredApiBaseUrl) {
  final trimmed = configuredApiBaseUrl.trim();
  if (trimmed.endsWith(appApiPrefix)) {
    return trimmed.substring(0, trimmed.length - appApiPrefix.length);
  }
  return trimmed;
}

class McpAppClientBundle {
  const McpAppClientBundle({required this.appClient});

  final SdkworkAppClient appClient;
}
