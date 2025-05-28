part of 'user_education_bloc.dart';

class UserEducationState extends Equatable {
  const UserEducationState({
    this.userId = '',
    this.degree = '',
    this.institutionName = '',
    this.fieldOfStudy = '',
    this.grade = '',
    this.year = '',
    this.userEducationApi = const ApiResponse.completed(''),
  });

  final String userId;
  final String degree;
  final String institutionName;
  final String fieldOfStudy;
  final String grade;
  final String year;
  final ApiResponse<String> userEducationApi;

  UserEducationState copyWith({
    String? userId,
    String? degree,
    String? institutionName,
    String? fieldOfStudy,
    String? grade,
    String? year,
    ApiResponse<String>? userEducationApi,
  }) {
    return UserEducationState(
      userId: userId ?? this.userId,
      degree: degree ?? this.degree,
      institutionName: institutionName ?? this.institutionName,
      fieldOfStudy: fieldOfStudy ?? this.fieldOfStudy,
      grade: grade ?? this.grade,
      year: year ?? this.year,
      userEducationApi: userEducationApi ?? this.userEducationApi,
    );
  }

  @override
  List<Object> get props => [
    userId,
    degree,
    institutionName,
    fieldOfStudy,
    grade,
    year,
    userEducationApi,
  ];
}
