class NotificationListModel {
  List<NotificationItem> notifications;
  String error;

  NotificationListModel({List<NotificationItem>? notifications, String? error})
    : notifications = notifications ?? [],
      error = error ?? '';

  factory NotificationListModel.fromJson(Map<String, dynamic> json) {
    return NotificationListModel(
      notifications:
          (json['notifications'] as List<dynamic>?)
              ?.map((e) => NotificationItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      error: json['error'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notifications': notifications.map((e) => e.toJson()).toList(),
      'error': error,
    };
  }
}

class NotificationItem {
  String id;
  String recipientUserId;
  String senderUserId;
  String type;
  String entityId;
  String entityType;
  String message;
  bool isRead;
  String createdAt;

  NotificationItem({
    this.id = '',
    this.recipientUserId = '',
    this.senderUserId = '',
    this.type = '',
    this.entityId = '',
    this.entityType = '',
    this.message = '',
    this.isRead = false,
    this.createdAt = '',
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'] as String? ?? '',
      recipientUserId: json['recipient_user_id'] as String? ?? '',
      senderUserId: json['sender_user_id'] as String? ?? '',
      type: json['type'] as String? ?? '',
      entityId: json['entity_id'] as String? ?? '',
      entityType: json['entity_type'] as String? ?? '',
      message: json['message'] as String? ?? '',
      isRead: json['is_read'] as bool? ?? false,
      createdAt: json['created_at'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'recipient_user_id': recipientUserId,
      'sender_user_id': senderUserId,
      'type': type,
      'entity_id': entityId,
      'entity_type': entityType,
      'message': message,
      'is_read': isRead,
      'created_at': createdAt,
    };
  }
}
