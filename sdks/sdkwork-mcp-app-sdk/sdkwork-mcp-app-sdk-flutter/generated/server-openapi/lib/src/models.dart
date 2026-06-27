Map<String, dynamic>? _sdkworkAsMap(dynamic value) {
  if (value is Map<String, dynamic>) {
    return value;
  }
  if (value is Map) {
    return value.map((key, item) => MapEntry(key.toString(), item));
  }
  return null;
}

List<dynamic>? _sdkworkAsList(dynamic value) {
  return value is List ? value : null;
}

class ProblemDetail {
  final String type;
  final String title;
  final int status;
  final String? detail;
  final String? requestId;

  ProblemDetail({
    required this.type,
    required this.title,
    required this.status,
    this.detail,
    this.requestId
  });

  factory ProblemDetail.fromJson(Map<String, dynamic> json) {
    return ProblemDetail(
      type: (() {
        final value = json['type']?.toString();
        if (value == null) {
          throw FormatException('ProblemDetail.type is required');
        }
        return value;
      })(),
      title: (() {
        final value = json['title']?.toString();
        if (value == null) {
          throw FormatException('ProblemDetail.title is required');
        }
        return value;
      })(),
      status: (() {
        final value = json['status'];
        if (value is! int) {
          throw FormatException('ProblemDetail.status is required');
        }
        return value;
      })(),
      detail: json['detail']?.toString(),
      requestId: json['requestId']?.toString()
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'type': type,
      'title': title,
      'status': status,
      'detail': detail,
      'requestId': requestId,
    };
  }
}

class McpServerCategoryRecord {
  final int id;
  final String uuid;
  final String categoryCode;
  final String name;
  final String? description;
  final int? parentId;
  final int? sortOrder;
  final String? iconRef;
  final String lifecycleStatus;

  McpServerCategoryRecord({
    required this.id,
    required this.uuid,
    required this.categoryCode,
    required this.name,
    this.description,
    this.parentId,
    this.sortOrder,
    this.iconRef,
    required this.lifecycleStatus
  });

  factory McpServerCategoryRecord.fromJson(Map<String, dynamic> json) {
    return McpServerCategoryRecord(
      id: (() {
        final value = json['id'];
        if (value is! int) {
          throw FormatException('McpServerCategoryRecord.id is required');
        }
        return value;
      })(),
      uuid: (() {
        final value = json['uuid']?.toString();
        if (value == null) {
          throw FormatException('McpServerCategoryRecord.uuid is required');
        }
        return value;
      })(),
      categoryCode: (() {
        final value = json['category_code']?.toString();
        if (value == null) {
          throw FormatException('McpServerCategoryRecord.category_code is required');
        }
        return value;
      })(),
      name: (() {
        final value = json['name']?.toString();
        if (value == null) {
          throw FormatException('McpServerCategoryRecord.name is required');
        }
        return value;
      })(),
      description: json['description']?.toString(),
      parentId: json['parent_id'] is int ? json['parent_id'] : null,
      sortOrder: json['sort_order'] is int ? json['sort_order'] : null,
      iconRef: json['icon_ref']?.toString(),
      lifecycleStatus: (() {
        final value = json['lifecycle_status']?.toString();
        if (value == null) {
          throw FormatException('McpServerCategoryRecord.lifecycle_status is required');
        }
        return value;
      })()
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'uuid': uuid,
      'category_code': categoryCode,
      'name': name,
      'description': description,
      'parent_id': parentId,
      'sort_order': sortOrder,
      'icon_ref': iconRef,
      'lifecycle_status': lifecycleStatus,
    };
  }
}

class McpServerRecord {
  final int id;
  final String uuid;
  final String serverKey;
  final String name;
  final String? description;
  final int? categoryId;
  final String? categoryCode;
  final String transport;
  final String visibility;
  final String dataScope;
  final String healthStatus;
  final String lifecycleStatus;
  final List<String>? tags;
  final String? iconRef;

  McpServerRecord({
    required this.id,
    required this.uuid,
    required this.serverKey,
    required this.name,
    this.description,
    this.categoryId,
    this.categoryCode,
    required this.transport,
    required this.visibility,
    required this.dataScope,
    required this.healthStatus,
    required this.lifecycleStatus,
    this.tags,
    this.iconRef
  });

