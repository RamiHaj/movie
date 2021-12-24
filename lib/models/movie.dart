class MovieModel {
   int? id;
   dynamic popularity;
   String? poster;
   String? title;
   String? backPoster;
   String? overview;
   double? rating;

  MovieModel(this.id,
      this.popularity,
      this.poster,
      this.title,
      this.overview,
      this.backPoster,
      this.rating);

  MovieModel.fromjson(Map<String, dynamic> json)
  {
    id = json['id'];
    popularity = json['popularity'];
    poster = json['poster_path'];
    title = json['title'];
    overview = json['overview'];
    backPoster = json['backdrop_path'];
    rating = json['vote_average'].toDouble();
  }


}