import 'package:trendveiw/API/api_function.dart';
import 'package:trendveiw/API/api_key.dart';
import 'package:trendveiw/model/movie_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// A class to handle all API calls related to movies
class ApiCall {
  // Base URLs with API key for different movie categories
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

  // Fetch trending movies from TMDB
  Future<List<Movie>> getTrendingMovies() async {
    return await apiFunction(_urlTrendingMovies);
  }

  // Fetch top-rated movies from TMDB
  Future<List<Movie>> getTopRatedMovies() async {
    return await apiFunction(_urlTopRatedMovies);
  }

  // Fetch upcoming movies from TMDB
  Future<List<Movie>> getUpcomingMovies() async {
    return await apiFunction(_urlUpcomingMovies);
  }

  // Fetch action movies (genreId: 28)
  Future<List<Movie>> getActionMovies() async {
    return await apiFunction("${_urlGenreMovies}28");
  }

  // Fetch comedy movies (genreId: 35)
  Future<List<Movie>> getComedyMovies() async {
    return await apiFunction("${_urlGenreMovies}35");
  }

  // Fetch horror movies (genreId: 27)
  Future<List<Movie>> getHorrorMovies() async {
    return await apiFunction("${_urlGenreMovies}27");
  }

  // Fetch sci-fi movies (genreId: 878)
  Future<List<Movie>> getSciFiMovies() async {
    return await apiFunction("${_urlGenreMovies}878");
  }

  // Fetch drama movies (genreId: 18)
  Future<List<Movie>> getDramaMovies() async {
    return await apiFunction("${_urlGenreMovies}18");
  }

  // Search for movies by a text query
  Future<List<Movie>> searchMovies(String query) async {
    String encodedQuery = Uri.encodeComponent(query);
    return await apiFunction(_urlSearchMovies + encodedQuery);
  }

  // Get the trailer video key for a specific movie by its ID
  Future<String> getMoviesVideo(int movieId) async {
    String urlMoviesVideo =
        "https://api.themoviedb.org/3/movie/$movieId/videos?api_key=${ApiKey.apiKey}";

    try {
      var response = await http.get(Uri.parse(urlMoviesVideo));

      if (response.statusCode == 200) {
        // Decode the JSON response
        var jsonResponse = (jsonDecode(response.body)['results'] as List);

        // Look for the first trailer video key
        return jsonResponse.map((movie) {
          if (movie["type"] == "Trailer") {
            // Return video key
            return movie["key"];
          }
        }).toString();
      }
      // Handle non-200 (unsuccessful) responses
      else {
        throw "Error in Getting Data";
      }
    }
    // Handle connection or parsing errors
    catch (e) {
      throw "Catch error: $e";
    }
  }
}
