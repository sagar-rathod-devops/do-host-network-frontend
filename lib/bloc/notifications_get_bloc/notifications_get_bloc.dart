// import 'dart:async';
//
// import 'package:bloc/bloc.dart';
// import 'package:do_host/model/notifications_get/notification_list_model.dart';
// import 'package:equatable/equatable.dart';
// import 'package:flutter/foundation.dart';
//
// import '../../data/response/api_response.dart';
// import '../../repository/notifications_get_api/notifications_get_api_repository.dart';
//
// part 'notifications_get_event.dart';
// part 'notifications_get_state.dart';
//
// class NotificationsGetBloc
//     extends Bloc<NotificationsGetEvent, NotificationsGetState> {
//   NotificationsGetApiRepository notificationsGetApiRepository;
//   NotificationsGetBloc({required this.notificationsGetApiRepository})
//     : super(
//         NotificationsGetState(notificationsGetList: ApiResponse.loading()),
//       ) {
//     on<NotificationsGetFetch>(fetchNotificationsGetListApi);
//   }
//
//   Future<void> fetchNotificationsGetListApi(
//     NotificationsGetFetch event,
//     Emitter<NotificationsGetState> emit,
//   ) async {
//     await notificationsGetApiRepository
//         .fetchNotificationsList()
//         .then((response) {
//           emit(
//             state.copyWith(
//               notificationsGetList: ApiResponse.completed(response),
//             ),
//           );
//         })
//         .onError((error, stackTrace) {
//           if (kDebugMode) {
//             print(stackTrace);
//             print(error);
//           }
//
//           emit(
//             state.copyWith(
//               notificationsGetList: ApiResponse.error(error.toString()),
//             ),
//           );
//         });
//   }
// }
