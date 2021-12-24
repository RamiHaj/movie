class SearchMovie
{
  int? id;
  String? poster;
  double? popularity;
  double? rating;
  String? title;
  String? backPoster;
  String? overview;

  SearchMovie(this.id , this.poster, this.rating,this.title);

  SearchMovie.fromjson(Map<String ,dynamic > json)
  {
    id = json['id'];
    poster = json['poster_path'];
    title = json['title'];
    popularity = json['popularity'];
    backPoster = json['backdrop_path'];
    overview = json['overview'];
    rating = json['vote_average'].toDouble();
  }
}