  factory McpServerRecord.fromJson(Map<String, dynamic> json) {
    return McpServerRecord(
      id: (() {
        final value = json['id'];
        if (value is! int) {
          throw FormatException('McpServerRecord.id is required');
        }
        return value;
      })(),
      uuid: (() {
        final value = json['uuid']?.toString();
        if (value == null) {
          throw FormatException('McpServerRecord.uuid is required');
        }
        return value;
      })(),
      serverKey: (() {
        final value = json['server_key']?.toString();
        if (value == null) {
          throw FormatException('McpServerRecord.server_key is required');
        }
        return value;
      })(),
      name: (() {
        final value = json['name']?.toString();
        if (value == null) {
          throw FormatException('McpServerRecord.name is required');
        }
        return value;
      })(),
      description: json['description']?.toString(),
      categoryId: json['category_id'] is int ? json['category_id'] : null,
      categoryCode: json['category_code']?.toString(),
      transport: (() {
        final value = json['transport']?.toString();
        if (value == null) {
          throw FormatException('McpServerRecord.transport is required');
        }
        return value;
      })(),
      visibility: (() {
        final value = json['visibility']?.toString();
        if (value == null) {
          throw FormatException('McpServerRecord.visibility is required');
        }
        return value;
      })(),
      dataScope: (() {
        final value = json['data_scope']?.toString();
        if (value == null) {
          throw FormatException('McpServerRecord.data_scope is required');
        }
        return value;
      })(),
      healthStatus: (() {
        final value = json['health_status']?.toString();
        if (value == null) {
          throw FormatException('McpServerRecord.health_status is required');
        }
        return value;
      })(),
      lifecycleStatus: (() {
        final value = json['lifecycle_status']?.toString();
        if (value == null) {
          throw FormatException('McpServerRecord.lifecycle_status is required');
        }
        return value;
      })(),
      tags: (() {
        final list = _sdkworkAsList(json['tags']);
        if (list == null) {
          return null;
        }
        return list
            .map((item) => item?.toString())
            .whereType<String>()
            .toList();
      })(),
      iconRef: json['icon_ref']?.toString()
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'uuid': uuid,
      'server_key': serverKey,
      'name': name,
      'description': description,
      'category_id': categoryId,
      'category_code': categoryCode,
      'transport': transport,
      'visibility': visibility,
      'data_scope': dataScope,
      'health_status': healthStatus,
      'lifecycle_status': lifecycleStatus,
      'tags': tags?.map((item) => item).toList(),
      'icon_ref': iconRef,
    };
  }
}

class McpConnectorRecord {
  final int id;
  final String uuid;
  final int serverId;
  final String connectorKey;
  final String transport;
  final String publishStatus;
  final String lifecycleStatus;
  final String? endpointUrl;

  McpConnectorRecord({
    required this.id,
    required this.uuid,
    required this.serverId,
    required this.connectorKey,
    required this.transport,
    required this.publishStatus,
    required this.lifecycleStatus,
    this.endpointUrl
  });

  factory McpConnectorRecord.fromJson(Map<String, dynamic> json) {
    return McpConnectorRecord(
      id: (() {
        final value = json['id'];
        if (value is! int) {
          throw FormatException('McpConnectorRecord.id is required');
        }
        return value;
      })(),
      uuid: (() {
        final value = json['uuid']?.toString();
        if (value == null) {
          throw FormatException('McpConnectorRecord.uuid is required');
        }
        return value;
      })(),
      serverId: (() {
        final value = json['server_id'];
        if (value is! int) {
          throw FormatException('McpConnectorRecord.server_id is required');
        }
        return value;
      })(),
      connectorKey: (() {
        final value = json['connector_key']?.toString();
        if (value == null) {
          throw FormatException('McpConnectorRecord.connector_key is required');
        }
        return value;
      })(),
      transport: (() {
        final value = json['transport']?.toString();
        if (value == null) {
          throw FormatException('McpConnectorRecord.transport is required');
        }
        return value;
      })(),
      publishStatus: (() {
        final value = json['publish_status']?.toString();
        if (value == null) {
          throw FormatException('McpConnectorRecord.publish_status is required');
        }
        return value;
      })(),
      lifecycleStatus: (() {
        final value = json['lifecycle_status']?.toString();
        if (value == null) {
          throw FormatException('McpConnectorRecord.lifecycle_status is required');
        }
        return value;
      })(),
      endpointUrl: json['endpoint_url']?.toString()
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'uuid': uuid,
      'server_id': serverId,
      'connector_key': connectorKey,
      'transport': transport,
      'publish_status': publishStatus,
      'lifecycle_status': lifecycleStatus,
      'endpoint_url': endpointUrl,
    };
  }
}

class McpToolRecord {
  final int id;
  final String uuid;
  final int serverId;
  final int connectorId;
  final String toolKey;
  final String name;
  final String? description;
  final bool enabled;
  final String lifecycleStatus;
  final String? riskLevel;
  final bool? requiresApproval;

  McpToolRecord({
    required this.id,
    required this.uuid,
    required this.serverId,
    required this.connectorId,
    required this.toolKey,
    required this.name,
    this.description,
    required this.enabled,
    required this.lifecycleStatus,
    this.riskLevel,
    this.requiresApproval
  });

