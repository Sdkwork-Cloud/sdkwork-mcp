import 'package:flutter/material.dart';

const _transportLabels = <String, String>{
  'stdio': 'Stdio',
  'sse': 'SSE',
  'http': 'HTTP',
  'streamable_http': 'Streamable HTTP',
};

const _healthLabels = <String, String>{
  'unknown': 'Unknown',
  'healthy': 'Healthy',
  'degraded': 'Degraded',
  'unhealthy': 'Unhealthy',
};

const _visibilityLabels = <String, String>{
  'private': 'Private',
  'tenant': 'Tenant',
  'organization': 'Organization',
  'public': 'Public',
};

String formatMcpTransport(String value) => _transportLabels[value] ?? value;

String formatMcpHealth(String value) => _healthLabels[value] ?? value;

String formatMcpVisibility(String value) => _visibilityLabels[value] ?? value;

enum McpHealthTone { neutral, success, warning, danger }

McpHealthTone healthTone(String value) {
  switch (value) {
    case 'healthy':
      return McpHealthTone.success;
    case 'degraded':
      return McpHealthTone.warning;
    case 'unhealthy':
      return McpHealthTone.danger;
    default:
      return McpHealthTone.neutral;
  }
}

Color healthToneColor(McpHealthTone tone) {
  switch (tone) {
    case McpHealthTone.success:
      return const Color(0xFF16A34A);
    case McpHealthTone.warning:
      return const Color(0xFFD97706);
    case McpHealthTone.danger:
      return const Color(0xFFDC2626);
    case McpHealthTone.neutral:
      return const Color(0xFF6B7280);
  }
}

Color healthToneBackground(McpHealthTone tone) {
  switch (tone) {
    case McpHealthTone.success:
      return const Color(0x3316A34A);
    case McpHealthTone.warning:
      return const Color(0x33D97706);
    case McpHealthTone.danger:
      return const Color(0x33DC2626);
    case McpHealthTone.neutral:
      return const Color(0x336B7280);
  }
}
