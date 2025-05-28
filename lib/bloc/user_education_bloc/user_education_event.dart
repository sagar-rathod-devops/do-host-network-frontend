part of 'user_education_bloc.dart';

sealed class UserEducationEvent extends Equatable {
  const UserEducationEvent();
  @override
  List<Object> get props => [];
}

class UserIdChanged extends UserEducationEvent {
  final String userId;
  const UserIdChanged({required this.userId});
  @override
  List<Object> get props => [userId];
}

class DegreeChanged extends UserEducationEvent {
  final String degree;
  const DegreeChanged({required this.degree});
  @override
  List<Object> get props => [degree];
}

class InstitutionNameChanged extends UserEducationEvent {
  final String institutionName;
  const InstitutionNameChanged({required this.institutionName});
  @override
  List<Object> get props => [institutionName];
}

class FieldOfStudyChanged extends UserEducationEvent {
  final String fieldOfStudy;
  const FieldOfStudyChanged({required this.fieldOfStudy});
  @override
  List<Object> get props => [fieldOfStudy];
}

class GradeChanged extends UserEducationEvent {
  final String grade;
  const GradeChanged({required this.grade});
  @override
  List<Object> get props => [grade];
}

class YearChanged extends UserEducationEvent {
  final String year;
  const YearChanged({required this.year});
  @override
  List<Object> get props => [year];
}

class UserEducationApi extends UserEducationEvent {
  const UserEducationApi();
}
