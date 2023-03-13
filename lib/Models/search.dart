import 'package:api_test_1/Models/search_model.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:api_test_1/Models/posts_model.dart';

class CustomSearchDelegate extends SearchDelegate {
  // Demo list to show querying

  List<SearchModel> searchTerms = [];

  Future<List<dynamic>> fetchMovies() async {
    var reponseDataFilm = query;
    int limit = 20;

    String? urlFilm =
        'https://imdb8.p.rapidapi.com/title/v2/find?title=$reponseDataFilm&$limit';
    final responseFilm = await http.get(
      Uri.parse(urlFilm),
      headers: {
        'x-rapidapi-host': 'imdb8.p.rapidapi.com',
        'x-rapidapi-key': '9c05144f40msh34ebc8521e20e9fp12fe60jsn1825707fbfcd',
      },
    );

    if (responseFilm.statusCode == 200) {
      final responseDataFilm = json.decode(responseFilm.body);
      searchTerms.add(SearchModel.fromJson(responseDataFilm));
      print(searchTerms);
    } else {}
    return searchTerms;
  }

  // first overwrite to
  // clear the search text
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.clear),
      ),
    ];
  }

  // second overwrite to pop out of search menu
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  // third overwrite to show query result
  @override
  Widget buildResults(BuildContext context) {
    List<SearchModel> matchQuery = [];
    for (var movie in searchTerms) {
      if (movie.toString().toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(movie);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(searchTerms[index].title.toString()),
        );
      },
    );
  }

  // last overwrite to show the
  // querying process at the runtime
  @override
  Widget buildSuggestions(BuildContext context) {
    List<SearchModel> matchQuery = [];
    for (var movie in searchTerms) {
      if (movie.toString().toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(movie);
      }
    }
    return Scaffold(
        body: Column(
      children: [
        Expanded(
          child: FutureBuilder(
            future: fetchMovies(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Text('Loading');
              } else {
                return ListView.builder(
                  itemCount: matchQuery.length,
                  itemBuilder: (context, index) {
                    var result = matchQuery[index];
                    return ListTile(
                      title: Text(result.title.toString()),
                    );
                  },
                );
              }
            },
          ),
        )
      ],
    ));
  }
}
