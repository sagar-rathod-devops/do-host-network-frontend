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

  factory UserProfileResponse.fromJson(Map<String, dynamic> json) {
    return UserProfileResponse(
      id:
          json['id']
              as String?, // <-- Lowercase keys for JSON snake_case or camelCase
      userId: json['user_id'] as String?,
      profileImage: json['profile_image'] as String?,
      fullName: json['full_name'] as String?,
      designation: json['designation'] as String?,
      organization: json['organization'] as String?,
      professionalSummary: json['professional_summary'] as String?,
      location: json['location'] as String?,
      email: json['email'] as String?,
      contactNumber: json['contact_number'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'profile_image': profileImage,
      'full_name': fullName,
      'designation': designation,
      'organization': organization,
      'professional_summary': professionalSummary,
      'location': location,
      'email': email,
      'contact_number': contactNumber,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'UserProfileResponse(userId: $userId, fullName: $fullName, email: $email)';
  }
}
