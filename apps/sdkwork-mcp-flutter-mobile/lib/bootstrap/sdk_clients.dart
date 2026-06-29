import 'package:sdkwork_mcp_app_sdk_generated_flutter/app_client.dart';
import 'package:sdkwork_mcp_flutter_mobile_core/sdkwork_mcp_flutter_mobile_core.dart';

import 'app_auth.dart';
import 'environment.dart';

SdkworkMcpFlutterSdkClients? _clients;

typedef SdkClients = SdkworkMcpFlutterSdkClients;

SdkworkMcpFlutterSdkClients createSdkClients({McpAppSession? session}) {
  final environment = resolveEnvironment();
  _clients = createSdkworkMcpFlutterSdkClients(
    apiBaseUrl: environment.apiBaseUrl,
    backendApiBaseUrl: environment.backendApiBaseUrl,
    driveAppApiBaseUrl: environment.driveAppApiBaseUrl,
    session: session ?? loadAppSession(),
  );
  return _clients!;
}

SdkworkAppClient? getMcpAppClient() => _clients?.appClient;

void resetSdkClients() {
  _clients = null;
}
