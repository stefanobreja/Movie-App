import 'package:movie/model/Movie.dart';

const String tableMovies = 'movies';

class MovieDbFields {
  static final List<String> values = [
    id,
    title,
    overview,
    releaseDate,
    posterPath,
    backdropPath,
    voteAverage,
    voteCount
  ];

  static const String id = "_id";
  static const String title = "title";
  static const String overview = "overview";
  static const String releaseDate = "releaseDate";
  static const String posterPath = "posterPath";
  static const String backdropPath = "backdropPath";
  static const String voteAverage = "voteAverage";
  static const String voteCount = "voteCount";
}

class MovieDb {
  final int? id;
  final String? title;
  final String? overview;
  final String? releaseDate;
  final String? posterPath;
  final String? backdropPath;
  final num? voteAverage;
  final int? voteCount;

  const MovieDb({
    required this.id,
    required this.releaseDate,
    required this.title,
    required this.voteAverage,
    required this.voteCount,
    required this.overview,
    required this.backdropPath,
    required this.posterPath,
  });

  Map<String, Object?> toJson() => {
        MovieDbFields.id: id,
        MovieDbFields.title: title,
        MovieDbFields.overview: overview,
        MovieDbFields.releaseDate: releaseDate,
        MovieDbFields.posterPath: posterPath,
        MovieDbFields.backdropPath: backdropPath,
        MovieDbFields.voteAverage: voteAverage,
        MovieDbFields.voteCount: voteCount,
      };

  MovieDb copy({
    int? id,
    String? title,
    String? overview,
    String? releaseDate,
    String? posterPath,
    String? backdropPath,
    num? voteAverage,
    int? voteCount,
  }) =>
      MovieDb(
        id: id ?? this.id,
        title: title ?? this.title,
        overview: overview ?? this.overview,
        releaseDate: releaseDate ?? this.releaseDate,
        posterPath: posterPath ?? this.posterPath,
        backdropPath: backdropPath ?? this.backdropPath,
        voteAverage: voteAverage ?? this.voteAverage,
        voteCount: voteCount ?? this.voteCount,
      );

  static MovieDb fromJson(Map<String, Object?> json) => MovieDb(
      id: json[MovieDbFields.id] as int?,
      releaseDate: json[MovieDbFields.releaseDate] as String?,
      title: json[MovieDbFields.title] as String?,
      voteAverage: json[MovieDbFields.voteAverage] as num?,
      voteCount: json[MovieDbFields.voteCount] as int?,
      overview: json[MovieDbFields.overview] as String?,
      backdropPath: json[MovieDbFields.backdropPath] as String?,
      posterPath: json[MovieDbFields.posterPath] as String?);

  static Movie toMovie(MovieDb movieDb) => Movie(
        id: movieDb.id,
        title: movieDb.title,
        overview: movieDb.overview,
        posterPath: movieDb.posterPath,
        backdropPath: movieDb.backdropPath,
        releaseDate: movieDb.releaseDate,
        voteAverage: movieDb.voteAverage,
        voteCount: movieDb.voteCount,
      );
}
