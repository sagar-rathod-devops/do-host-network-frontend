import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:do_host/repository/post_job_api/post_job_repository.dart';
import 'package:equatable/equatable.dart';

import '../../data/response/api_response.dart';

part 'post_job_event.dart';
part 'post_job_state.dart';

class PostJobBloc extends Bloc<PostJobEvent, PostJobState> {
  PostJobApiRepository postJobApiRepository;

  PostJobBloc({required this.postJobApiRepository})
    : super(const PostJobState()) {
    on<UserIdChanged>(_onUserIdChanged);
    on<JobTitleChanged>(_onJobTitleChanged);
    on<CompanyNameChanged>(_onCompanyNameChanged);
    on<JobDescriptionChanged>(_onJobDescriptionChanged);
    on<JobApplyUrlChanged>(_onJobApplyUrlChanged);
    on<LocationChanged>(_onLocationChanged);
    on<LastDateToApplyChanged>(_onLastDateToApplyChanged);
    on<PostJobApi>(_onFormSubmitted);
  }

  void _onUserIdChanged(UserIdChanged event, Emitter<PostJobState> emit) {
    emit(state.copyWith(userId: event.userId));
  }

  void _onJobTitleChanged(JobTitleChanged event, Emitter<PostJobState> emit) {
    emit(state.copyWith(jobTitle: event.jobTitle));
  }

  void _onCompanyNameChanged(
    CompanyNameChanged event,
    Emitter<PostJobState> emit,
  ) {
    emit(state.copyWith(companyName: event.companyName));
  }

  void _onJobDescriptionChanged(
    JobDescriptionChanged event,
    Emitter<PostJobState> emit,
  ) {
    emit(state.copyWith(jobDescription: event.jobDescription));
  }

  void _onJobApplyUrlChanged(
    JobApplyUrlChanged event,
    Emitter<PostJobState> emit,
  ) {
    emit(state.copyWith(jobApplyUrl: event.jobApplyUrl));
  }

  void _onLocationChanged(LocationChanged event, Emitter<PostJobState> emit) {
    emit(state.copyWith(location: event.location));
  }

  void _onLastDateToApplyChanged(
    LastDateToApplyChanged event,
    Emitter<PostJobState> emit,
  ) {
    emit(state.copyWith(lastDateToApply: event.lastDateToApply));
  }

  Future<void> _onFormSubmitted(
    PostJobApi event,
    Emitter<PostJobState> emit,
  ) async {
    Map<String, String> data = {
      'user_id': state.userId,
      'job_title': state.jobTitle,
      'company_name': state.companyName,
      'job_description': state.jobDescription,
      'job_apply_url': state.jobApplyUrl,
      'location': state.location,
      'last_date_to_apply': state.lastDateToApply,
    };

    emit(state.copyWith(postJobApi: const ApiResponse.loading()));

    await postJobApiRepository
        .postJobApi(data)
        .then((value) async {
          if (value.error.isNotEmpty) {
            emit(state.copyWith(postJobApi: ApiResponse.error(value.error)));
          } else {
            emit(
              state.copyWith(
                postJobApi: const ApiResponse.completed('Post-Job'),
              ),
            );
          }
        })
        .onError((error, stackTrace) {
          emit(state.copyWith(postJobApi: ApiResponse.error(error.toString())));
        });
  }
}
