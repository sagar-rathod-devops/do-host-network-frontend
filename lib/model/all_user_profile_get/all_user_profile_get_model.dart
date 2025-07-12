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
      id: json['ID'] ?? '',
      userId: json['UserID'] ?? '',
      profileImage: json['ProfileImage'],
      fullName: json['FullName'] ?? '',
      designation: json['Designation'] ?? '',
      organization: json['Organization'] ?? '',
      professionalSummary: json['ProfessionalSummary'] ?? '',
      location: json['Location'] ?? '',
      email: json['Email'] ?? '',
      contactNumber: json['ContactNumber'] ?? '',
      createdAt: json['CreatedAt'] ?? '',
      updatedAt: json['UpdatedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'UserID': userId,
      'ProfileImage': profileImage,
      'FullName': fullName,
      'Designation': designation,
      'Organization': organization,
      'ProfessionalSummary': professionalSummary,
      'Location': location,
      'Email': email,
      'ContactNumber': contactNumber,
      'CreatedAt': createdAt,
      'UpdatedAt': updatedAt,
    };
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