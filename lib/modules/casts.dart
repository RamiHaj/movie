import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie/bloc/get_casts.dart';
import 'package:movie/models/cast.dart';
import 'package:movie/models/cast_response.dart';
import 'package:movie/shared/theme/colors.dart' as style;

class CastScreen extends StatefulWidget {
  final int id;
  const CastScreen(this.id, {Key? key}) : super(key: key);

  @override
  State<CastScreen> createState() => _CastScreenState(id);
}

class _CastScreenState extends State<CastScreen> {
  final int id;
  _CastScreenState(this.id);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    castBloc.getCasts(id);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    castBloc.dipose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10.0,),
        const Padding(
          padding: EdgeInsets.only(left: 10.0),
          child: Text(
              'Casts :',
              textAlign: TextAlign.start,
              style: TextStyle(
                color: style.Colors.titleColor,
                fontWeight: FontWeight.w500,
                fontSize: 15.0
              ),
          ),
        ),
        StreamBuilder<CastResponse>(
          stream: castBloc.subject.stream,
          builder: (context , AsyncSnapshot<CastResponse> snapshot)
          {
            if(snapshot.hasData)
            {
              if(snapshot.data!.error != null && snapshot.data!.error!.isNotEmpty)
              {
                return buildErrorWidget(snapshot.data!.error!);
              }
              return buildCastWidget(snapshot.data);
            }else if(snapshot.hasError)
            {
              return buildErrorWidget(snapshot.data!.error!);
            }else
            {
              return buildLoadingCastWidget();
            }
          },
        )
      ],
    );
  }
  Widget buildLoadingCastWidget()
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

  Widget buildCastWidget(CastResponse? data)
  {
    List<Cast>? cast = data!.casts;
    if(cast!.isEmpty)
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
          height: 175.0,
          padding: const EdgeInsets.only(left: 8.0),
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: cast.length,
              itemBuilder: (context , index)
              {
                return Padding(
                  padding: const EdgeInsets.only(right: 10.0 ,top: 10.0),
                  child: SizedBox(
                    width: 100,
                    child: GestureDetector(
                      onTap: (){},
                      child: Column(
                        children: [
                          cast[index].image != null
                            ?Container(
                            width: 70.0,
                            height: 70.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: NetworkImage('https://image.tmdb.org/t/p/w500/${cast[index].image}')
                              )
                            ),
                          )
                            :Container(
                              width: 70.0,
                              height: 70.0,
                              decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                              fit: BoxFit.fill,
                              image: AssetImage('assets/3973481.jpg')
                        )
                      ),
                      ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Text(
                              cast[index].name!,
                              style: const TextStyle(
                                height: 1.4,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 9.0
                              ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            cast[index].character!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: style.Colors.secondColor
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }
          ),
        );
      }
  }
}
