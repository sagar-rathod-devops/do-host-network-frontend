import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:do_host/repository/verify_otp_api/verify_otp_api_repository.dart';
import 'package:equatable/equatable.dart';

import '../../data/response/api_response.dart';

part 'verify_otp_event.dart';
part 'verify_otp_state.dart';

class VerifyOtpBloc extends Bloc<VerifyOtpEvent, VerifyOtpState> {
  VerifyOtpApiRepository verifyOtpApiRepository;

  VerifyOtpBloc({required this.verifyOtpApiRepository})
    : super(const VerifyOtpState()) {
    on<EmailChanged>(_onEmailChanged);
    on<OTPChanged>(_onOTPChanged);
    on<VerifyOTPApi>(_onFormSubmitted);
  }

  void _onEmailChanged(EmailChanged event, Emitter<VerifyOtpState> emit) {
    print("BLoC received email: ${event.email}"); // Add this
    emit(state.copyWith(email: event.email));
  }

  void _onOTPChanged(OTPChanged event, Emitter<VerifyOtpState> emit) {
    print("BLoC State OTP: ${state.otp}");
    emit(state.copyWith(otp: event.otp));
  }

  Future<void> _onFormSubmitted(
    VerifyOTPApi event,
    Emitter<VerifyOtpState> emit,
  ) async {
    final data = {'email': state.email, 'otp': state.otp};

    emit(state.copyWith(verifyOTPApi: const ApiResponse.loading()));

    try {
      final value = await verifyOtpApiRepository.verifyOTPApi(data);
      if (value.error.isNotEmpty) {
        emit(state.copyWith(verifyOTPApi: ApiResponse.error(value.error)));
      } else {
        emit(
          state.copyWith(
            verifyOTPApi: const ApiResponse.completed('Verify OTP'),
          ),
        );
      }
    } catch (error) {
      emit(state.copyWith(verifyOTPApi: ApiResponse.error(error.toString())));
    }
  }
}
