class UserEducationListResponse {
  final String? error;
  final List<UserEducation> data;

  UserEducationListResponse({this.error, required this.data});

  factory UserEducationListResponse.fromJson(Map<String, dynamic> json) {
    return UserEducationListResponse(
      error: json['error'] as String?,
      data: (json['data'] as List<dynamic>)
          .map((e) => UserEducation.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'error': error, 'data': data.map((e) => e.toJson()).toList()};
  }
}

class UserEducation {
  final String id;
  final String userId;
  final String degree;
  final String institutionName;
  final String fieldOfStudy;
  final String grade;
  final String year;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserEducation({
    required this.id,
    required this.userId,
    required this.degree,
    required this.institutionName,
    required this.fieldOfStudy,
    required this.grade,
    required this.year,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserEducation.fromJson(Map<String, dynamic> json) {
    return UserEducation(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      degree: json['degree'] as String,
      institutionName: json['institution_name'] as String,
      fieldOfStudy: json['field_of_study'] as String,
      grade: json['grade'] as String,
      year: json['year'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'degree': degree,
      'institution_name': institutionName,
      'field_of_study': fieldOfStudy,
      'grade': grade,
      'year': year,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
