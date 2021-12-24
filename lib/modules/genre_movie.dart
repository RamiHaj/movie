import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:movie/bloc/get_movie_by_gener_bloc.dart';
import 'package:movie/models/movie.dart';
import 'package:movie/models/movie_response.dart';
import 'package:movie/shared/theme/colors.dart' as style;

import 'movie_details_screen.dart';

class GenreMovies extends StatefulWidget {
  final int genreId;
  const GenreMovies({Key? key, required this.genreId}) : super(key: key);

  @override
  _GenreMoviesState createState() => _GenreMoviesState(genreId);
}

class _GenreMoviesState extends State<GenreMovies> {
  final int genreId;
  _GenreMoviesState(this.genreId);
  @override
  void initState() {
    super.initState();
    movieByGenreBloc.getMovieByGenre(genreId);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MovieResponse>(
      stream: movieByGenreBloc.subject.stream,
      builder: (context, AsyncSnapshot<MovieResponse> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.error != null &&
              snapshot.data!.error!.isNotEmpty) {
            return buildErrorWidget(snapshot.data!.error!);
          }
          return buildGenreByIdWidget(snapshot.data);
        } else if (snapshot.hasError) {
          return buildErrorWidget(snapshot.data!.error!);
        } else {
          return buildLoadingGenreWidget();
        }
      },
    );
  }

  Widget buildLoadingGenreWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          SizedBox(
            height: 25.0,
            width: 25.0,
            child: CircularProgressIndicator(),
          )
        ],
      ),
    );
  }

  Widget buildErrorWidget(String error) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Error Occured: $error"),
          ],
    ));
  }

  Widget buildGenreByIdWidget(MovieResponse? data) {
    List<MovieModel>? movies = data!.movies;
    if (movies!.isEmpty) {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [Text('No Movie')],
        ),
      );
    } else {
      return Container(
        height: 300.0,
        padding: const EdgeInsets.only(left: 8.0),
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: movies.length,
            itemBuilder: (context, index) {
              return Padding(
                padding:
                    const EdgeInsets.only(top: 10.0, bottom: 10.0, right: 10.0),
                child: GestureDetector(
                  onTap: ()
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> MovieDetails(model: movies[index])));
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      movies[index].poster == null
                          ? Container(
                              width: 120.0,
                              height: 180.0,
                              decoration: BoxDecoration(
                                  color: style.Colors.secondColor,
                                  borderRadius: BorderRadius.circular(2.0),
                                  shape: BoxShape.rectangle),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(
                                    EvaIcons.fileOutline,
                                    color: Colors.white,
                                    size: 50.0,
                                  ),
                                ],
                              ),
                            )
                          : Container(
                              width: 120.0,
                              height: 180.0,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2.0),
                                  shape: BoxShape.rectangle,
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                        'https://image.tmdb.org/t/p/w500/${movies[index].poster!}',
                                      ))),
                            ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      SizedBox(
                        width: 100,
                        child: Text(
                          movies[index].title!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 11.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            movies[index].rating.toString(),
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 8.0),
                          ),
                          const SizedBox(
                            width: 3.0,
                          ),
                          RatingBar.builder(
                              itemSize: 8.0,
                              initialRating: movies[index].rating! / 2,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemPadding:
                                  const EdgeInsets.symmetric(horizontal: 2.0),
                              itemBuilder: (context, _) => const Icon(
                                    EvaIcons.star,
                                    color: style.Colors.secondColor,
                                  ),
                              onRatingUpdate: (rating) {})
                        ],
                      )
                    ],
                  ),
                ),
              );
            }),
      );
    }
  }
}
