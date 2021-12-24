import 'package:movie/models/movie_detail.dart';

class MovieDetailsResponse
{
  MovieDetailsModel? movieDetailsModel;
  String? error;

  MovieDetailsResponse(this.movieDetailsModel,this.error);

  MovieDetailsResponse.fromjson(Map<String , dynamic>json)
  {
    movieDetailsModel = MovieDetailsModel.fromjson(json);
    error = '';
  }

  MovieDetailsResponse.withError(String errorValue)
  {
    movieDetailsModel = null;
    error = errorValue;
  }
}