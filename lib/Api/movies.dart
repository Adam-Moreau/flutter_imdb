import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:api_test_1/Models/movies_model.dart';
import 'package:api_test_1/details.dart';
import 'package:http/http.dart' as http;

class PostsApi extends StatelessWidget {
  PostsApi({Key? key}) : super(key: key);

  List<MoviesModel> movieList = [];
  String? reponseDataFilm = '';
  String? apiHost = 'online-movie-database.p.rapidapi.com';
  String? apiKey = '62d306f517msh6430c48f1c40770p154cefjsne1fb71202430';

  Future<List<dynamic>> fetchMostPopularMovies() async {
    final response = await http.get(
      Uri.parse('https://$apiHost/title/get-most-popular-movies'),
      headers: {
        'x-rapidapi-host': '$apiHost',
        'x-rapidapi-key': '$apiKey',
      },
    );
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);

      //  movieList = responseData ;
      for (int i = 0; i < 12; i++) {
        reponseDataFilm =
            responseData[i].substring(responseData[i].indexOf('tt'));
        String? urlFilm =
            'https://$apiHost/title/get-details/?tconst=$reponseDataFilm';
        final responseFilm = await http.get(
          Uri.parse(urlFilm),
          headers: {
            'x-rapidapi-host': '$apiHost',
            'x-rapidapi-key': '$apiKey',
          },
        );
        if (responseFilm.statusCode == 200) {
          final responseDataFilm = json.decode(responseFilm.body);
          movieList.add(MoviesModel.fromJson(responseDataFilm));
        } else {
          print(responseFilm);
        }
      }
      return movieList;
    } else {
      throw Exception('Failed to load most popular movies');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 120,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Rivendell Theater',
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Most Popular Movies',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
      body: FutureBuilder(
        future: fetchMostPopularMovies(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 0.6,
              ),
              shrinkWrap: true,
              itemCount: movieList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailsPage(
                          movie: movieList[index],
                          title: movieList[index].title,
                          imageUrl: movieList[index].imageUrl,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 8,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                            child: Image.network(
                              movieList[index].imageUrl!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            movieList[index].title.toString(),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.brown,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
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
