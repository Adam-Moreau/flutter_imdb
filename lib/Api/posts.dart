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
      Uri.parse(
          'https://online-movie-database.p.rapidapi.com/title/get-most-popular-movies'),
      headers: {
        'x-rapidapi-host': 'online-movie-database.p.rapidapi.com',
        'x-rapidapi-key': '9bfe46c7bcmsh8e4c93d7469b889p19a7b0jsn4f5ba4db7514',
      },
    );
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);

      //  postList = responseData ;
      for (int i = 0; i < 6; i++) {
        reponseDataFilm =
            responseData[i].substring(responseData[i].indexOf('tt'));
        String? urlFilm =
            'https://online-movie-database.p.rapidapi.com/title/get-details/?tconst=$reponseDataFilm';
        final responseFilm = await http.get(
          Uri.parse(urlFilm),
          headers: {
            'x-rapidapi-host': 'online-movie-database.p.rapidapi.com',
            'x-rapidapi-key':
                '9bfe46c7bcmsh8e4c93d7469b889p19a7b0jsn4f5ba4db7514',
          },
        );
        if (responseFilm.statusCode == 200) {
          final responseDataFilm = json.decode(responseFilm.body);
          postList.add(PostsModel.fromJson(responseDataFilm));
        } else {
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
        toolbarHeight: 75,
        title: const Text('Rivendell Theater'),
        actions: [
          IconButton(
            onPressed: () {
              // method to show the search bar
              showSearch(
                context: context,
                // delegate to customize the search bar
                delegate: CustomSearchDelegate(),
              );
            },
            icon: const Icon(Icons.search),
          )
        ],
      ),
      body: FutureBuilder(
        future: fetchMostPopularMovies(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.6,
              ),
              shrinkWrap: true,
              itemCount: postList.length,
              itemBuilder: (context, index) {
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20)),
                          child: Image.network(
                            postList[index].imageUrl!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          postList[index].title.toString(),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
