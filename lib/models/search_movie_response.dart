import 'package:movie/models/search_movie.dart';

class SearchResponse
{
  List<SearchMovie>? searchs;
  String? error;

  SearchResponse(this.error , this.searchs);

  SearchResponse.fromjson(Map<String , dynamic> json)
  {
    searchs = (json['results'] as List).map((e) => SearchMovie.fromjson(e)).toList();
  }

  SearchResponse.withError(String errorValue)
  {
    searchs = null;
    error = errorValue;
  }
}