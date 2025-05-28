class MovieListModel {
  int total;
  int page;
  int pages;
  List<TvShows> tvShow;

  MovieListModel({
    this.total = 0,
    this.page = 0,
    this.pages = 0,
    List<TvShows>? tvShow,
  }) : tvShow = tvShow ?? [];

  factory MovieListModel.fromJson(Map<String, dynamic> json) {
    return MovieListModel(
      total: json['total'] as int? ?? 0,
      page: json['page'] as int? ?? 0,
      pages: json['pages'] as int? ?? 0,
      tvShow:
          (json['tv_shows'] as List<dynamic>?)
              ?.map((e) => TvShows.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'page': page,
      'pages': pages,
      'tv_shows': tvShow.map((e) => e.toJson()).toList(),
    };
  }
}

class TvShows {
  String name;
  String permalink;
  String endDate;
  String network;
  String imageThumbnailPath;
  String status;

  TvShows({
    this.name = '',
    this.permalink = '',
    this.endDate = '',
    this.network = '',
    this.imageThumbnailPath = '',
    this.status = '',
  });

  factory TvShows.fromJson(Map<String, dynamic> json) {
    return TvShows(
      name: json['name'] as String? ?? '',
      permalink: json['permalink'] as String? ?? '',
      endDate: json['endDate'] as String? ?? '',
      network: json['network'] as String? ?? '',
      imageThumbnailPath: json['imageThumbnailPath'] as String? ?? '',
      status: json['status'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'permalink': permalink,
      'endDate': endDate,
      'network': network,
      'imageThumbnailPath': imageThumbnailPath,
      'status': status,
    };
  }
}
