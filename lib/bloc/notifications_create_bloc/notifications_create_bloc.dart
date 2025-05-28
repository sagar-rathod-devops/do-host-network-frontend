import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:do_host/repository/notifications_create_api/notifications_create_repository.dart';
import 'package:equatable/equatable.dart';

import '../../data/response/api_response.dart';

part 'notifications_create_event.dart';
part 'notifications_create_state.dart';

class NotificationsCreateBloc
    extends Bloc<NotificationsCreateEvent, NotificationsCreateState> {
  NotificationsCreateApiRepository notificationsCreateApiRepository;

  NotificationsCreateBloc({required this.notificationsCreateApiRepository})
    : super(const NotificationsCreateState()) {
    on<RecipientUserIdChanged>(_onRecipientUserIdChanged);
    on<SenderUserIdChanged>(_onSenderUserIdChanged);
    on<MessageChanged>(_onMessageChanged);
    on<NotificationApi>(_onFormSubmitted);
  }

  void _onRecipientUserIdChanged(
    RecipientUserIdChanged event,
    Emitter<NotificationsCreateState> emit,
  ) {
    emit(state.copyWith(recipientUserId: event.recipientUserId));
  }

  void _onSenderUserIdChanged(
    SenderUserIdChanged event,
    Emitter<NotificationsCreateState> emit,
  ) {
    emit(state.copyWith(senderUserId: event.senderUserId));
  }

  void _onMessageChanged(
    MessageChanged event,
    Emitter<NotificationsCreateState> emit,
  ) {
    emit(state.copyWith(message: event.message));
  }

  Future<void> _onFormSubmitted(
    NotificationApi event,
    Emitter<NotificationsCreateState> emit,
  ) async {
    Map<String, String> data = {
      'recipient_user_id': state.recipientUserId,
      'sender_user_id': state.senderUserId,
      'message': state.message,
    };

    emit(state.copyWith(notificationApi: const ApiResponse.loading()));

    await notificationsCreateApiRepository
        .notificationsCreateApi(data)
        .then((value) async {
          if (value.error.isNotEmpty) {
            emit(
              state.copyWith(notificationApi: ApiResponse.error(value.error)),
            );
          } else {
            emit(
              state.copyWith(
                notificationApi: const ApiResponse.completed('Sign-Up'),
              ),
            );
          }
        })
        .onError((error, stackTrace) {
          emit(
            state.copyWith(
              notificationApi: ApiResponse.error(error.toString()),
            ),
          );
        });
  }
}
