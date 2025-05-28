part of 'logout_bloc.dart';

class LogoutState extends Equatable {
  const LogoutState({this.logoutApi = const ApiResponse.completed('')});

  final ApiResponse<String> logoutApi;

  LogoutState copyWith({ApiResponse<String>? logoutApi}) {
    return LogoutState(logoutApi: logoutApi ?? this.logoutApi);
  }

  @override
  List<Object> get props => [logoutApi];
}
