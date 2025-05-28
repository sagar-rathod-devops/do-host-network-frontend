part of 'user_profile_bloc.dart';

class UserProfileState extends Equatable {
  const UserProfileState({
    this.userId = '',
    this.profileImage,
    this.fullName = '',
    this.designation = '',
    this.organization = '',
    this.professionalSummary = '',
    this.location = '',
    this.email = '',
    this.contactNumber = '',
    this.userProfileApi = const ApiResponse.completed(''),
    this.userUpdateProfileApi = const ApiResponse.completed(''),
    this.hasShownSuccessMessage = false, // NEW FIELD
  });

  final String userId;
  final File? profileImage;
  final String fullName;
  final String designation;
  final String organization;
  final String professionalSummary;
  final String location;
  final String email;
  final String contactNumber;
  final ApiResponse<String> userProfileApi;
  final ApiResponse<String> userUpdateProfileApi;
  final bool hasShownSuccessMessage; // NEW FIELD

  UserProfileState copyWith({
    String? userId,
    File? profileImage,
    String? fullName,
    String? designation,
    String? organization,
    String? professionalSummary,
    String? location,
    String? email,
    String? contactNumber,
    ApiResponse<String>? userProfileApi,
    ApiResponse<String>? userUpdateProfileApi,
    bool? hasShownSuccessMessage, // NEW FIELD
  }) {
    return UserProfileState(
      userId: userId ?? this.userId,
      profileImage: profileImage ?? this.profileImage,
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
    fullName,
    designation,
    organization,
    professionalSummary,
    location,
    email,
    contactNumber,
    userProfileApi,
    userUpdateProfileApi,
    hasShownSuccessMessage, // Include in props
  ];
}
