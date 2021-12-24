import 'package:flutter/material.dart';
import 'package:movie/bloc/get_movie_by_gener_bloc.dart';
import 'package:movie/models/genre.dart';
import 'package:movie/modules/genre_movie.dart';
import 'package:movie/shared/theme/colors.dart' as style;

class GenreList extends StatefulWidget {
  final List<Genre> genres;
  const GenreList({Key? key, required this.genres}) : super(key: key);

  @override
  _GenreListState createState() => _GenreListState(genres);
}

class _GenreListState extends State<GenreList> with SingleTickerProviderStateMixin{
  final List<Genre> genres;
  TabController? tabController;
  _GenreListState(this.genres);
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: genres.length, vsync: this);
  }
  @override
  void dispose() {
    super.dispose();
    tabController!.dispose();
    tabController!.addListener(() {
      if(tabController!.indexIsChanging)
      {
        movieByGenreBloc.drainStream();
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300.0,
      child: DefaultTabController(
        length: genres.length,
        child: Scaffold(
          backgroundColor: style.Colors.mainColor,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(50.0),
            child: AppBar(
              backgroundColor: style.Colors.mainColor,
              bottom: TabBar(
                controller: tabController,
                indicatorColor: style.Colors.secondColor,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorWeight: 3.0,
                unselectedLabelColor: style.Colors.titleColor,
                labelColor: Colors.white,
                isScrollable: true,
                tabs: genres.map((Genre genre)
                {
                  return Container(
                    padding: const EdgeInsets.only(top: 10.0,bottom: 15.0),
                    child: Text(
                      genre.name!.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          body: TabBarView(
            controller: tabController,
            children: genres.map((Genre genre)
            {
              return GenreMovies(genreId: genre.id!);
            }).toList(),
          ),
        ),
      ),
    );
  }
}
