import 'package:bloc/bloc.dart';
import 'package:do_host/model/all_user_profile_get/all_user_profile_get_model.dart';
import 'package:do_host/repository/all_user_profile_get_api/all_user_profile_get_api_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../../data/response/api_response.dart';

part 'all_user_profile_get_bloc_event.dart';
part 'all_user_profile_get_bloc_state.dart';

class AllUserProfileGetBlocBloc
    extends Bloc<AllUserProfileGetBlocEvent, AllUserProfileGetBlocState> {
  final AllUserProfileGetApiRepository allUserProfileGetApiRepository;

  AllUserProfileGetBlocBloc({required this.allUserProfileGetApiRepository})
    : super(
        AllUserProfileGetBlocState(
          allUserProfileGetList: ApiResponse.loading(),
        ),
      ) {
    on<AllUserProfileGetFetch>(_fetchPostAllContentGetList);
  }

  Future<void> _fetchPostAllContentGetList(
    AllUserProfileGetFetch event,
    Emitter<AllUserProfileGetBlocState> emit,
  ) async {
    try {
      final response = await allUserProfileGetApiRepository
          .fetchAllUserProfileList();

      emit(
        state.copyWith(allUserProfileGetList: ApiResponse.completed(response)),
      );
      debugPrint(
        "BLoC: Profiles fetched successfully: ${response.profiles.length}",
      );
    } catch (error, stackTrace) {
      if (kDebugMode) {
        print(stackTrace);
        print(error);
      }
      emit(
        state.copyWith(
          allUserProfileGetList: ApiResponse.error(error.toString()),
        ),
      );
    }
  }
}
