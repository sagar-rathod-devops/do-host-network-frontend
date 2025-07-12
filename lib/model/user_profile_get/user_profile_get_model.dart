class UserProfileResponse {
  final String? id;
  final String? userId;
  final String? profileImage;
  final String? fullName;
  final String? designation;
  final String? organization;
  final String? professionalSummary;
  final String? location;
  final String? email;
  final String? contactNumber;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserProfileResponse({
    this.id,
    this.userId,
    this.profileImage,
    this.fullName,
    this.designation,
    this.organization,
    this.professionalSummary,
    this.location,
    this.email,
    this.contactNumber,
    this.createdAt,
    this.updatedAt,
  });

  /// ✅ Corrected mapping with backend capitalized JSON keys
  factory UserProfileResponse.fromJson(Map<String, dynamic> json) {
    return UserProfileResponse(
      id: json['ID'] as String?,
      userId: json['UserID'] as String?,
      profileImage: json['ProfileImage'] as String?,
      fullName: json['FullName'] as String?,
      designation: json['Designation'] as String?,
      organization: json['Organization'] as String?,
      professionalSummary: json['ProfessionalSummary'] as String?,
      location: json['Location'] as String?,
      email: json['Email'] as String?,
      contactNumber: json['ContactNumber'] as String?,
      createdAt: json['CreatedAt'] != null
          ? DateTime.tryParse(json['CreatedAt'])
          : null,
      updatedAt: json['UpdatedAt'] != null
          ? DateTime.tryParse(json['UpdatedAt'])
          : null,
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
      'CreatedAt': createdAt?.toIso8601String(),
      'UpdatedAt': updatedAt?.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'UserProfileResponse(userId: $userId, fullName: $fullName, email: $email)';
  }
}