  factory McpToolRecord.fromJson(Map<String, dynamic> json) {
    return McpToolRecord(
      id: (() {
        final value = json['id'];
        if (value is! int) {
          throw FormatException('McpToolRecord.id is required');
        }
        return value;
      })(),
      uuid: (() {
        final value = json['uuid']?.toString();
        if (value == null) {
          throw FormatException('McpToolRecord.uuid is required');
        }
        return value;
      })(),
      serverId: (() {
        final value = json['server_id'];
        if (value is! int) {
          throw FormatException('McpToolRecord.server_id is required');
        }
        return value;
      })(),
      connectorId: (() {
        final value = json['connector_id'];
        if (value is! int) {
          throw FormatException('McpToolRecord.connector_id is required');
        }
        return value;
      })(),
      toolKey: (() {
        final value = json['tool_key']?.toString();
        if (value == null) {
          throw FormatException('McpToolRecord.tool_key is required');
        }
        return value;
      })(),
      name: (() {
        final value = json['name']?.toString();
        if (value == null) {
          throw FormatException('McpToolRecord.name is required');
        }
        return value;
      })(),
      description: json['description']?.toString(),
      enabled: (() {
        final value = json['enabled'];
        if (value is! bool) {
          throw FormatException('McpToolRecord.enabled is required');
        }
        return value;
      })(),
      lifecycleStatus: (() {
        final value = json['lifecycle_status']?.toString();
        if (value == null) {
          throw FormatException('McpToolRecord.lifecycle_status is required');
        }
        return value;
      })(),
      riskLevel: json['risk_level']?.toString(),
      requiresApproval: json['requires_approval'] is bool ? json['requires_approval'] : null
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'uuid': uuid,
      'server_id': serverId,
      'connector_id': connectorId,
      'tool_key': toolKey,
      'name': name,
      'description': description,
      'enabled': enabled,
      'lifecycle_status': lifecycleStatus,
      'risk_level': riskLevel,
      'requires_approval': requiresApproval,
    };
  }
}

class McpResourceRecord {
  final int id;
  final String uuid;
  final int serverId;
  final int connectorId;
  final String resourceKey;
  final String uri;
  final String name;
  final bool enabled;
  final String lifecycleStatus;

  McpResourceRecord({
    required this.id,
    required this.uuid,
    required this.serverId,
    required this.connectorId,
    required this.resourceKey,
    required this.uri,
    required this.name,
    required this.enabled,
    required this.lifecycleStatus
  });

  factory McpResourceRecord.fromJson(Map<String, dynamic> json) {
    return McpResourceRecord(
      id: (() {
        final value = json['id'];
        if (value is! int) {
          throw FormatException('McpResourceRecord.id is required');
        }
        return value;
      })(),
      uuid: (() {
        final value = json['uuid']?.toString();
        if (value == null) {
          throw FormatException('McpResourceRecord.uuid is required');
        }
        return value;
      })(),
      serverId: (() {
        final value = json['server_id'];
        if (value is! int) {
          throw FormatException('McpResourceRecord.server_id is required');
        }
        return value;
      })(),
      connectorId: (() {
        final value = json['connector_id'];
        if (value is! int) {
          throw FormatException('McpResourceRecord.connector_id is required');
        }
        return value;
      })(),
      resourceKey: (() {
        final value = json['resource_key']?.toString();
        if (value == null) {
          throw FormatException('McpResourceRecord.resource_key is required');
        }
        return value;
      })(),
      uri: (() {
        final value = json['uri']?.toString();
        if (value == null) {
          throw FormatException('McpResourceRecord.uri is required');
        }
        return value;
      })(),
      name: (() {
        final value = json['name']?.toString();
        if (value == null) {
          throw FormatException('McpResourceRecord.name is required');
        }
        return value;
      })(),
      enabled: (() {
        final value = json['enabled'];
        if (value is! bool) {
          throw FormatException('McpResourceRecord.enabled is required');
        }
        return value;
      })(),
      lifecycleStatus: (() {
        final value = json['lifecycle_status']?.toString();
        if (value == null) {
          throw FormatException('McpResourceRecord.lifecycle_status is required');
        }
        return value;
      })()
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'uuid': uuid,
      'server_id': serverId,
      'connector_id': connectorId,
      'resource_key': resourceKey,
      'uri': uri,
      'name': name,
      'enabled': enabled,
      'lifecycle_status': lifecycleStatus,
    };
  }
}

class McpPromptRecord {
  final int id;
  final String uuid;
  final int serverId;
  final int connectorId;
  final String promptKey;
  final String name;
  final bool enabled;
  final String lifecycleStatus;

  McpPromptRecord({
    required this.id,
    required this.uuid,
    required this.serverId,
    required this.connectorId,
    required this.promptKey,
    required this.name,
    required this.enabled,
    required this.lifecycleStatus
  });

