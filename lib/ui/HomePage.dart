import 'package:flutter/material.dart';
import 'package:movie/Constants.dart';
import 'package:movie/model/MovieResponse.dart';
import 'package:movie/ui/details/DetailsPage.dart';
import 'package:tmdb_api/tmdb_api.dart';

class HomePageApp extends StatelessWidget {
  const HomePageApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie App',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const MyHomePage(title: 'Movie App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({super.key, required this.title});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Movie>? popularMovies = [];

  @override
  void initState() {
    loadMovies();
    super.initState();
  }

  loadMovies() async {
    TMDB tmdb = TMDB(
      ApiKeys(Constants.dbApiKey, Constants.dbApiReadingAccessToken),
      logConfig: const ConfigLogger(
        showLogs: true,
        showErrorLogs: true,
      ),
    );
    var popularMoviesResult =
        await tmdb.v3.movies.getPopular() as Map<String, dynamic>;
    var movies = MovieResponse.fromJson(popularMoviesResult);
    popularMovies = movies.results;
  }

  String getImage(int index) {
    var posterPath = popularMovies?.elementAt(index).posterPath;
    return "https://image.tmdb.org/t/p/w500/$posterPath";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio: 2 / 3,
                crossAxisSpacing: 20,
                mainAxisSpacing: 0),
            itemCount: popularMovies?.length,
            itemBuilder: (_, index) {
              return InkWell(
                onTap: () {
                  openDetails(popularMovies?.elementAt(index).id);
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      image: NetworkImage(getImage(index)),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }

  void openDetails(int? movieId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            DetailsPage(detailsPageArguments: DetailsPageArguments(movieId)),
      ),
    );
  }
}
