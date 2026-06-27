import 'mcp_app_session.dart';

const _callbackKeys = <String, List<String>>{
  'accessToken': ['accessToken', 'access_token'],
  'authToken': ['authToken', 'auth_token', 'token'],
  'tenantId': ['tenantId', 'tenant_id', 'x-sdkwork-tenant-id'],
  'organizationId': ['organizationId', 'organization_id', 'x-sdkwork-organization-id'],
  'userId': ['userId', 'user_id', 'x-sdkwork-user-id', 'actorId', 'actor_id'],
};

String _readParam(Map<String, String> params, List<String> keys) {
  for (final key in keys) {
    final value = params[key]?.trim();
    if (value != null && value.isNotEmpty) {
      return value;
    }
  }
  return '';
}

Uri buildAppbaseLoginUrl({
  required String loginUrl,
  required String returnUrl,
}) {
  final target = Uri.parse(loginUrl);
  return target.replace(
    queryParameters: {
      ...target.queryParameters,
      'returnUrl': returnUrl,
    },
  );
}

McpAppSession? parseAppbaseCallbackSession(Uri? uri) {
  if (uri == null) {
    return null;
  }

  final params = uri.queryParameters;
  final accessToken = _readParam(params, _callbackKeys['accessToken']!);
  if (accessToken.isEmpty) {
    return null;
  }

  final authToken = _readParam(params, _callbackKeys['authToken']!);
  return McpAppSession(
    accessToken: accessToken,
    authToken: authToken.isEmpty ? accessToken : authToken,
    tenantId: _readParam(params, _callbackKeys['tenantId']!).isEmpty
        ? defaultAppSession.tenantId
        : _readParam(params, _callbackKeys['tenantId']!),
    organizationId: _readParam(params, _callbackKeys['organizationId']!).isEmpty
        ? defaultAppSession.organizationId
        : _readParam(params, _callbackKeys['organizationId']!),
    userId: _readParam(params, _callbackKeys['userId']!).isEmpty
        ? defaultAppSession.userId
        : _readParam(params, _callbackKeys['userId']!),
  );
}

String get appbaseCallbackReturnUrl => 'sdkworkmcp://auth/callback';

McpAppSession? resolveMcpAppSession(McpAppSession? storedSession) {
  if (storedSession != null && storedSession.accessToken.isNotEmpty) {
    return storedSession;
  }

  for (final key in const ['SDKWORK_MCP_ACCESS_TOKEN', 'SDKWORK_ACCESS_TOKEN']) {
    final token = String.fromEnvironment(key);
    if (token.trim().isNotEmpty) {
      final normalized = token.trim();
      return McpAppSession(
        accessToken: normalized,
        authToken: normalized,
        tenantId: defaultAppSession.tenantId,
        organizationId: defaultAppSession.organizationId,
        userId: defaultAppSession.userId,
      );
    }
  }

  return null;
}