  factory McpPromptRecord.fromJson(Map<String, dynamic> json) {
    return McpPromptRecord(
      id: (() {
        final value = json['id'];
        if (value is! int) {
          throw FormatException('McpPromptRecord.id is required');
        }
        return value;
      })(),
      uuid: (() {
        final value = json['uuid']?.toString();
        if (value == null) {
          throw FormatException('McpPromptRecord.uuid is required');
        }
        return value;
      })(),
      serverId: (() {
        final value = json['server_id'];
        if (value is! int) {
          throw FormatException('McpPromptRecord.server_id is required');
        }
        return value;
      })(),
      connectorId: (() {
        final value = json['connector_id'];
        if (value is! int) {
          throw FormatException('McpPromptRecord.connector_id is required');
        }
        return value;
      })(),
      promptKey: (() {
        final value = json['prompt_key']?.toString();
        if (value == null) {
          throw FormatException('McpPromptRecord.prompt_key is required');
        }
        return value;
      })(),
      name: (() {
        final value = json['name']?.toString();
        if (value == null) {
          throw FormatException('McpPromptRecord.name is required');
        }
        return value;
      })(),
      enabled: (() {
        final value = json['enabled'];
        if (value is! bool) {
          throw FormatException('McpPromptRecord.enabled is required');
        }
        return value;
      })(),
      lifecycleStatus: (() {
        final value = json['lifecycle_status']?.toString();
        if (value == null) {
          throw FormatException('McpPromptRecord.lifecycle_status is required');
        }
        return value;
      })()
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'uuid': uuid,
      'server_id': serverId,
      'connector_id': connectorId,
      'prompt_key': promptKey,
      'name': name,
      'enabled': enabled,
      'lifecycle_status': lifecycleStatus,
    };
  }
}

class McpInvocationRecord {
  final int id;
  final String uuid;
  final int serverId;
  final String invocationKind;
  final String targetKey;
  final String? requestId;
  final String? traceId;
  final String? idempotencyKey;
  final String status;
  final String invokedAt;

  McpInvocationRecord({
    required this.id,
    required this.uuid,
    required this.serverId,
    required this.invocationKind,
    required this.targetKey,
    this.requestId,
    this.traceId,
    this.idempotencyKey,
    required this.status,
    required this.invokedAt
  });

  factory McpInvocationRecord.fromJson(Map<String, dynamic> json) {
    return McpInvocationRecord(
      id: (() {
        final value = json['id'];
        if (value is! int) {
          throw FormatException('McpInvocationRecord.id is required');
        }
        return value;
      })(),
      uuid: (() {
        final value = json['uuid']?.toString();
        if (value == null) {
          throw FormatException('McpInvocationRecord.uuid is required');
        }
        return value;
      })(),
      serverId: (() {
        final value = json['server_id'];
        if (value is! int) {
          throw FormatException('McpInvocationRecord.server_id is required');
        }
        return value;
      })(),
      invocationKind: (() {
        final value = json['invocation_kind']?.toString();
        if (value == null) {
          throw FormatException('McpInvocationRecord.invocation_kind is required');
        }
        return value;
      })(),
      targetKey: (() {
        final value = json['target_key']?.toString();
        if (value == null) {
          throw FormatException('McpInvocationRecord.target_key is required');
        }
        return value;
      })(),
      requestId: json['request_id']?.toString(),
      traceId: json['trace_id']?.toString(),
      idempotencyKey: json['idempotency_key']?.toString(),
      status: (() {
        final value = json['status']?.toString();
        if (value == null) {
          throw FormatException('McpInvocationRecord.status is required');
        }
        return value;
      })(),
      invokedAt: (() {
        final value = json['invoked_at']?.toString();
        if (value == null) {
          throw FormatException('McpInvocationRecord.invoked_at is required');
        }
        return value;
      })()
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'uuid': uuid,
      'server_id': serverId,
      'invocation_kind': invocationKind,
      'target_key': targetKey,
      'request_id': requestId,
      'trace_id': traceId,
      'idempotency_key': idempotencyKey,
      'status': status,
      'invoked_at': invokedAt,
    };
  }
}

class McpServerCategoryListResponse {
  final List<McpServerCategoryRecord> items;

  McpServerCategoryListResponse({
    required this.items
  });

