import 'package:movie/models/cast.dart';

class CastResponse
{
  List<Cast>? casts;
  String? error;

  CastResponse(this.casts,this.error);

  CastResponse.fromjson(Map<String , dynamic> json)
  {
    casts = (json['cast'] as List).map((e) => Cast.fromjson(e)).toList();
    error = '';
  }

  CastResponse.withError(String errorValue)
  {
    casts = null;
    error = errorValue;
  }
}