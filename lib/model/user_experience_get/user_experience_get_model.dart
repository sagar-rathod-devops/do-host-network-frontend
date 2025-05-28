class UserExperienceListResponse {
  final String? error;
  final List<UserExperience> data;

  UserExperienceListResponse({this.error, required this.data});

  factory UserExperienceListResponse.fromJson(Map<String, dynamic> json) {
    return UserExperienceListResponse(
      error: json['error'] as String?,
      data: (json['data'] as List<dynamic>)
          .map((e) => UserExperience.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'error': error, 'data': data.map((e) => e.toJson()).toList()};
  }
}

class UserExperience {
  final String id;
  final String userId;
  final String jobTitle;
  final String companyName;
  final String location;
  final String jobDescription;
  final String achievements;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserExperience({
    required this.id,
    required this.userId,
    required this.jobTitle,
    required this.companyName,
    required this.location,
    required this.jobDescription,
    required this.achievements,
    required this.startDate,
    required this.endDate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserExperience.fromJson(Map<String, dynamic> json) {
    return UserExperience(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      jobTitle: json['job_title'] as String,
      companyName: json['company_name'] as String,
      location: json['location'] as String,
      jobDescription: json['job_description'] as String,
      achievements: json['achievements'] as String,
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: DateTime.parse(json['end_date'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'job_title': jobTitle,
      'company_name': companyName,
      'location': location,
      'job_description': jobDescription,
      'achievements': achievements,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
