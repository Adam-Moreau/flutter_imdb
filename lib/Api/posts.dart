// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:api_test_1/Models/search.dart';
import 'package:api_test_1/Models/posts_model.dart';
import 'package:http/http.dart' as http;

class PostsApi extends StatelessWidget {
  PostsApi({Key? key}) : super(key: key);

  List<PostsModel> postList = [];
  String? reponseDataFilm = '';

  Future<List<dynamic>> fetchMostPopularMovies() async {
    final response = await http.get(
      Uri.parse('https://imdb8.p.rapidapi.com/title/get-most-popular-movies'),
      headers: {
        'x-rapidapi-host': 'imdb8.p.rapidapi.com',
        'x-rapidapi-key': '9c05144f40msh34ebc8521e20e9fp12fe60jsn1825707fbfcd',
      },
    );
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);

      //  postList = responseData ;
      for (int i = 0; i < 2; i++) {
        reponseDataFilm = responseData[i].substring(responseData[i].indexOf('tt'));
        String? urlFilm = 'https://imdb8.p.rapidapi.com/title/get-details/?tconst=$reponseDataFilm' ;
        final responseFilm = await http.get(
          Uri.parse(
              urlFilm),
          headers: {
            'x-rapidapi-host': 'imdb8.p.rapidapi.com',
            'x-rapidapi-key': '9c05144f40msh34ebc8521e20e9fp12fe60jsn1825707fbfcd',
          },
        );
        if (responseFilm.statusCode == 200) {
          final responseDataFilm = json.decode(responseFilm.body);
          postList.add(PostsModel.fromJson(responseDataFilm));

        }else{
          print(responseFilm);
        }
      }
      return postList;
    } else {
      throw Exception('Failed to load most popular movies');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Api Course'),
        actions: [
          IconButton(
            onPressed: () {
              // method to show the search bar
              showSearch(
                context: context,
                // delegate to customize the search bar
                delegate: CustomSearchDelegate()
              );
            },
            icon: const Icon(Icons.search),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: fetchMostPopularMovies(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Text('Loading');
                } else {
                  return ListView.builder(
                      itemCount: postList.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Title',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  postList[index].title.toString(),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Image.network(postList[index].imageUrl!,)
                              ],
                            ),
                          ),
                        );
                      });
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
