part of 'verify_otp_bloc.dart';

sealed class VerifyOtpEvent extends Equatable {
  const VerifyOtpEvent();
  @override
  List<Object> get props => [];
}

class EmailChanged extends VerifyOtpEvent {
  final String email;
  const EmailChanged({required this.email});
  @override
  List<Object> get props => [email];
}

class OTPChanged extends VerifyOtpEvent {
  final String otp;
  const OTPChanged({required this.otp});

  @override
  List<Object> get props => [otp];
}

class VerifyOTPApi extends VerifyOtpEvent {
  const VerifyOTPApi();
}
