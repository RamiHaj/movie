import 'package:flutter/material.dart';
import 'package:movie/bloc/get_gener_bloc.dart';
import 'package:movie/models/genre.dart';
import 'package:movie/models/genre_response.dart';
import 'package:movie/modules/genre_list.dart';

class GenresScreen extends StatefulWidget {
  const GenresScreen({Key? key}) : super(key: key);

  @override
  _GenresScreenState createState() => _GenresScreenState();
}

class _GenresScreenState extends State<GenresScreen> {
  @override
  void initState()
  {
    super.initState();
    genreBloc.getGenre();
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<GenreResponse>(
      stream: genreBloc.subject.stream,
      builder: (context , AsyncSnapshot<GenreResponse> snapshot)
      {
        if(snapshot.hasData)
        {
          if(snapshot.data!.error != null && snapshot.data!.error!.isNotEmpty)
          {
            return buildErrorWidget(snapshot.data!.error!);
          }
          return buildGenreWidget(snapshot.data);
        }else if(snapshot.hasError)
        {
          return buildErrorWidget(snapshot.data!.error!);
        }else
        {
          return buildLoadingGenreWidget();
        }
      },
    );
  }
  Widget buildLoadingGenreWidget()
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

  Widget buildGenreWidget(GenreResponse? data)
  {
    List<Genre>? genre = data!.genre;
    if(genre!.isEmpty)
    {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Text('No Genre')
          ],
        ),
      );
    }else
      {
        return GenreList(genres: genre);
      }
  }
}
