class JobPostListResponse {
  final String? error;
  final List<JobPost> data;

  JobPostListResponse({this.error, required this.data});

  factory JobPostListResponse.fromJson(Map<String, dynamic> json) {
    return JobPostListResponse(
      error: json['error'] as String?,
      data: (json['data'] as List<dynamic>)
          .map((e) => JobPost.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'error': error, 'data': data.map((e) => e.toJson()).toList()};
  }
}

class JobPost {
  final String id;
  final String userId;
  final String jobTitle;
  final String companyName;
  final String jobDescription;
  final String jobApplyUrl;
  final String location;
  final DateTime postDate;
  final DateTime lastDateToApply;
  final DateTime createdAt;

  JobPost({
    required this.id,
    required this.userId,
    required this.jobTitle,
    required this.companyName,
    required this.jobDescription,
    required this.jobApplyUrl,
    required this.location,
    required this.postDate,
    required this.lastDateToApply,
    required this.createdAt,
  });

  factory JobPost.fromJson(Map<String, dynamic> json) {
    return JobPost(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      jobTitle: json['job_title'] as String,
      companyName: json['company_name'] as String,
      jobDescription: json['job_description'] as String,
      jobApplyUrl: json['job_apply_url'] as String,
      location: json['location'] as String,
      postDate: DateTime.parse(json['post_date'] as String),
      lastDateToApply: DateTime.parse(json['last_date_to_apply'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'job_title': jobTitle,
      'company_name': companyName,
      'job_description': jobDescription,
      'job_apply_url': jobApplyUrl,
      'location': location,
      'post_date': postDate.toIso8601String(),
      'last_date_to_apply': lastDateToApply.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }
}
