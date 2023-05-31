import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie/Constants.dart';
import 'package:movie/data/MovieDb.dart';
import 'package:movie/data/MoviesDb.dart';
import 'package:movie/model/Movie.dart';
import 'package:movie/model/MovieResponse.dart';
import 'package:movie/ui/DetailsPage.dart';
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
  int _selectedIndex = 0;
  int _page = 1;

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
    var popularMoviesResultPage2 =
        await tmdb.v3.movies.getPopular(page: 2) as Map<String, dynamic>;
    var popularMoviesResultPage3 =
        await tmdb.v3.movies.getPopular(page: 3) as Map<String, dynamic>;

    var movies = MovieResponse.fromJson(popularMoviesResult);
    var movies2 = MovieResponse.fromJson(popularMoviesResultPage2);
    var movies3 = MovieResponse.fromJson(popularMoviesResultPage3);
    var allMovies = movies.results;
    if (movies2.results != null) {
      allMovies?.addAll(movies2.results as Iterable<Movie>);
    }
    if (movies3.results != null) {
      allMovies?.addAll(movies3.results as Iterable<Movie>);
    }
    setState(() {
      popularMovies = allMovies;
    });
  }

  loadMoreMovies() async {
    _page += 1;
    TMDB tmdb = TMDB(
      ApiKeys(Constants.dbApiKey, Constants.dbApiReadingAccessToken),
      logConfig: const ConfigLogger(
        showLogs: true,
        showErrorLogs: true,
      ),
    );
    var popularMoviesResult =
        await tmdb.v3.movies.getPopular(page: _page) as Map<String, dynamic>;
    var movies = MovieResponse.fromJson(popularMoviesResult);
    setState(() {
      if (movies.results != null) {
        popularMovies?.addAll(movies.results!);
      }
    });
  }

  getMoviesFromDatabase() async {
    var movies = await MoviesDb.instance.getMovies();
    setState(() {
      popularMovies = movies.map((movie) => MovieDb.toMovie(movie)).toList();
    });
  }

  String getImage(int index) {
    var posterPath = popularMovies?.elementAt(index).posterPath;
    return "https://image.tmdb.org/t/p/w500/$posterPath";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.star), label: "Favorites")
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 2 / 3,
              crossAxisSpacing: 20,
              mainAxisSpacing: 0,
            ),
            itemCount: popularMovies?.length,
            itemBuilder: (_, index) {
              var movie = popularMovies?.elementAt(index);
              if (index < popularMovies!.length) {
                return InkWell(
                  onTap: () {
                    openDetails(movie);
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
              } else {
                loadMoreMovies();
                return const CircularProgressIndicator();
              }
            }),
      ),
    );
  }

  Widget movieCard(index) {
    return Container(
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
    );
  }

  void openDetails(Movie? movie) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            DetailsPage(detailsPageArguments: DetailsPageArguments(movie)),
      ),
    );
  }

  void _onItemTapped(int value) {
    setState(() {
      _selectedIndex = value;
      popularMovies?.clear();
    });
    if (_selectedIndex == 0) {
      loadMovies();
    }
    if (_selectedIndex == 1) {
      getMoviesFromDatabase();
    }
  }
}
