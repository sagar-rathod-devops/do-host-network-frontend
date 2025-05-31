import 'dart:async';
import 'dart:io' as io;
import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:do_host/services/session_manager/session_controller.dart';
import 'package:equatable/equatable.dart';

import '../../data/response/api_response.dart';
import '../../repository/user_profile_api/user_profile_repository.dart';

part 'user_profile_event.dart';
part 'user_profile_state.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  final UserProfileApiRepository userProfileApiRepository;

  UserProfileBloc({required this.userProfileApiRepository})
    : super(const UserProfileState()) {
    on<UserIdChanged>(_onUserIdChanged);
    on<ProfileImageChanged>(_onProfileImageChanged);
    on<ProfileImageChangedWeb>(_onProfileImageChangedWeb);
    on<HasShownSuccessMessageChanged>(_onHasShownSuccessMessageChanged);
    on<FullNameChanged>(_onFullNameChanged);
    on<DesignationChanged>(_onDesignationChanged);
    on<OrganizationChanged>(_onOrganizationChanged);
    on<ProfessionalSummaryChanged>(_onProfessionalSummaryChanged);
    on<LocationChanged>(_onLocationChanged);
    on<EmailChanged>(_onEmailChanged);
    on<ContactNumberChanged>(_onContactNumberChanged);
    on<SubmitUserProfile>(_onSubmitUserProfile);
    on<SubmitUserUpdateProfile>(_onSubmitUserUpdateProfile);
  }

  void _onUserIdChanged(UserIdChanged event, Emitter<UserProfileState> emit) {
    emit(state.copyWith(userId: event.userId));
  }

  void _onProfileImageChanged(
    ProfileImageChanged event,
    Emitter<UserProfileState> emit,
  ) {
    emit(
      state.copyWith(
        profileImage: event.profileImage, // <-- use profileImage here
        profileImageBytes: null,
      ),
    );
  }

  void _onProfileImageChangedWeb(
    ProfileImageChangedWeb event,
    Emitter<UserProfileState> emit,
  ) {
    emit(
      state.copyWith(profileImageBytes: event.imageBytes, profileImage: null),
    );
  }

  void _onHasShownSuccessMessageChanged(
    HasShownSuccessMessageChanged event,
    Emitter<UserProfileState> emit,
  ) {
    emit(state.copyWith(hasShownSuccessMessage: event.hasShown));
  }

  Future<void> _onFullNameChanged(
    FullNameChanged event,
    Emitter<UserProfileState> emit,
  ) async {
    emit(state.copyWith(fullName: event.fullName));

    // Save the full name using SessionController
    await SessionController().saveFullName(event.fullName);
  }

  void _onDesignationChanged(
    DesignationChanged event,
    Emitter<UserProfileState> emit,
  ) {
    emit(state.copyWith(designation: event.designation));
  }

  void _onOrganizationChanged(
    OrganizationChanged event,
    Emitter<UserProfileState> emit,
  ) {
    emit(state.copyWith(organization: event.organization));
  }

  void _onProfessionalSummaryChanged(
    ProfessionalSummaryChanged event,
    Emitter<UserProfileState> emit,
  ) {
    emit(state.copyWith(professionalSummary: event.professionalSummary));
  }

  void _onLocationChanged(
    LocationChanged event,
    Emitter<UserProfileState> emit,
  ) {
    emit(state.copyWith(location: event.location));
  }

  void _onEmailChanged(EmailChanged event, Emitter<UserProfileState> emit) {
    emit(state.copyWith(email: event.email));
  }

  void _onContactNumberChanged(
    ContactNumberChanged event,
    Emitter<UserProfileState> emit,
  ) {
    emit(state.copyWith(contactNumber: event.contactNumber));
  }

  /// Helper method to construct the data map
  Map<String, String> _buildProfileDataMap(UserProfileState state) {
    return {
      'user_id': state.userId,
      'full_name': state.fullName,
      'designation': state.designation,
      'organization': state.organization,
      'professional_summary': state.professionalSummary,
      'location': state.location,
      'email': state.email,
      'contact_number': state.contactNumber,
    };
  }

  Future<void> _onSubmitUserProfile(
    SubmitUserProfile event,
    Emitter<UserProfileState> emit,
  ) async {
    emit(state.copyWith(userProfileApi: const ApiResponse.loading()));

    try {
      final data = _buildProfileDataMap(state);

      final response = await userProfileApiRepository.userProfileApi(
        data,
        state.profileImage,
      );

      if (response.error.isNotEmpty) {
        emit(state.copyWith(userProfileApi: ApiResponse.error(response.error)));
      } else {
        emit(
          state.copyWith(
            userProfileApi: const ApiResponse.completed('User-Profile Created'),
          ),
        );
      }
    } catch (e) {
      emit(state.copyWith(userProfileApi: ApiResponse.error(e.toString())));
    }
  }

  Future<void> _onSubmitUserUpdateProfile(
    SubmitUserUpdateProfile event,
    Emitter<UserProfileState> emit,
  ) async {
    emit(state.copyWith(userUpdateProfileApi: const ApiResponse.loading()));

    try {
      final data = _buildProfileDataMap(state);

      final response = await userProfileApiRepository.userProfileUpdateApi(
        data,
        state.profileImage,
      );

      if (response.error.isNotEmpty) {
        emit(
          state.copyWith(
            userUpdateProfileApi: ApiResponse.error(response.error),
          ),
        );
      } else {
        emit(
          state.copyWith(
            userUpdateProfileApi: const ApiResponse.completed(
              'User-Profile Updated',
            ),
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(userUpdateProfileApi: ApiResponse.error(e.toString())),
      );
    }
  }
}
