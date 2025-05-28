part of 'notifications_create_bloc.dart';

class NotificationsCreateState extends Equatable {
  const NotificationsCreateState({
    this.recipientUserId = '',
    this.senderUserId = '',
    this.message = '',
    this.notificationApi = const ApiResponse.completed(''),
  });

  final String recipientUserId;
  final String senderUserId;
  final String message;
  final ApiResponse<String> notificationApi;

  NotificationsCreateState copyWith({
    String? recipientUserId,
    String? senderUserId,
    String? message,
    ApiResponse<String>? notificationApi,
  }) {
    return NotificationsCreateState(
      recipientUserId: recipientUserId ?? this.recipientUserId,
      senderUserId: senderUserId ?? this.senderUserId,
      message: message ?? this.message,
      notificationApi: notificationApi ?? this.notificationApi,
    );
  }

  @override
  List<Object> get props => [
    recipientUserId,
    senderUserId,
    message,
    notificationApi,
  ];
}
