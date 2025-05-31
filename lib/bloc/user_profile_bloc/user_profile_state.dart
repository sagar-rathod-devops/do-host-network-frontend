part of 'user_profile_bloc.dart';

class UserProfileState extends Equatable {
  const UserProfileState({
    this.userId = '',
    this.profileImage,
    this.profileImageBytes,
    this.fullName = '',
    this.designation = '',
    this.organization = '',
    this.professionalSummary = '',
    this.location = '',
    this.email = '',
    this.contactNumber = '',
    this.userProfileApi = const ApiResponse.completed(''),
    this.userUpdateProfileApi = const ApiResponse.completed(''),
    this.hasShownSuccessMessage = false,
  });

  final String userId;
  final io.File? profileImage; // For desktop/mobile
  final Uint8List? profileImageBytes; // For web
  final String fullName;
  final String designation;
  final String organization;
  final String professionalSummary;
  final String location;
  final String email;
  final String contactNumber;
  final ApiResponse<String> userProfileApi;
  final ApiResponse<String> userUpdateProfileApi;
  final bool hasShownSuccessMessage;

  UserProfileState copyWith({
    String? userId,
    io.File? profileImage,
    Uint8List? profileImageBytes,
    String? fullName,
    String? designation,
    String? organization,
    String? professionalSummary,
    String? location,
    String? email,
    String? contactNumber,
    ApiResponse<String>? userProfileApi,
    ApiResponse<String>? userUpdateProfileApi,
    bool? hasShownSuccessMessage,
  }) {
    return UserProfileState(
      userId: userId ?? this.userId,
      profileImage: profileImage ?? this.profileImage,
      profileImageBytes: profileImageBytes ?? this.profileImageBytes,
      fullName: fullName ?? this.fullName,
      designation: designation ?? this.designation,
      organization: organization ?? this.organization,
      professionalSummary: professionalSummary ?? this.professionalSummary,
      location: location ?? this.location,
      email: email ?? this.email,
      contactNumber: contactNumber ?? this.contactNumber,
      userProfileApi: userProfileApi ?? this.userProfileApi,
      userUpdateProfileApi: userUpdateProfileApi ?? this.userUpdateProfileApi,
      hasShownSuccessMessage:
          hasShownSuccessMessage ?? this.hasShownSuccessMessage,
    );
  }

  @override
  List<Object?> get props => [
    userId,
    profileImage,
    profileImageBytes,
    fullName,
    designation,
    organization,
    professionalSummary,
    location,
    email,
    contactNumber,
    userProfileApi,
    userUpdateProfileApi,
    hasShownSuccessMessage,
  ];
}
