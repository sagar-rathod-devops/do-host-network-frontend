part of 'notifications_create_bloc.dart';

sealed class NotificationsCreateEvent extends Equatable {
  const NotificationsCreateEvent();
  @override
  List<Object> get props => [];
}

class RecipientUserIdChanged extends NotificationsCreateEvent {
  final String recipientUserId;
  const RecipientUserIdChanged({required this.recipientUserId});
  @override
  List<Object> get props => [recipientUserId];
}

class SenderUserIdChanged extends NotificationsCreateEvent {
  final String senderUserId;
  const SenderUserIdChanged({required this.senderUserId});
  @override
  List<Object> get props => [senderUserId];
}

class MessageChanged extends NotificationsCreateEvent {
  final String message;
  const MessageChanged({required this.message});
  @override
  List<Object> get props => [message];
}

class NotificationApi extends NotificationsCreateEvent {
  const NotificationApi();
}