  factory McpServerCategoryListResponse.fromJson(Map<String, dynamic> json) {
    return McpServerCategoryListResponse(
      items: (() {
        final list = _sdkworkAsList(json['items']);
        if (list == null) {
          throw FormatException('McpServerCategoryListResponse.items is required');
        }
        return list
            .map((item) => (() {
        final map = _sdkworkAsMap(item);
        return map == null ? null : McpServerCategoryRecord.fromJson(map);
      })())
            .whereType<McpServerCategoryRecord>()
            .toList();
      })()
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}

class McpServerCategoryRecordResponse {
  final McpServerCategoryRecord data;

  McpServerCategoryRecordResponse({
    required this.data
  });

  factory McpServerCategoryRecordResponse.fromJson(Map<String, dynamic> json) {
    return McpServerCategoryRecordResponse(
      data: (() {
        final map = _sdkworkAsMap(json['data']);
        if (map == null) {
          throw FormatException('McpServerCategoryRecordResponse.data is required');
        }
        return McpServerCategoryRecord.fromJson(map);
      })()
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'data': data.toJson(),
    };
  }
}

class McpServerListResponse {
  final List<McpServerRecord> items;

  McpServerListResponse({
    required this.items
  });

  factory McpServerListResponse.fromJson(Map<String, dynamic> json) {
    return McpServerListResponse(
      items: (() {
        final list = _sdkworkAsList(json['items']);
        if (list == null) {
          throw FormatException('McpServerListResponse.items is required');
        }
        return list
            .map((item) => (() {
        final map = _sdkworkAsMap(item);
        return map == null ? null : McpServerRecord.fromJson(map);
      })())
            .whereType<McpServerRecord>()
            .toList();
      })()
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}

class McpServerRecordResponse {
  final McpServerRecord data;

  McpServerRecordResponse({
    required this.data
  });

  factory McpServerRecordResponse.fromJson(Map<String, dynamic> json) {
    return McpServerRecordResponse(
      data: (() {
        final map = _sdkworkAsMap(json['data']);
        if (map == null) {
          throw FormatException('McpServerRecordResponse.data is required');
        }
        return McpServerRecord.fromJson(map);
      })()
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'data': data.toJson(),
    };
  }
}

class McpConnectorListResponse {
  final List<McpConnectorRecord> items;

  McpConnectorListResponse({
    required this.items
  });

  factory McpConnectorListResponse.fromJson(Map<String, dynamic> json) {
    return McpConnectorListResponse(
      items: (() {
        final list = _sdkworkAsList(json['items']);
        if (list == null) {
          throw FormatException('McpConnectorListResponse.items is required');
        }
        return list
            .map((item) => (() {
        final map = _sdkworkAsMap(item);
        return map == null ? null : McpConnectorRecord.fromJson(map);
      })())
            .whereType<McpConnectorRecord>()
            .toList();
      })()
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}

class McpToolListResponse {
  final List<McpToolRecord> items;

  McpToolListResponse({
    required this.items
  });

  factory McpToolListResponse.fromJson(Map<String, dynamic> json) {
    return McpToolListResponse(
      items: (() {
        final list = _sdkworkAsList(json['items']);
        if (list == null) {
          throw FormatException('McpToolListResponse.items is required');
        }
        return list
            .map((item) => (() {
        final map = _sdkworkAsMap(item);
        return map == null ? null : McpToolRecord.fromJson(map);
      })())
            .whereType<McpToolRecord>()
            .toList();
      })()
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}

class McpToolRecordResponse {
  final McpToolRecord data;

  McpToolRecordResponse({
    required this.data
  });

  factory McpToolRecordResponse.fromJson(Map<String, dynamic> json) {
    return McpToolRecordResponse(
      data: (() {
        final map = _sdkworkAsMap(json['data']);
        if (map == null) {
          throw FormatException('McpToolRecordResponse.data is required');
        }
        return McpToolRecord.fromJson(map);
      })()
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'data': data.toJson(),
    };
  }
}

class McpResourceListResponse {
  final List<McpResourceRecord> items;

  McpResourceListResponse({
    required this.items
  });

  factory McpResourceListResponse.fromJson(Map<String, dynamic> json) {
    return McpResourceListResponse(
      items: (() {
        final list = _sdkworkAsList(json['items']);
        if (list == null) {
          throw FormatException('McpResourceListResponse.items is required');
        }
        return list
            .map((item) => (() {
        final map = _sdkworkAsMap(item);
        return map == null ? null : McpResourceRecord.fromJson(map);
      })())
            .whereType<McpResourceRecord>()
            .toList();
      })()
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}

class McpPromptListResponse {
  final List<McpPromptRecord> items;

  McpPromptListResponse({
    required this.items
  });

  factory McpPromptListResponse.fromJson(Map<String, dynamic> json) {
    return McpPromptListResponse(
      items: (() {
        final list = _sdkworkAsList(json['items']);
        if (list == null) {
          throw FormatException('McpPromptListResponse.items is required');
        }
        return list
            .map((item) => (() {
        final map = _sdkworkAsMap(item);
        return map == null ? null : McpPromptRecord.fromJson(map);
      })())
            .whereType<McpPromptRecord>()
            .toList();
      })()
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}

class McpInvocationListResponse {
  final List<McpInvocationRecord> items;

  McpInvocationListResponse({
    required this.items
  });

  factory McpInvocationListResponse.fromJson(Map<String, dynamic> json) {
    return McpInvocationListResponse(
      items: (() {
        final list = _sdkworkAsList(json['items']);
        if (list == null) {
          throw FormatException('McpInvocationListResponse.items is required');
        }
        return list
            .map((item) => (() {
        final map = _sdkworkAsMap(item);
        return map == null ? null : McpInvocationRecord.fromJson(map);
      })())
            .whereType<McpInvocationRecord>()
            .toList();
      })()
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}

class McpInvocationRecordResponse {
  final McpInvocationRecord data;

  McpInvocationRecordResponse({
    required this.data
  });

  factory McpInvocationRecordResponse.fromJson(Map<String, dynamic> json) {
    return McpInvocationRecordResponse(
      data: (() {
        final map = _sdkworkAsMap(json['data']);
        if (map == null) {
          throw FormatException('McpInvocationRecordResponse.data is required');
        }
        return McpInvocationRecord.fromJson(map);
      })()
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'data': data.toJson(),
    };
  }
}

class AppendMcpInvocationCommand {
  final int serverId;
  final int? connectorId;
  final String invocationKind;
  final String targetKey;
  final String? requestId;
  final String? traceId;
  final String? idempotencyKey;
  final String? requestJson;
  final String? responseJson;
  final String? status;
  final String? errorMessage;
  final int? durationMs;

  AppendMcpInvocationCommand({
    required this.serverId,
    this.connectorId,
    required this.invocationKind,
    required this.targetKey,
    this.requestId,
    this.traceId,
    this.idempotencyKey,
    this.requestJson,
    this.responseJson,
    this.status,
    this.errorMessage,
    this.durationMs
  });

  factory AppendMcpInvocationCommand.fromJson(Map<String, dynamic> json) {
    return AppendMcpInvocationCommand(
      serverId: (() {
        final value = json['server_id'];
        if (value is! int) {
          throw FormatException('AppendMcpInvocationCommand.server_id is required');
        }
        return value;
      })(),
      connectorId: json['connector_id'] is int ? json['connector_id'] : null,
      invocationKind: (() {
        final value = json['invocation_kind']?.toString();
        if (value == null) {
          throw FormatException('AppendMcpInvocationCommand.invocation_kind is required');
        }
        return value;
      })(),
      targetKey: (() {
        final value = json['target_key']?.toString();
        if (value == null) {
          throw FormatException('AppendMcpInvocationCommand.target_key is required');
        }
        return value;
      })(),
      requestId: json['request_id']?.toString(),
      traceId: json['trace_id']?.toString(),
      idempotencyKey: json['idempotency_key']?.toString(),
      requestJson: json['request_json']?.toString(),
      responseJson: json['response_json']?.toString(),
      status: json['status']?.toString(),
      errorMessage: json['error_message']?.toString(),
      durationMs: json['duration_ms'] is int ? json['duration_ms'] : null
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'server_id': serverId,
      'connector_id': connectorId,
      'invocation_kind': invocationKind,
      'target_key': targetKey,
      'request_id': requestId,
      'trace_id': traceId,
      'idempotency_key': idempotencyKey,
      'request_json': requestJson,
      'response_json': responseJson,
      'status': status,
      'error_message': errorMessage,
      'duration_ms': durationMs,
    };
  }
}

class CreateMcpServerCommand {
  final String serverKey;
  final String name;
  final String? description;
  final String transport;
  final String? visibility;
  final int? categoryId;
  final String? categoryCode;
  final List<String>? tags;
  final String? iconRef;

  CreateMcpServerCommand({
    required this.serverKey,
    required this.name,
    this.description,
    required this.transport,
    this.visibility,
    this.categoryId,
    this.categoryCode,
    this.tags,
    this.iconRef
  });

  factory CreateMcpServerCommand.fromJson(Map<String, dynamic> json) {
    return CreateMcpServerCommand(
      serverKey: (() {
        final value = json['server_key']?.toString();
        if (value == null) {
          throw FormatException('CreateMcpServerCommand.server_key is required');
        }
        return value;
      })(),
      name: (() {
        final value = json['name']?.toString();
        if (value == null) {
          throw FormatException('CreateMcpServerCommand.name is required');
        }
        return value;
      })(),
      description: json['description']?.toString(),
      transport: (() {
        final value = json['transport']?.toString();
        if (value == null) {
          throw FormatException('CreateMcpServerCommand.transport is required');
        }
        return value;
      })(),
      visibility: json['visibility']?.toString(),
      categoryId: json['category_id'] is int ? json['category_id'] : null,
      categoryCode: json['category_code']?.toString(),
      tags: (() {
        final list = _sdkworkAsList(json['tags']);
        if (list == null) {
          return null;
        }
        return list
            .map((item) => item?.toString())
            .whereType<String>()
            .toList();
      })(),
      iconRef: json['icon_ref']?.toString()
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'server_key': serverKey,
      'name': name,
      'description': description,
      'transport': transport,
      'visibility': visibility,
      'category_id': categoryId,
      'category_code': categoryCode,
      'tags': tags?.map((item) => item).toList(),
      'icon_ref': iconRef,
    };
  }
}

class UpdateMcpServerCommand {
  final String? name;
  final String? description;
  final String? transport;
  final String? visibility;
  final int? categoryId;
  final String? categoryCode;
  final List<String>? tags;
  final String? iconRef;
  final String? lifecycleStatus;

  UpdateMcpServerCommand({
    this.name,
    this.description,
    this.transport,
    this.visibility,
    this.categoryId,
    this.categoryCode,
    this.tags,
    this.iconRef,
    this.lifecycleStatus
  });

  factory UpdateMcpServerCommand.fromJson(Map<String, dynamic> json) {
    return UpdateMcpServerCommand(
      name: json['name']?.toString(),
      description: json['description']?.toString(),
      transport: json['transport']?.toString(),
      visibility: json['visibility']?.toString(),
      categoryId: json['category_id'] is int ? json['category_id'] : null,
      categoryCode: json['category_code']?.toString(),
      tags: (() {
        final list = _sdkworkAsList(json['tags']);
        if (list == null) {
          return null;
        }
        return list
            .map((item) => item?.toString())
            .whereType<String>()
            .toList();
      })(),
      iconRef: json['icon_ref']?.toString(),
      lifecycleStatus: json['lifecycle_status']?.toString()
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'description': description,
      'transport': transport,
      'visibility': visibility,
      'category_id': categoryId,
      'category_code': categoryCode,
      'tags': tags?.map((item) => item).toList(),
      'icon_ref': iconRef,
      'lifecycle_status': lifecycleStatus,
    };
  }
}

class UpsertMcpServerCategoryCommand {
  final String categoryCode;
  final String name;
  final String? description;
  final int? parentId;
  final int? sortOrder;
  final String? iconRef;

  UpsertMcpServerCategoryCommand({
    required this.categoryCode,
    required this.name,
    this.description,
    this.parentId,
    this.sortOrder,
    this.iconRef
  });

  factory UpsertMcpServerCategoryCommand.fromJson(Map<String, dynamic> json) {
    return UpsertMcpServerCategoryCommand(
      categoryCode: (() {
        final value = json['category_code']?.toString();
        if (value == null) {
          throw FormatException('UpsertMcpServerCategoryCommand.category_code is required');
        }
        return value;
      })(),
      name: (() {
        final value = json['name']?.toString();
        if (value == null) {
          throw FormatException('UpsertMcpServerCategoryCommand.name is required');
        }
        return value;
      })(),
      description: json['description']?.toString(),
      parentId: json['parent_id'] is int ? json['parent_id'] : null,
      sortOrder: json['sort_order'] is int ? json['sort_order'] : null,
      iconRef: json['icon_ref']?.toString()
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'category_code': categoryCode,
      'name': name,
      'description': description,
      'parent_id': parentId,
      'sort_order': sortOrder,
      'icon_ref': iconRef,
    };
  }
}

class UpsertMcpConnectorCommand {
  final String connectorKey;
  final String transport;
  final String? endpointUrl;
  final String? commandRef;
  final String? argsJson;
  final String? envSchemaJson;
  final String? authType;
  final String? secretRef;
  final int? timeoutMs;
  final String? retryPolicyJson;
  final String? publishStatus;
  final String? lifecycleStatus;

  UpsertMcpConnectorCommand({
    required this.connectorKey,
    required this.transport,
    this.endpointUrl,
    this.commandRef,
    this.argsJson,
    this.envSchemaJson,
    this.authType,
    this.secretRef,
    this.timeoutMs,
    this.retryPolicyJson,
    this.publishStatus,
    this.lifecycleStatus
  });

  factory UpsertMcpConnectorCommand.fromJson(Map<String, dynamic> json) {
    return UpsertMcpConnectorCommand(
      connectorKey: (() {
        final value = json['connector_key']?.toString();
        if (value == null) {
          throw FormatException('UpsertMcpConnectorCommand.connector_key is required');
        }
        return value;
      })(),
      transport: (() {
        final value = json['transport']?.toString();
        if (value == null) {
          throw FormatException('UpsertMcpConnectorCommand.transport is required');
        }
        return value;
      })(),
      endpointUrl: json['endpoint_url']?.toString(),
      commandRef: json['command_ref']?.toString(),
      argsJson: json['args_json']?.toString(),
      envSchemaJson: json['env_schema_json']?.toString(),
      authType: json['auth_type']?.toString(),
      secretRef: json['secret_ref']?.toString(),
      timeoutMs: json['timeout_ms'] is int ? json['timeout_ms'] : null,
      retryPolicyJson: json['retry_policy_json']?.toString(),
      publishStatus: json['publish_status']?.toString(),
      lifecycleStatus: json['lifecycle_status']?.toString()
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'connector_key': connectorKey,
      'transport': transport,
      'endpoint_url': endpointUrl,
      'command_ref': commandRef,
      'args_json': argsJson,
      'env_schema_json': envSchemaJson,
      'auth_type': authType,
      'secret_ref': secretRef,
      'timeout_ms': timeoutMs,
      'retry_policy_json': retryPolicyJson,
      'publish_status': publishStatus,
      'lifecycle_status': lifecycleStatus,
    };
  }
}

class UpsertMcpToolCommand {
  final int connectorId;
  final String toolKey;
  final String name;
  final String? description;
  final String? inputSchemaJson;
  final String? outputSchemaJson;
  final String? riskLevel;
  final bool? requiresApproval;
  final bool? enabled;
  final int? sortWeight;

  UpsertMcpToolCommand({
    required this.connectorId,
    required this.toolKey,
    required this.name,
    this.description,
    this.inputSchemaJson,
    this.outputSchemaJson,
    this.riskLevel,
    this.requiresApproval,
    this.enabled,
    this.sortWeight
  });

  factory UpsertMcpToolCommand.fromJson(Map<String, dynamic> json) {
    return UpsertMcpToolCommand(
      connectorId: (() {
        final value = json['connector_id'];
        if (value is! int) {
          throw FormatException('UpsertMcpToolCommand.connector_id is required');
        }
        return value;
      })(),
      toolKey: (() {
        final value = json['tool_key']?.toString();
        if (value == null) {
          throw FormatException('UpsertMcpToolCommand.tool_key is required');
        }
        return value;
      })(),
      name: (() {
        final value = json['name']?.toString();
        if (value == null) {
          throw FormatException('UpsertMcpToolCommand.name is required');
        }
        return value;
      })(),
      description: json['description']?.toString(),
      inputSchemaJson: json['input_schema_json']?.toString(),
      outputSchemaJson: json['output_schema_json']?.toString(),
      riskLevel: json['risk_level']?.toString(),
      requiresApproval: json['requires_approval'] is bool ? json['requires_approval'] : null,
      enabled: json['enabled'] is bool ? json['enabled'] : null,
      sortWeight: json['sort_weight'] is int ? json['sort_weight'] : null
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'connector_id': connectorId,
      'tool_key': toolKey,
      'name': name,
      'description': description,
      'input_schema_json': inputSchemaJson,
      'output_schema_json': outputSchemaJson,
      'risk_level': riskLevel,
      'requires_approval': requiresApproval,
      'enabled': enabled,
      'sort_weight': sortWeight,
    };
  }
}

class UpsertMcpResourceCommand {
  final int connectorId;
  final String resourceKey;
  final String uri;
  final String name;
  final String? description;
  final String? mimeType;
  final bool? enabled;

  UpsertMcpResourceCommand({
    required this.connectorId,
    required this.resourceKey,
    required this.uri,
    required this.name,
    this.description,
    this.mimeType,
    this.enabled
  });

  factory UpsertMcpResourceCommand.fromJson(Map<String, dynamic> json) {
    return UpsertMcpResourceCommand(
      connectorId: (() {
        final value = json['connector_id'];
        if (value is! int) {
          throw FormatException('UpsertMcpResourceCommand.connector_id is required');
        }
        return value;
      })(),
      resourceKey: (() {
        final value = json['resource_key']?.toString();
        if (value == null) {
          throw FormatException('UpsertMcpResourceCommand.resource_key is required');
        }
        return value;
      })(),
      uri: (() {
        final value = json['uri']?.toString();
        if (value == null) {
          throw FormatException('UpsertMcpResourceCommand.uri is required');
        }
        return value;
      })(),
      name: (() {
        final value = json['name']?.toString();
        if (value == null) {
          throw FormatException('UpsertMcpResourceCommand.name is required');
        }
        return value;
      })(),
      description: json['description']?.toString(),
      mimeType: json['mime_type']?.toString(),
      enabled: json['enabled'] is bool ? json['enabled'] : null
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'connector_id': connectorId,
      'resource_key': resourceKey,
      'uri': uri,
      'name': name,
      'description': description,
      'mime_type': mimeType,
      'enabled': enabled,
    };
  }
}

class UpsertMcpPromptCommand {
  final int connectorId;
  final String promptKey;
  final String name;
  final String? description;
  final String? argumentsSchemaJson;
  final bool? enabled;

  UpsertMcpPromptCommand({
    required this.connectorId,
    required this.promptKey,
    required this.name,
    this.description,
    this.argumentsSchemaJson,
    this.enabled
  });

  factory UpsertMcpPromptCommand.fromJson(Map<String, dynamic> json) {
    return UpsertMcpPromptCommand(
      connectorId: (() {
        final value = json['connector_id'];
        if (value is! int) {
          throw FormatException('UpsertMcpPromptCommand.connector_id is required');
        }
        return value;
      })(),
      promptKey: (() {
        final value = json['prompt_key']?.toString();
        if (value == null) {
          throw FormatException('UpsertMcpPromptCommand.prompt_key is required');
        }
        return value;
      })(),
      name: (() {
        final value = json['name']?.toString();
        if (value == null) {
          throw FormatException('UpsertMcpPromptCommand.name is required');
        }
        return value;
      })(),
      description: json['description']?.toString(),
      argumentsSchemaJson: json['arguments_schema_json']?.toString(),
      enabled: json['enabled'] is bool ? json['enabled'] : null
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'connector_id': connectorId,
      'prompt_key': promptKey,
      'name': name,
      'description': description,
      'arguments_schema_json': argumentsSchemaJson,
      'enabled': enabled,
    };
  }
}
