import 'package:movie/models/movie.dart';

class MovieResponse
{
  List<MovieModel>? movies;
  String? error;

  MovieResponse(this.movies , this.error);

  MovieResponse.fromjson(Map<String , dynamic>json)
  {
    movies = (json['results'] as List).map((e) => MovieModel.fromjson(e)).toList();
    error = "";
  }

  MovieResponse.withError(String errorValue)
  {
    movies = null;
    error = errorValue;
  }
}