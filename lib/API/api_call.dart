import 'package:trendveiw/API/api_function.dart';
import 'package:trendveiw/API/api_key.dart';
import 'package:trendveiw/model/movie_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiCall {
  static const _urlTrendingMovies =
      "https://api.themoviedb.org/3/trending/movie/day?api_key=${ApiKey.apiKey}";
  static const _urlTopRatedMovies =
      "https://api.themoviedb.org/3/movie/top_rated?api_key=${ApiKey.apiKey}";
  static const _urlUpcomingMovies =
      "https://api.themoviedb.org/3/movie/upcoming?api_key=${ApiKey.apiKey}";
  static const _urlGenreMovies =
      "https://api.themoviedb.org/3/discover/movie?api_key=${ApiKey.apiKey}&with_genres=";
  static const _urlSearchMovies =
      "https://api.themoviedb.org/3/search/movie?api_key=${ApiKey.apiKey}&query=";

  Future<List<Movie>> getTrendingMovies() async {
    return await apiFunction(_urlTrendingMovies);
  }

  Future<List<Movie>> getTopRatedMovies() async {
    return await apiFunction(_urlTopRatedMovies);
  }

  Future<List<Movie>> getUpcomingMovies() async {
    return await apiFunction(_urlUpcomingMovies);
  }

  Future<List<Movie>> getActionMovies() async {
    return await apiFunction("${_urlGenreMovies}28");
  }

  Future<List<Movie>> getComedyMovies() async {
    return await apiFunction("${_urlGenreMovies}35");
  }

  Future<List<Movie>> getHorrorMovies() async {
    return await apiFunction("${_urlGenreMovies}27");
  }

  Future<List<Movie>> getSciFiMovies() async {
    return await apiFunction("${_urlGenreMovies}878");
  }

  Future<List<Movie>> getDramaMovies() async {
    return await apiFunction("${_urlGenreMovies}18");
  }

  Future<List<Movie>> searchMovies(String query) async {
    String encodedQuery = Uri.encodeComponent(query);
    return await apiFunction(_urlSearchMovies + encodedQuery);
  }

  Future<String> getMoviesVideo(int movieId) async {
    String _urlMoviesVideo =
        "https://api.themoviedb.org/3/movie/$movieId/videos?api_key=${ApiKey.apiKey}";

    try {
      var response = await http.get(Uri.parse(_urlMoviesVideo));

      if (response.statusCode == 200) {
        var jsonResponse = (jsonDecode(response.body)['results'] as List);

        print(jsonResponse);
        // Ensure 'results' exists and is a List

        return jsonResponse.map((movie) {
          /* print(movie); */

          if (movie["type"] == "Trailer") {
            /* print("Movie key is: ${movie["key"]}"); */
            return movie["key"];
          }
        }).toString();
      } else {
        throw "Error in Getting Data";
      }
    } catch (e) {
      throw "Catch error: $e";
    }
  }
}
