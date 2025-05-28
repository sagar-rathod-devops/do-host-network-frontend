class UserProfileModel {
  final String message;
  final Profile? profile;
  final String error;

  UserProfileModel({this.message = '', this.profile, this.error = ''});

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      message: json['message'] ?? '',
      profile: json['profile'] != null
          ? Profile.fromJson(json['profile'])
          : null,
      error: json['error'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'message': message, 'profile': profile?.toJson(), 'error': error};
  }
}

class Profile {
  final String id;
  final String userId;
  final String profileImage;
  final String fullName;
  final String designation;
  final String organization;
  final String professionalSummary;
  final String location;
  final String email;
  final String contactNumber;
  final String createdAt;
  final String updatedAt;

  Profile({
    this.id = '',
    this.userId = '',
    this.profileImage = '',
    this.fullName = '',
    this.designation = '',
    this.organization = '',
    this.professionalSummary = '',
    this.location = '',
    this.email = '',
    this.contactNumber = '',
    this.createdAt = '',
    this.updatedAt = '',
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['ID'] ?? '',
      userId: json['UserID'] ?? '',
      profileImage: json['ProfileImage'] ?? '',
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
