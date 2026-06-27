class McpAppSession {
  const McpAppSession({
    required this.accessToken,
    required this.authToken,
    required this.tenantId,
    required this.organizationId,
    required this.userId,
  });

  final String accessToken;
  final String authToken;
  final String tenantId;
  final String organizationId;
  final String userId;

  Map<String, dynamic> toJson() => {
        'accessToken': accessToken,
        'authToken': authToken,
        'tenantId': tenantId,
        'organizationId': organizationId,
        'userId': userId,
      };

  factory McpAppSession.fromJson(Map<String, dynamic> json) {
    final accessToken = json['accessToken']?.toString().trim() ?? '';
    final authToken = json['authToken']?.toString().trim() ?? accessToken;
    return McpAppSession(
      accessToken: accessToken,
      authToken: authToken,
      tenantId: json['tenantId']?.toString().trim().isNotEmpty == true
          ? json['tenantId'].toString().trim()
          : defaultAppSession.tenantId,
      organizationId: json['organizationId']?.toString().trim().isNotEmpty == true
          ? json['organizationId'].toString().trim()
          : defaultAppSession.organizationId,
      userId: json['userId']?.toString().trim().isNotEmpty == true
          ? json['userId'].toString().trim()
          : defaultAppSession.userId,
    );
  }
}

const defaultAppSession = McpAppSession(
  accessToken: '',
  authToken: '',
  tenantId: '100001',
  organizationId: '0',
  userId: 'user',
);

const mcpFlutterMobileSessionStorageKey = 'sdkwork-mcp-flutter-mobile:session:v1';
const legacyMcpFlutterMobileSessionStorageKeys = <String>[
  'sdkwork-agents-flutter-mobile:session:v1',
  'sdkwork.agents.app.session',
];
