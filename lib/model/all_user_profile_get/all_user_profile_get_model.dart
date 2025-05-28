class AllUserProfile {
  final String id;
  final String userId;
  final String? profileImage;
  final String fullName;
  final String designation;
  final String organization;
  final String professionalSummary;
  final String location;
  final String email;
  final String contactNumber;
  final String createdAt;
  final String updatedAt;

  AllUserProfile({
    required this.id,
    required this.userId,
    this.profileImage,
    required this.fullName,
    required this.designation,
    required this.organization,
    required this.professionalSummary,
    required this.location,
    required this.email,
    required this.contactNumber,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AllUserProfile.fromJson(Map<String, dynamic> json) {
    return AllUserProfile(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      profileImage: json['profile_image'],
      fullName: json['full_name'] ?? '',
      designation: json['designation'] ?? '',
      organization: json['organization'] ?? '',
      professionalSummary: json['professional_summary'] ?? '',
      location: json['location'] ?? '',
      email: json['email'] ?? '',
      contactNumber: json['contact_number'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}

class AllUserProfileResponse {
  final List<AllUserProfile> profiles;

  AllUserProfileResponse({required this.profiles});

  factory AllUserProfileResponse.fromJson(List<dynamic> jsonList) {
    return AllUserProfileResponse(
      profiles: jsonList
          .map((item) => AllUserProfile.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
