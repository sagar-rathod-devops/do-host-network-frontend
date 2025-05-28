import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:do_host/repository/user_experience_api/user_experience_repository.dart';
import 'package:equatable/equatable.dart';

import '../../data/response/api_response.dart';

part 'user_experience_event.dart';
part 'user_experience_state.dart';

class UserExperienceBloc
    extends Bloc<UserExperienceEvent, UserExperienceState> {
  UserExperienceApiRepository userExperienceApiRepository;

  UserExperienceBloc({required this.userExperienceApiRepository})
    : super(const UserExperienceState()) {
    on<UserIdChanged>(_onUserIdChanged);
    on<JobTitleChanged>(_onJobTitleChanged);
    on<CompanyNameChanged>(_onCompanyNameChanged);
    on<LocationChanged>(_onLocationChanged);
    on<JobDescriptionChanged>(_onJobDescriptionChanged);
    on<AchievementsChanged>(_onAchievementsChanged);
    on<StartDateChanged>(_onStartDateChanged);
    on<EndDateChanged>(_onEndDateChanged);
    on<ProfileImageChanged>(_onProfileImageChanged);

    on<UserExperienceApi>(_onFormSubmitted);
  }

  void _onUserIdChanged(
    UserIdChanged event,
    Emitter<UserExperienceState> emit,
  ) {
    emit(state.copyWith(userId: event.userId));
  }

  void _onJobTitleChanged(
    JobTitleChanged event,
    Emitter<UserExperienceState> emit,
  ) {
    emit(state.copyWith(jobTitle: event.jobTitle));
  }

  void _onCompanyNameChanged(
    CompanyNameChanged event,
    Emitter<UserExperienceState> emit,
  ) {
    emit(state.copyWith(companyName: event.companyName));
  }

  void _onLocationChanged(
    LocationChanged event,
    Emitter<UserExperienceState> emit,
  ) {
    emit(state.copyWith(location: event.location));
  }

  void _onJobDescriptionChanged(
    JobDescriptionChanged event,
    Emitter<UserExperienceState> emit,
  ) {
    emit(state.copyWith(jobDescription: event.jobDescription));
  }

  void _onAchievementsChanged(
    AchievementsChanged event,
    Emitter<UserExperienceState> emit,
  ) {
    emit(state.copyWith(achievements: event.achievements));
  }

  void _onStartDateChanged(
    StartDateChanged event,
    Emitter<UserExperienceState> emit,
  ) {
    emit(state.copyWith(startDate: event.startDate));
  }

  void _onEndDateChanged(
    EndDateChanged event,
    Emitter<UserExperienceState> emit,
  ) {
    emit(state.copyWith(endDate: event.endDate));
  }

  void _onProfileImageChanged(
    ProfileImageChanged event,
    Emitter<UserExperienceState> emit,
  ) {
    emit(state.copyWith(profileImage: event.profileImage));
  }

  Future<void> _onFormSubmitted(
    UserExperienceApi event,
    Emitter<UserExperienceState> emit,
  ) async {
    Map<String, String> data = {
      'user_id': state.userId,
      'job_title': state.jobTitle,
      'company_name': state.companyName,
      'location': state.location,
      'job_description': state.jobDescription,
      'start_date': state.startDate,
      'end_date': state.endDate,
      'profile_image': state.profileImage,
      'achievements': state.achievements,
    };

    emit(state.copyWith(userExperienceApi: const ApiResponse.loading()));

    await userExperienceApiRepository
        .userExperienceApi(data)
        .then((value) async {
          if (value.error.isNotEmpty) {
            emit(
              state.copyWith(userExperienceApi: ApiResponse.error(value.error)),
            );
          } else {
            emit(
              state.copyWith(
                userExperienceApi: const ApiResponse.completed(
                  'User Experience',
                ),
              ),
            );
          }
        })
        .onError((error, stackTrace) {
          emit(
            state.copyWith(
              userExperienceApi: ApiResponse.error(error.toString()),
            ),
          );
        });
  }
}
