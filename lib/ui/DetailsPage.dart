import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie/Constants.dart';
import 'package:movie/model/Credits.dart';
import 'package:movie/model/Movie.dart';
import 'package:movie/ui/PersonDetailsPage.dart';
import 'package:tmdb_api/tmdb_api.dart';

import 'Utils.dart';

class DetailsPageArguments {
  final Movie? movie;

  DetailsPageArguments(this.movie);
}

class DetailsPage extends StatefulWidget {
  final DetailsPageArguments detailsPageArguments;

  const DetailsPage({super.key, required this.detailsPageArguments});

  @override
  State<StatefulWidget> createState() => _DetailsPage();
}

class _DetailsPage extends State<DetailsPage> {
  late Future<Credits?> credits;

  @override
  void initState() {
    credits = loadCast();
    super.initState();
  }

  Future<Credits?> loadCast() async {
    var movie = widget.detailsPageArguments.movie;
    var movieId = movie?.id;
    TMDB tmdb = TMDB(
      ApiKeys(Constants.dbApiKey, Constants.dbApiReadingAccessToken),
      logConfig: const ConfigLogger(
        showLogs: true,
        showErrorLogs: true,
      ),
    );

    if (movieId != null) {
      var creditsResponse = await tmdb.v3.movies.getCredits(movieId);
      var credits = Credits.fromJson(creditsResponse);
      return credits;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    var movie = widget.detailsPageArguments.movie;
    return MaterialApp(
      title: "Movie Details",
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      home: Scaffold(
        floatingActionButton: SizedBox(
          height: 70,
          width: 70,
          child: FloatingActionButton.small(
            onPressed: () {
              addToFavorites();
            },
            backgroundColor: Colors.blueGrey,
            child: const Icon(
              CupertinoIcons.heart_circle,
              size: 40,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: [image(movie?.backdropPath), detailsSection()],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget detailsSection() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          titleSection(),
        ],
      ),
    );
  }

  Widget titleSection() {
    var movie = widget.detailsPageArguments.movie;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            movie?.title ?? "No available title",
            style: const TextStyle(fontSize: 32, color: Colors.black),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                movie?.releaseDate ?? "",
                style: const TextStyle(fontSize: 16),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: Icon(
                  CupertinoIcons.star,
                  size: 20,
                ),
              ),
              voteAverage(),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            "Overview",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            movie?.overview ?? "",
            style: const TextStyle(wordSpacing: 1, fontSize: 16),
          ),
          const SizedBox(height: 12),
          actorsList(),
          directingList()
        ],
      ),
    );
  }

  Widget voteAverage() {
    var movie = widget.detailsPageArguments.movie;
    var voteAverage = movie?.voteAverage;
    var voteCount = movie?.voteCount;
    if (voteAverage != null) {
      return Text(
        "$voteAverage/10 ($voteCount votes)",
        style: const TextStyle(fontSize: 16),
      );
    } else {
      return const Text("");
    }
  }

  Widget actorsList() {
    return FutureBuilder<Credits?>(
      future: credits,
      builder: (context, credits) {
        var casts = credits.data?.cast;
        if (credits.hasData && casts?.isNotEmpty == true) {
          return Column(
            children: [
              Row(
                children: [
                  const Text(
                    "Cast members",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 10),
                  TextButton(
                      onPressed: () {
                        openPersonDetails(casts!);
                      },
                      child: const Text(
                        "see more",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blueAccent,
                        ),
                      ))
                ],
              ),
              SizedBox(
                height: 250,
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(0, 20, 12, 12),
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: casts?.length,
                  itemBuilder: (BuildContext context, int index) {
                    var cast = casts?.elementAt(index);
                    return Row(
                      children: [
                        actorItem(cast),
                        const SizedBox(width: 12),
                      ],
                    );
                  },
                ),
              ),
            ],
          );
        } else {
          return const Center(
              heightFactor: 25,
              widthFactor: 25,
              child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget directingList() {
    return FutureBuilder<Credits?>(
      future: credits,
      builder: (context, credits) {
        if (credits.hasData && credits.data?.cast.isNotEmpty == true) {
          var crews = credits.data?.crew
              .where((element) => element.department == "Production");
          return SizedBox(
            height: 250,
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(0, 20, 12, 12),
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: crews?.length,
              itemBuilder: (BuildContext context, int index) {
                var crew = crews?.elementAt(index);
                return Row(
                  children: [crewItem(crew), const SizedBox(width: 12)],
                );
              },
            ),
          );
        } else {
          return const Text("No cast members available");
        }
      },
    );
  }

  Widget actorItem(Cast? cast) {
    return Column(
      children: [
        Container(
            alignment: Alignment.center,
            width: 100,
            height: 150,
            child: image(cast?.profilePath)),
        const SizedBox(height: 8),
        Text(
          cast?.name ?? "",
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          cast?.character ?? "",
          style: const TextStyle(fontSize: 14),
        )
      ],
    );
  }

  Widget crewItem(Crew? crew) {
    return Column(
      children: [
        Container(
            alignment: Alignment.center,
            width: 100,
            height: 150,
            child: image(crew?.profilePath)),
        const SizedBox(height: 8),
        Text(
          crew?.name ?? "",
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          crew?.job ?? "",
          style: const TextStyle(fontSize: 14),
        )
      ],
    );
  }

  addToFavorites() async {}

  void openPersonDetails(List<Cast> casts) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PersonsDetailsPage(casts: casts)));
  }
}
