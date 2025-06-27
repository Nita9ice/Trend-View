import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trendveiw/model/movie_model.dart';

// A reusable function to fetch movie data from a given API URL
Future<List<Movie>> apiFunction(url) async {
  try {
    // Make the HTTP GET request
    var response = await http.get(Uri.parse(url));

    // Check if the request was successful
    if (response.statusCode == 200) {
      // Decode the JSON response and get the 'results' list
      var jsonResponse = (jsonDecode(response.body)['results'] as List).where(
        // Filter out null entries
        (movie) => movie != null,
      );

      // Convert each JSON movie item to a Movie object
      return jsonResponse.map((movie) {
        /* print(movie); */
        return Movie.fromjson(movie);
      }).toList();
    } else {
      // If the response status code is not 200 i.e not successful, throw an error
      throw "Error in Getting Data";
    }
  }
  // Catch and throw any error that occurs during the request or parsing
  catch (e) {
    throw "Catch error: $e";
  }
}
