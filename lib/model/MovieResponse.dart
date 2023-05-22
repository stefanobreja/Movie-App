import 'Movie.dart';

class MovieResponse {
  MovieResponse({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  late final int? page;
  late final List<Movie>? results;
  late final int? totalPages;
  late final int? totalResults;

  MovieResponse.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    results =
        List.from(json['results']).map((e) => Movie.fromJson(e)).toList();
    totalPages = json['total_pages'];
    totalResults = json['total_results'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['page'] = page;
    data['results'] = results?.map((e) => e.toJson()).toList();
    data['total_pages'] = totalPages;
    data['total_results'] = totalResults;
    return data;
  }
}