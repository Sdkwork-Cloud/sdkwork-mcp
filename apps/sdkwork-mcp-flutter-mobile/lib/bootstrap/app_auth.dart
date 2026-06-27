import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sdkwork_mcp_flutter_mobile_core/sdkwork_mcp_flutter_mobile_core.dart';

export 'package:sdkwork_mcp_flutter_mobile_core/sdkwork_mcp_flutter_mobile_core.dart'
    show
        McpAppSession,
        appbaseCallbackReturnUrl,
        buildAppbaseLoginUrl,
        defaultAppSession,
        legacyMcpFlutterMobileSessionStorageKeys,
        mcpFlutterMobileSessionStorageKey,
        parseAppbaseCallbackSession,
        resolveMcpAppSession;

SharedPreferences? _preferences;
McpAppSession? _activeAppSession;

Future<void> initAppAuthStorage() async {
  _preferences ??= await SharedPreferences.getInstance();
  final raw = _preferences!.getString(mcpFlutterMobileSessionStorageKey);
  if (raw != null && raw.isNotEmpty) {
    _activeAppSession = _parseStoredSession(raw);
    return;
  }

  for (final legacyKey in legacyMcpFlutterMobileSessionStorageKeys) {
    final legacyRaw = _preferences!.getString(legacyKey);
    if (legacyRaw == null || legacyRaw.isEmpty) {
      continue;
    }
    final migrated = _parseStoredSession(legacyRaw);
    await _preferences!.remove(legacyKey);
    if (migrated != null) {
      _activeAppSession = migrated;
      await _preferences!.setString(
        mcpFlutterMobileSessionStorageKey,
        jsonEncode(migrated.toJson()),
      );
      return;
    }
  }
}

McpAppSession? _parseStoredSession(String raw) {
  try {
    final decoded = jsonDecode(raw);
    if (decoded is Map<String, dynamic>) {
      final session = McpAppSession.fromJson(decoded);
      if (session.accessToken.isNotEmpty) {
        return session;
      }
    }
  } catch (_) {
    return null;
  }
  return null;
}

McpAppSession? loadAppSession() => resolveMcpAppSession(_activeAppSession);

Future<void> saveAppSession(McpAppSession session) async {
  _activeAppSession = session;
  final prefs = _preferences ?? await SharedPreferences.getInstance();
  await prefs.setString(mcpFlutterMobileSessionStorageKey, jsonEncode(session.toJson()));
  for (final legacyKey in legacyMcpFlutterMobileSessionStorageKeys) {
    await prefs.remove(legacyKey);
  }
}

Future<void> clearAppSession() async {
  _activeAppSession = null;
  final prefs = _preferences ?? await SharedPreferences.getInstance();
  await prefs.remove(mcpFlutterMobileSessionStorageKey);
  for (final legacyKey in legacyMcpFlutterMobileSessionStorageKeys) {
    await prefs.remove(legacyKey);
  }
}

Future<McpAppSession?> consumeAppbaseCallbackSession(Uri? uri) async {
  final session = parseAppbaseCallbackSession(uri);
  if (session == null) {
    return null;
  }
  await saveAppSession(session);
  return session;
}

McpAppSession? bootstrapAppAuth() => loadAppSession();
