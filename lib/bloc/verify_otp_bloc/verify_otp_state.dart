part of 'verify_otp_bloc.dart';

class VerifyOtpState extends Equatable {
  const VerifyOtpState({
    this.email = '',
    this.otp = '',
    this.verifyOTPApi = const ApiResponse.completed(''),
  });

  final String email;
  final String otp;
  final ApiResponse<String> verifyOTPApi;

  VerifyOtpState copyWith({
    String? email,
    String? otp,
    ApiResponse<String>? verifyOTPApi,
  }) {
    return VerifyOtpState(
      email: email ?? this.email,
      otp: otp ?? this.otp,
      verifyOTPApi: verifyOTPApi ?? this.verifyOTPApi,
    );
  }

  @override
  List<Object> get props => [email, otp, verifyOTPApi];
}
