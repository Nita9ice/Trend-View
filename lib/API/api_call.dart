
import 'package:trendveiw/API/api_function.dart';
import 'package:trendveiw/API/api_key.dart';
import 'package:trendveiw/model/movie_model.dart';

class ApiCall {
static const _urlTrendingMovies= "https://api.themoviedb.org/3/trending/movie/day?api_key=${ApiKey.apiKey}";
static const _urlTopRatedMovies= "https://api.themoviedb.org/3/movie/top_rated?api_key=${ApiKey.apiKey}";
static const _urlUpcomingMovies= "https://api.themoviedb.org/3/movie/upcoming?api_key=${ApiKey.apiKey}";
static const _urlGenreMovies= "https://api.themoviedb.org/3/discover/movie?api_key=${ApiKey.apiKey}&with_genres=";

 Future<List<Movie>>  getTrendingMovies() async{

return await apiFunction(_urlTrendingMovies);
 }
 Future<List<Movie>>  getTopRatedMovies() async{

return await apiFunction(_urlTopRatedMovies);
 }
 Future<List<Movie>>  getUpcomingMovies() async{

return await apiFunction(_urlUpcomingMovies);
 }
 Future<List<Movie>>  getActionMovies() async{

return await apiFunction("${_urlGenreMovies}28");
 }
 Future<List<Movie>>  getComedyMovies() async{

return await apiFunction("${_urlGenreMovies}35");
 }

 Future<List<Movie>>  getHorrorMovies() async{

return await apiFunction("${_urlGenreMovies}27");
 }
 Future<List<Movie>>  getSciFiMovies() async{

return await apiFunction("${_urlGenreMovies}878");
 }

 Future<List<Movie>>  getDramaMovies() async{

return await apiFunction("${_urlGenreMovies}18");
 }

 



}