import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:trendveiw/model/movie_model.dart';


Future<List<Movie>> apiFunction(url) async {
   try{
   var response = await http.get(Uri.parse(url));
   
   if(response.statusCode== 200){
     
     
    var jsonResponse = jsonDecode(response.body)['results'] as List;
           
           /* print(jsonResponse); */
    return jsonResponse.map((movie)=> Movie.fromjson(movie)).toList();
   
   }else{
   throw "Error in Getting Data";
   
   }
   
   }catch(e){
   
   
   throw "Catch error: $e";
   
   
   }
 }