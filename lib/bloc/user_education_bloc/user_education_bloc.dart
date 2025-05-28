import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:do_host/repository/user_education_api/user_education_repository.dart';
import 'package:equatable/equatable.dart';

import '../../data/response/api_response.dart';

part 'user_education_event.dart';
part 'user_education_state.dart';

class UserEducationBloc extends Bloc<UserEducationEvent, UserEducationState> {
  UserEducationApiRepository userEducationApiRepository;

  UserEducationBloc({required this.userEducationApiRepository})
    : super(const UserEducationState()) {
    on<UserIdChanged>(_onUserIdChanged);
    on<DegreeChanged>(_onDegreeChanged);
    on<InstitutionNameChanged>(_onInstitutionNameChanged);
    on<FieldOfStudyChanged>(_onFieldOfStudyChanged);
    on<GradeChanged>(_onGradeChanged);
    on<YearChanged>(_onYearChanged);
    on<UserEducationApi>(_onFormSubmitted);
  }

  void _onUserIdChanged(UserIdChanged event, Emitter<UserEducationState> emit) {
    emit(state.copyWith(userId: event.userId));
  }

  void _onDegreeChanged(DegreeChanged event, Emitter<UserEducationState> emit) {
    emit(state.copyWith(degree: event.degree));
  }

  void _onInstitutionNameChanged(
    InstitutionNameChanged event,
    Emitter<UserEducationState> emit,
  ) {
    emit(state.copyWith(institutionName: event.institutionName));
  }

  void _onFieldOfStudyChanged(
    FieldOfStudyChanged event,
    Emitter<UserEducationState> emit,
  ) {
    emit(state.copyWith(fieldOfStudy: event.fieldOfStudy));
  }

  void _onGradeChanged(GradeChanged event, Emitter<UserEducationState> emit) {
    emit(state.copyWith(grade: event.grade));
  }

  void _onYearChanged(YearChanged event, Emitter<UserEducationState> emit) {
    emit(state.copyWith(year: event.year));
  }

  Future<void> _onFormSubmitted(
    UserEducationApi event,
    Emitter<UserEducationState> emit,
  ) async {
    Map<String, String> data = {
      'user_id': state.userId,
      'degree': state.degree,
      'institution_name': state.institutionName,
      'field_of_study': state.fieldOfStudy,
      'grade': state.grade,
      'year': state.year,
    };

    emit(state.copyWith(userEducationApi: const ApiResponse.loading()));

    await userEducationApiRepository
        .userEducationApi(data)
        .then((value) async {
          if (value.error.isNotEmpty) {
            emit(
              state.copyWith(userEducationApi: ApiResponse.error(value.error)),
            );
          } else {
            emit(
              state.copyWith(
                userEducationApi: const ApiResponse.completed('User Education'),
              ),
            );
          }
        })
        .onError((error, stackTrace) {
          emit(
            state.copyWith(
              userEducationApi: ApiResponse.error(error.toString()),
            ),
          );
        });
  }
}
