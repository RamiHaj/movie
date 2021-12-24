import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:movie/bloc/get_movie_details_bloc.dart';
import 'package:movie/models/movie_detail.dart';
import 'package:movie/models/movie_details_response.dart';
import 'package:movie/shared/theme/colors.dart' as style;


class MovieInfo extends StatefulWidget {
  final int id;
  const MovieInfo({Key? key, required this.id}) : super(key: key);

  @override
  _MovieInfoState createState() => _MovieInfoState(id);
}

class _MovieInfoState extends State<MovieInfo> {
  final int id;
  _MovieInfoState(this.id);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    movieDetailBloc.getMoviesDetails(id);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    movieDetailBloc.dipose();
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MovieDetailsResponse>(
      stream: movieDetailBloc.subject!.stream,
      builder: (context , AsyncSnapshot<MovieDetailsResponse> snapshot)
      {
        if(snapshot.hasData)
        {
          if(snapshot.data!.error != null && snapshot.data!.error!.isNotEmpty)
          {
            return buildErrorWidget(snapshot.data!.error!);
          }
          return buildInfoWidget(snapshot.data);
        }else if(snapshot.hasError)
        {
          return buildErrorWidget(snapshot.data!.error!);
        }else
        {
          return buildLoadingInfoWidget();
        }
      },
    );
  }
  Widget buildLoadingInfoWidget()
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

  Widget buildInfoWidget(MovieDetailsResponse? data)
  {
    MovieDetailsModel? info = data!.movieDetailsModel;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10.0,),
        Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Budget',
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                      color: style.Colors.titleColor
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    info!.budget.toString() +'\$',
                    style: const TextStyle(
                      color: style.Colors.secondColor,
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold
                    ),
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Duration',
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                      color: style.Colors.titleColor
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    info.runTime.toString() +'min',
                    style: const TextStyle(
                      color: style.Colors.secondColor,
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold
                    ),
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Release Date',
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                      color: style.Colors.titleColor
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    info.releaseDate!,
                    style: const TextStyle(
                      color: style.Colors.secondColor,
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 10.0,),
        Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Text(
                    'Geners :',
                  style: TextStyle(
                    color: style.Colors.titleColor,
                    fontWeight: FontWeight.w500
                  ),
                ),
              ),
              const SizedBox(height: 5.0,),
              Container(
                height: 35.0,
                padding: const EdgeInsets.only(left: 10.0, right: 10.0 , top: 10.0),
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: info.genres!.length,
                    itemBuilder: (context , index)
                    {
                      return Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Container(
                          padding: const EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(
                              width: 1.0,
                              color: Colors.white
                            )
                          ),
                          child: Text(
                            info.genres![index].name!,
                            style: const TextStyle(
                              color: style.Colors.secondColor,
                              fontSize: 12.0
                            ),
                          ),
                        ),
                      );
                    }
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
