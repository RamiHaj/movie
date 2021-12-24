import 'package:movie/models/genre.dart';

class MovieDetailsModel
{
  int? id;
  bool? adult;
  int? budget;
  List<Genre>? genres;
  String? releaseDate;
  int? runTime;

  MovieDetailsModel(
      this.id,
      this.genres,
      this.releaseDate,
      this.adult,
      this.budget,
      this.runTime
      );

  MovieDetailsModel.fromjson(Map<String , dynamic> json)
  {
    id = json['id'];
    adult = json['adult'];
    budget = json['budget'];
    genres = (json['genres'] as List).map((e) => Genre.fromjson(e)).toList();
    releaseDate = json['release_date'];
    runTime = json['runtime'];
  }
}