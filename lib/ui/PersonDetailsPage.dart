import 'dart:core';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie/Constants.dart';
import 'package:movie/model/Credits.dart';
import 'package:movie/model/PersonDetails.dart';
import 'package:movie/model/PersonMovieCredits.dart';
import 'package:tmdb_api/tmdb_api.dart';

import 'Utils.dart';

class UiPerson {
  final PersonDetails? personDetails;
  final List<CastMovieCredits>? castMovieCredits;

  UiPerson(this.personDetails, this.castMovieCredits);
}

class PersonsDetailsPage extends StatefulWidget {
  final List<Cast> casts;

  const PersonsDetailsPage({super.key, required this.casts});

  @override
  State<StatefulWidget> createState() => _PersonDetailsPage();
}

class _PersonDetailsPage extends State<PersonsDetailsPage> {
  late final Future<List<UiPerson>> personsDetails;
  UiPerson? selectedPerson;

  @override
  void initState() {
    personsDetails = loadPersonsDetails(widget.casts);
    super.initState();
  }

  Future<List<UiPerson>> loadPersonsDetails(List<Cast> casts) async {
    List<UiPerson> persons = [];
    TMDB tmdb = TMDB(
      ApiKeys(Constants.dbApiKey, Constants.dbApiReadingAccessToken),
      logConfig: const ConfigLogger(
        showLogs: true,
        showErrorLogs: true,
      ),
    );

    for (var person in casts) {
      var personResponse = await tmdb.v3.people.getDetails(person.id);
      var knownForResponse = await tmdb.v3.people.getMovieCredits(person.id);
      var personDetails = PersonDetails.fromJson(personResponse);
      var knownFor = PersonMovieCredits.fromJson(knownForResponse);
      persons.add(UiPerson(personDetails, knownFor.cast));
      setState(() {
        selectedPerson = persons.elementAt(0);
      });
    }
    return persons;
  }

  void addToFavorites() async {}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Movie Details",
        theme: ThemeData(primarySwatch: Colors.blueGrey),
        home: Scaffold(
          body: SingleChildScrollView(
            child: FutureBuilder<List<UiPerson>>(
              future: personsDetails,
              builder: (context, persons) {
                if (persons.hasData && persons.data != null) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      carouselPerson(persons.data),
                      personData(selectedPerson)
                    ],
                  );
                } else {
                  return const Center(
                      heightFactor: 25,
                      widthFactor: 25,
                      child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ));
  }

  Widget carouselPerson(List<UiPerson>? persons) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 450.0,
        onPageChanged: (index, reason) {
          loadNewPersonData(persons?.elementAt(index));
        },
      ),
      items: persons?.map((p) {
        return Builder(
          builder: (BuildContext context) {
            return SizedBox(
                width: MediaQuery.of(context).size.width,
                child: image(p.personDetails?.profilePath));
          },
        );
      }).toList(),
    );
  }

  Widget personData(UiPerson? persons) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          Text(
            selectedPerson?.personDetails?.name ?? "",
            style: const TextStyle(fontSize: 32, color: Colors.black),
          ),
          const SizedBox(height: 10),
          getLifeYears(),
          const SizedBox(height: 10),
          const Text(
            "Biography:",
            style: TextStyle(fontSize: 24),
          ),
          const SizedBox(height: 10),
          Text(
            selectedPerson?.personDetails?.biography ?? "",
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 10),
          const Text(
            "Known for:",
            style: TextStyle(fontSize: 24),
          ),
          const SizedBox(height: 10),
          listKnownMovies(persons)
        ],
      ),
    );
  }

  Widget listKnownMovies(UiPerson? personsDetails) {
    var castMovieCredits = personsDetails?.castMovieCredits;
    return SizedBox(
      height: 300,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: castMovieCredits?.length,
          itemBuilder: (context, index) {
            return Row(
              children: [
                itemKnownMovies(castMovieCredits?.elementAt(index)),
                const SizedBox(
                  width: 10,
                )
              ],
            );
          }),
    );
  }

  Widget itemKnownMovies(CastMovieCredits? castMovieCredits) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
              width: 130,
              height: 230,
              child: image(castMovieCredits?.posterPath)),
          SizedBox(
              width: 130,
              child: Text(
                castMovieCredits?.title ?? "",
              ))
        ],
      ),
    );
  }

  void loadNewPersonData(UiPerson? person) {
    setState(() {
      selectedPerson = person;
    });
  }

  Widget getLifeYears() {
    var personDetails = selectedPerson?.personDetails;
    String? years;
    if (personDetails?.deathday?.isNotEmpty == true) {
      years = "${personDetails?.birthday} - ${personDetails?.deathday}";
    } else {
      years = personDetails?.birthday;
    }
    ;
    return Text(
      years ?? "",
      style: const TextStyle(fontSize: 16, color: Colors.black),
    );
  }
}
