import 'package:flutter/material.dart';
import 'package:movie/Constants.dart';
import 'package:movie/model/MovieResponse.dart';
import 'package:tmdb_api/tmdb_api.dart';

class DetailsPageArguments {
  final int? movieId;

  DetailsPageArguments(this.movieId);
}

class DetailsPage extends StatefulWidget {
  final DetailsPageArguments? detailsPageArguments;

  const DetailsPage({super.key, this.detailsPageArguments});

  @override
  State<StatefulWidget> createState() => _DetailsPage();
}

class _DetailsPage extends State<DetailsPage> {
  late Movie movieDetails;
  late String image;

  @override
  void initState() {
    getMovieDetails(widget.detailsPageArguments?.movieId);
    super.initState();
  }

  getMovieDetails(movieId) async {
    TMDB tmdb = TMDB(
      ApiKeys(Constants.dbApiKey, Constants.dbApiReadingAccessToken),
      logConfig: const ConfigLogger(
        showLogs: true,
        showErrorLogs: true,
      ),
    );
    if (movieId != null) {
      var movieDetailsResponse =
          await tmdb.v3.movies.getDetails(movieId) as Map<String, dynamic>;
      var movie = Movie.fromJson(movieDetailsResponse);
      var imageResponse = tmdb.images.getUrl(movie.posterPath);
      setState(() {
        movieDetails = movie;
        image = imageResponse ?? "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Movie Details",
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      home: Scaffold(
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: NetworkImage(image),
                    fit: BoxFit.cover,
                  )),
                )
              ],
            )),
      ),
    );
  }
}
