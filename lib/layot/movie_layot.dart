import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:movie/modules/genres.dart';
import 'package:movie/modules/now_playing.dart';
import 'package:movie/modules/person_list.dart';
import 'package:movie/modules/search_screen.dart';
import 'package:movie/modules/top_rated_movie.dart';
import 'package:movie/shared/theme/colors.dart' as style;

class MovieLayot extends StatelessWidget {
  const MovieLayot({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: style.Colors.mainColor,
      appBar: AppBar(
        backgroundColor: style.Colors.mainColor,
        centerTitle: true,
        leading: const Icon(EvaIcons.menu2Outline , color: Colors.white,),
        title: const Text('IMDB App'),
        actions: <Widget>[
          IconButton(
              onPressed: ()
              {
                Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen()));
              },
              icon: const Icon(EvaIcons.search , color: Colors.white,)
          )
        ],
      ),
      body: ListView(
        children: const [
          NowPlaying(),
          GenresScreen(),
          PersonList(),
          TopMovies(),
        ],
      ),
    );
  }
}
