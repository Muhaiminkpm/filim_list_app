import 'package:filim_list_app/model/model_movie.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

Future<Movies> fetchMovie() async {
  final response = await http
      .get(Uri.parse('https://api.themoviedb.org/3/movie/popular?api_key=aa9e658153ebd3bf6fdbddce1e9b8dc8'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Movies.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}
