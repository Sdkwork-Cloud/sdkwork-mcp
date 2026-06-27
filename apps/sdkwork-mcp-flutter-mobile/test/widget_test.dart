import 'package:flutter_test/flutter_test.dart';
import 'package:sdkwork_mcp_flutter_mobile/app.dart';

void main() {
  testWidgets('SdkworkMcpApp renders MCP marketplace shell', (tester) async {
    await tester.pumpWidget(const SdkworkMcpApp());
    expect(find.text('SDKWork MCP'), findsOneWidget);
    expect(find.text('MCP Marketplace'), findsOneWidget);
  });
}
