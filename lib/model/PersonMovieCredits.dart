class PersonMovieCredits {
  PersonMovieCredits({
    required this.cast,
    required this.crew,
    required this.id,
  });

  late final List<CastMovieCredits> cast;
  late final List<Crew> crew;
  late final int id;

  PersonMovieCredits.fromJson(Map<dynamic, dynamic> json) {
    cast = List.from(json['cast']).map((e) => CastMovieCredits.fromJson(e)).toList();
    crew = List.from(json['crew']).map((e) => Crew.fromJson(e)).toList();
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['cast'] = cast.map((e) => e.toJson()).toList();
    _data['crew'] = crew.map((e) => e.toJson()).toList();
    _data['id'] = id;
    return _data;
  }
}

class CastMovieCredits {
  CastMovieCredits({
    required this.adult,
    this.backdropPath,
    required this.genreIds,
    required this.id,
    required this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    required this.popularity,
    this.posterPath,
    required this.releaseDate,
    required this.title,
    required this.video,
    required this.voteAverage,
    required this.voteCount,
    required this.character,
    required this.creditId,
    required this.order,
  });

  late final bool adult;
  late final String? backdropPath;
  late final List<int> genreIds;
  late final int id;
  late final String originalLanguage;
  late final String originalTitle;
  late final String overview;
  late final double popularity;
  late final String? posterPath;
  late final String releaseDate;
  late final String title;
  late final bool video;
  late final double? voteAverage;
  late final int voteCount;
  late final String character;
  late final String creditId;
  late final int order;

  CastMovieCredits.fromJson(Map<String, dynamic> json) {
    adult = json['adult'];
    backdropPath = json['backdrop_Path'];
    genreIds = List.castFrom<dynamic, int>(json['genre_ids']);
    id = json['id'];
    originalLanguage = json['original_language'];
    originalTitle = json['original_title'];
    overview = json['overview'];
    popularity = json['popularity'];
    posterPath = json['poster_path'];
    releaseDate = json['release_date'];
    title = json['title'];
    video = json['video'];
    voteAverage = json['vote_average'];
    voteCount = json['vote_count'];
    character = json['character'];
    creditId = json['credit_id'];
    order = json['order'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['adult'] = adult;
    _data['backdrop_path'] = backdropPath;
    _data['genre_ids'] = genreIds;
    _data['id'] = id;
    _data['original_language'] = originalLanguage;
    _data['original_title'] = originalTitle;
    _data['overview'] = overview;
    _data['popularity'] = popularity;
    _data['poster_path'] = posterPath;
    _data['release_date'] = releaseDate;
    _data['title'] = title;
    _data['video'] = video;
    _data['vote_average'] = voteAverage;
    _data['vote_count'] = voteCount;
    _data['character'] = character;
    _data['credit_id'] = creditId;
    _data['order'] = order;
    return _data;
  }
}

class Crew {
  Crew({
    required this.adult,
    this.backdropPath,
    required this.genreIds,
    required this.id,
    required this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.releaseDate,
    required this.title,
    required this.video,
    required this.voteAverage,
    required this.voteCount,
    required this.creditId,
    required this.department,
    required this.job,
  });

  late final bool adult;
  late final String? backdropPath;
  late final List<int> genreIds;
  late final int id;
  late final String originalLanguage;
  late final String originalTitle;
  late final String overview;
  late final double popularity;
  late final String? posterPath;
  late final String releaseDate;
  late final String title;
  late final bool video;
  late final double voteAverage;
  late final int voteCount;
  late final String creditId;
  late final String department;
  late final String job;

  Crew.fromJson(Map<String, dynamic> json) {
    adult = json['adult'];
    backdropPath = null;
    genreIds = List.castFrom<dynamic, int>(json['genre_ids']);
    id = json['id'];
    originalLanguage = json['original_language'];
    originalTitle = json['original_title'];
    overview = json['overview'];
    popularity = json['popularity'];
    posterPath = json['poster_path'];
    releaseDate = json['release_date'];
    title = json['title'];
    video = json['video'];
    voteAverage = json['vote_average'];
    voteCount = json['vote_count'];
    creditId = json['credit_id'];
    department = json['department'];
    job = json['job'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['adult'] = adult;
    _data['backdrop_path'] = backdropPath;
    _data['genre_ids'] = genreIds;
    _data['id'] = id;
    _data['original_language'] = originalLanguage;
    _data['original_title'] = originalTitle;
    _data['overview'] = overview;
    _data['popularity'] = popularity;
    _data['poster_path'] = posterPath;
    _data['release_date'] = releaseDate;
    _data['title'] = title;
    _data['video'] = video;
    _data['vote_average'] = voteAverage;
    _data['vote_count'] = voteCount;
    _data['credit_id'] = creditId;
    _data['department'] = department;
    _data['job'] = job;
    return _data;
  }
}
