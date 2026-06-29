import 'package:sdkwork_mcp_flutter_mobile_core/sdkwork_mcp_flutter_mobile_core.dart';

import 'sdk_clients.dart';

SdkworkMcpFlutterSdkClients? _iamRuntime;

SdkworkMcpFlutterSdkClients createIamRuntime({McpAppSession? session}) {
  _iamRuntime = createSdkClients(session: session);
  return _iamRuntime!;
}

SdkworkMcpFlutterSdkClients? getIamRuntime() => _iamRuntime;
