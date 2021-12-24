import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:movie/bloc/get_similar_bloc.dart';
import 'package:movie/models/movie.dart';
import 'package:movie/models/movie_response.dart';
import 'package:movie/shared/theme/colors.dart' as style;

import 'movie_details_screen.dart';

class SimilarMovies extends StatefulWidget {
  final int id;
  const SimilarMovies({Key? key, required this.id}) : super(key: key);

  @override
  _SimilarMovies createState() => _SimilarMovies(id);
}

class _SimilarMovies extends State<SimilarMovies> {
  final int id;
  _SimilarMovies(this.id);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    movieSimilarBloc.getSimilarMovies(id);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    movieSimilarBloc.dipose();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:  [
        const Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text(
            'Similar Movies',
            style: TextStyle(
                color: style.Colors.secondColor,
                fontSize: 12.0,
                fontWeight: FontWeight.w500
            ),
          ),
        ),
        const SizedBox(
          height: 15.0,
        ),
        StreamBuilder<MovieResponse>(
          stream: movieSimilarBloc.subject.stream,
          builder: (context , AsyncSnapshot<MovieResponse> snapshot)
          {
            if(snapshot.hasData)
            {
              if(snapshot.data!.error != null && snapshot.data!.error!.isNotEmpty)
              {
                return buildErrorWidget(snapshot.data!.error!);
              }
              return buildTopRatedWidget(snapshot.data);
            }else if(snapshot.hasError)
            {
              return buildErrorWidget(snapshot.data!.error!);
            }else
            {
              return buildLoadingTopRatedWidget();
            }
          },
        ),
      ],
    );
  }
  Widget buildLoadingTopRatedWidget()
  {
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

  Widget buildTopRatedWidget(MovieResponse? data)
  {
    List<MovieModel>? topRated = data!.movies;
    if(topRated!.isEmpty)
    {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Text('No Movies')
          ],
        ),
      );
    }else
    {
      return Container(
        height: 300.0,
        padding: const EdgeInsets.only(left: 8.0),
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: topRated.length,
            itemBuilder: (context, index) {
              return Padding(
                padding:
                const EdgeInsets.only(top: 10.0, bottom: 10.0, right: 10.0),
                child: GestureDetector(
                  onTap: ()
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> MovieDetails(model: topRated[index])));
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      topRated[index].poster == null
                          ? Container(
                        width: 120.0,
                        height: 180.0,
                        decoration: BoxDecoration(
                            color: style.Colors.secondColor,
                            borderRadius: BorderRadius.circular(2.0),
                            shape: BoxShape.rectangle),
                        child: Column(
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
                                  'https://image.tmdb.org/t/p/w500/${topRated[index].poster!}',
                                ))),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      SizedBox(
                        width: 100,
                        child: Text(
                          topRated[index].title!,
                          maxLines: 2,
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
                            topRated[index].rating.toString(),
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
                              initialRating: topRated[index].rating! / 2,
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
