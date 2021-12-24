import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:movie/bloc/get_now_playing_bloc.dart';
import 'package:movie/models/movie.dart';
import 'package:movie/models/movie_response.dart';
import 'package:movie/shared/theme/colors.dart' as style;
import 'package:page_indicator/page_indicator.dart';

import 'movie_details_screen.dart';


class NowPlaying extends StatefulWidget {
  const NowPlaying({Key? key}) : super(key: key);

  @override
  _NowPlayingState createState() => _NowPlayingState();
}

class _NowPlayingState extends State<NowPlaying> {
  @override
  void initState()
  {
    super.initState();
    movieNowPlaying.getNowPlayingMovie();
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MovieResponse>(
      stream: movieNowPlaying.subject.stream,
      builder: (context , AsyncSnapshot<MovieResponse> snapshot)
      {
        if(snapshot.hasData)
        {
          if(snapshot.data!.error != null && snapshot.data!.error!.isNotEmpty)
          {
            return buildErrorWidget(snapshot.data!.error!);
          }
          return buildNowLoadingWidget(snapshot.data);
        }else if(snapshot.hasError)
        {
          return buildErrorWidget(snapshot.data!.error!);
        }else
          {
            return buildLoadingPlayingWidget();
          }
      },
    );
  }
  Widget buildLoadingPlayingWidget()
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

  Widget buildNowLoadingWidget(MovieResponse? data)
  {
    List<MovieModel>? movies = data!.movies;
    if(movies!.isEmpty)
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
      } else
        {
          return SizedBox(
            height: 220,
            child: PageIndicatorContainer(
              align: IndicatorAlign.bottom,
              indicatorSpace: 3.0,
              padding: const EdgeInsets.all(5.0),
              indicatorColor: style.Colors.titleColor,
              indicatorSelectorColor: style.Colors.secondColor,
              shape: IndicatorShape.circle(size:8.0),
              length: movies.take(5).length,
              child: PageView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: movies.take(5).length,
                  itemBuilder:(context , index)
                  {
                    return GestureDetector(
                      onTap: ()
                      {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> MovieDetails(model: movies[index])));
                      },
                      child: Stack(
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 220,
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image:NetworkImage(
                                    'https://image.tmdb.org/t/p/original/${movies[index].backPoster!}',),
                                )
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  style.Colors.mainColor.withOpacity(1.0),
                                  style.Colors.mainColor.withOpacity(0.0)
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                stops:const [
                                  0.0,
                                  0.9
                                ]
                              )
                            ),
                          ),
                          Positioned(
                            bottom: 30.0,
                            child: Container(
                              padding: const EdgeInsets.only(left: 10.0 , right: 10.0),
                              width: 250,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    movies[index].title!,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      height: 1.5,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0
                                    ),
                                  )
                                ],
                            ),
                          )),

                        ],
                      ),
                    );
                  }
              ),
            ),
          );
        }
  }
}
