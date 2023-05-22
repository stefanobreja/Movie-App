import 'package:movie/data/MovieDb.dart';

class Movie {
  Movie({
    required this.backdropPath,
    required this.id,
    required this.overview,
    required this.posterPath,
    required this.releaseDate,
    required this.title,
    required this.voteAverage,
    required this.voteCount,
  });

  late final String? backdropPath;
  late final int? id;
  late final String? overview;
  late final String? posterPath;
  late final String? releaseDate;
  late final String? title;
  late final num? voteAverage;
  late final int? voteCount;

  Movie.fromJson(Map<String, dynamic> json) {
    backdropPath = json['backdrop_path'];
    id = json['id'];
    overview = json['overview'];
    posterPath = json['poster_path'];
    releaseDate = json['release_date'];
    title = json['title'];
    voteAverage = json['vote_average'];
    voteCount = json['vote_count'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['backdrop_path'] = backdropPath;
    data['id'] = id;
    data['overview'] = overview;
    data['poster_path'] = posterPath;
    data['release_date'] = releaseDate;
    data['title'] = title;
    data['vote_average'] = voteAverage;
    data['vote_count'] = voteCount;
    return data;
  }

  static MovieDb toMovieDb(Movie movie) {
    return MovieDb(
        id: movie.id,
        releaseDate: movie.releaseDate,
        title: movie.title,
        voteAverage: movie.voteAverage,
        voteCount: movie.voteCount,
        overview: movie.overview,
        backdropPath: movie.backdropPath,
        posterPath: movie.posterPath);
  }
}
