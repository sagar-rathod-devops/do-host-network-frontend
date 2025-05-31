part of 'user_profile_bloc.dart';

abstract class UserProfileEvent extends Equatable {
  const UserProfileEvent();

  @override
  List<Object?> get props => [];
}

class UserIdChanged extends UserProfileEvent {
  final String userId;
  const UserIdChanged({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class FullNameChanged extends UserProfileEvent {
  final String fullName;
  const FullNameChanged({required this.fullName});

  @override
  List<Object?> get props => [fullName];
}

class ProfileImageChanged extends UserProfileEvent {
  final io.File profileImage;
  const ProfileImageChanged({required this.profileImage});

  @override
  List<Object?> get props => [profileImage];
}

class ProfileImageChangedWeb extends UserProfileEvent {
  final Uint8List imageBytes;
  const ProfileImageChangedWeb({required this.imageBytes});

  @override
  List<Object?> get props => [imageBytes];
}

class HasShownSuccessMessageChanged extends UserProfileEvent {
  final bool hasShown;
  const HasShownSuccessMessageChanged({required this.hasShown});

  @override
  List<Object?> get props => [hasShown];
}

class DesignationChanged extends UserProfileEvent {
  final String designation;
  const DesignationChanged({required this.designation});

  @override
  List<Object?> get props => [designation];
}

class OrganizationChanged extends UserProfileEvent {
  final String organization;
  const OrganizationChanged({required this.organization});

  @override
  List<Object?> get props => [organization];
}

class ProfessionalSummaryChanged extends UserProfileEvent {
  final String professionalSummary;
  const ProfessionalSummaryChanged({required this.professionalSummary});

  @override
  List<Object?> get props => [professionalSummary];
}

class LocationChanged extends UserProfileEvent {
  final String location;
  const LocationChanged({required this.location});

  @override
  List<Object?> get props => [location];
}

class EmailChanged extends UserProfileEvent {
  final String email;
  const EmailChanged({required this.email});

  @override
  List<Object?> get props => [email];
}

class ContactNumberChanged extends UserProfileEvent {
  final String contactNumber;
  const ContactNumberChanged({required this.contactNumber});

  @override
  List<Object?> get props => [contactNumber];
}

class SubmitUserProfile extends UserProfileEvent {
  const SubmitUserProfile();
}

class SubmitUserUpdateProfile extends UserProfileEvent {
  const SubmitUserUpdateProfile();
}
