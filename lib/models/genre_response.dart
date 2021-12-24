import 'package:movie/models/genre.dart';

class GenreResponse
{
  List<Genre>? genre;
  String? error;

  GenreResponse(this.genre , this.error);

  GenreResponse.fromjson(Map<String , dynamic>json)
  {
    genre = (json['genres'] as List).map((e) => Genre.fromjson(e)).toList();
    error = "";
  }

  GenreResponse.withError(String errorValue)
  {
    genre = List as List<Genre>?;
    error = errorValue;
  }
}