import 'dart:ui';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:movie/bloc/get_videos_bloc.dart';
import 'package:movie/models/movie.dart';
import 'package:movie/models/video.dart';
import 'package:movie/models/video_response.dart';
import 'package:movie/modules/casts.dart';
import 'package:movie/modules/similar_movies.dart';
import 'package:movie/modules/video_player.dart';
import 'package:movie/shared/theme/colors.dart' as style;
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'movie_info.dart';

class MovieDetails extends StatefulWidget {
  final model;
  const MovieDetails({Key? key, required this.model}) : super(key: key);

  @override
  _MovieDetailsState createState() => _MovieDetailsState(model);
}

class _MovieDetailsState extends State<MovieDetails> {
  final model;
  _MovieDetailsState(this.model);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    videoBloc.getVideo(model.id!);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    videoBloc.dipose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: style.Colors.mainColor,
      body: Builder(
          builder: (context)
          {
            return Stack(
              children: [
                CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      backgroundColor: style.Colors.mainColor,
                      expandedHeight: 200,
                      pinned: true,
                      flexibleSpace: FlexibleSpaceBar(
                          centerTitle: true,
                          title: Text(
                              model.title!.length > 40
                                  ? model.title!.substring(0 , 37) + ''
                                  : model.title!,
                            style: const TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          background: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 2,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage('https://image.tmdb.org/t/p/original/${model.backPoster}')
                              )
                            ),
                            child: Container(
                              color: Colors.black.withOpacity(0.5),
                            ),
                          ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.all(0.0),
                      sliver: SliverList(
                          delegate: SliverChildListDelegate(
                            [
                               Padding(
                                  padding: const EdgeInsets.only(left: 10.0,top: 10.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        model.rating.toString(),
                                        style: const TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      RatingBar.builder(
                                          itemSize: 13.0,
                                          initialRating: model.rating! / 2,
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
                                  ),
                              ),
                               const Padding(
                                 padding: EdgeInsets.only(top: 20.0,left: 10.0),
                                 child: Text(
                                     'OverView :',
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w500,
                                        color: style.Colors.titleColor
                                      ),
                                 ),
                               ),
                               const SizedBox(height: 5.0,),
                               Padding(
                                 padding: const EdgeInsetsDirectional.only(start: 10.0,end: 10.0),
                                 child: Container(
                                   height: 1,
                                   width: double.infinity,
                                   color: Colors.grey,
                                 ),
                               ),
                               const SizedBox(height: 10.0,),
                               Padding(
                                   padding: const EdgeInsets.all(10.0),
                                   child: Text(
                                     model.overview!,
                                     style: const TextStyle(
                                       fontSize: 15.0,
                                       color: Colors.white
                                     ),
                                   ),
                               ),
                              const SizedBox(height:10.0,),
                              MovieInfo(id: model.id!,),
                              const SizedBox(height: 10.0,),
                              CastScreen(model.id!),
                              const SizedBox(height: 10.0,),
                              SimilarMovies(id: model.id!)
                            ]
                          )
                      ),
                    ),
                  ],
                ),
                Positioned(
                  right: 10,
                  top: 212,
                  child: StreamBuilder<VideoResponse>(
                    stream: videoBloc.subject!.stream,
                    builder: (context , AsyncSnapshot<VideoResponse> snapshot)
                    {
                      if(snapshot.hasData)
                      {
                        if(snapshot.data!.error != null && snapshot.data!.error!.isNotEmpty)
                        {
                          return buildErrorWidget(snapshot.data!.error!);
                        }
                        return buildVideoWidget(snapshot.data);
                      }else if(snapshot.hasError)
                      {
                        return buildErrorWidget(snapshot.data!.error!);
                      }else
                      {
                        return buildLoadingPlayingWidget();
                      }
                    },
                  ),
                ),
              ],
            );
          }
      ),
    );
  }
  Widget buildLoadingPlayingWidget()
  {
    return Container();
  }

  Widget buildErrorWidget(String error)
  {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Error Occured: $error"),
          ],
        ));
  }

  Widget buildVideoWidget(VideoResponse? data)
  {
    List<Video>? videos= data!.videos;

    return Container(
      decoration: const BoxDecoration(
        color: style.Colors.secondColor,
        shape: BoxShape.circle
      ),
      child: IconButton(
        onPressed: ()
        {
          Navigator.push(context, MaterialPageRoute(builder: (context) =>
              VideoPlayer(controller: YoutubePlayerController(
                initialVideoId: videos![0].key!,
                flags: const YoutubePlayerFlags(
                  autoPlay: true,
                )
              ),
              )
          ));
        },
        icon: const Icon(Icons.play_arrow,color: Colors.white,),
      ),
    );
  }
}
