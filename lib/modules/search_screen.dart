import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:movie/bloc/get_search_bloc.dart';
import 'package:movie/models/search_movie.dart';
import 'package:movie/models/search_movie_response.dart';
import 'package:movie/modules/movie_details_screen.dart';
import 'package:movie/shared/theme/colors.dart' as style;

class SearchScreen extends StatefulWidget {
  SearchScreen({Key? key}) : super(key: key);
  var searchController = TextEditingController();

  @override
  _SearchScreenState createState() => _SearchScreenState(searchController);
}

class _SearchScreenState extends State<SearchScreen> {
  final text;
  _SearchScreenState(this.text);
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchBloc.dipose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: style.Colors.mainColor,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.search,
                validator: (String? value)
                {
                  if(value!.isEmpty)
                  {
                    return 'search must have text';
                  }
                  return null;
                },
                onChanged: (text)
                {
                  if(text == null)
                  {
                    searchBloc.dipose();
                  }else
                    {
                      searchBloc.getMovies(text);
                    }
                },
                controller: text,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.white
                      ),
                        borderRadius: BorderRadius.circular(25)
                    ),
                    labelText: 'Search',
                    suffixIcon: const Icon(Icons.search)
                )
            ),
          ),
          StreamBuilder<SearchResponse>(
            stream: searchBloc.subject!.stream,
            builder: (context , AsyncSnapshot<SearchResponse> snapshot)
            {
              if(snapshot.hasData)
              {
                if(snapshot.data!.error != null && snapshot.data!.error!.isNotEmpty)
                {
                  return buildErrorWidget(snapshot.data!.error!);
                }
                return buildSearchWidget(snapshot.data);
              }else if(snapshot.hasError)
              {
                return buildErrorWidget(snapshot.data!.error!);
              }else
              {
                return buildLoadingSearchWidget();
              }
            },
          ),
        ],
      ),
    );
  }
  Widget buildLoadingSearchWidget()
  {
    return Container();
  }

  Widget buildErrorWidget(String error)
  {
    return const SizedBox(
      child: Center(
        child: Text(
          'No Movies'
        )
      ),
    );
  }

  Widget buildSearchWidget(SearchResponse? data)
  {
    List<SearchMovie>? search= data!.searchs;
    if(search!.isEmpty)
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
    }
    else
      {
        return searchBloc.subject == null
            ?const Text('')
            :Expanded(child: ListView.separated(
              itemBuilder: (context , index){
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: GestureDetector(
                  onTap: ()
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => MovieDetails(model: search[index],)));
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      search[index].poster == null
                          ? Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 3,
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
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 3,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2.0),
                            shape: BoxShape.rectangle,
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                  'https://image.tmdb.org/t/p/w500/${search[index].poster!}',
                                ))),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        search[index].title!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 15.0,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            search[index].rating.toString(),
                            style: const TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0),
                          ),
                          const SizedBox(
                            width: 3.0,
                          ),
                          RatingBar.builder(
                              itemSize: 14.0,
                              initialRating: search[index].rating! / 2,
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
                      
                    ],
                  ),
                ),
              );
            },
              separatorBuilder: (context , index) =>
                  Padding(
                  padding: const EdgeInsetsDirectional.only(start: 20.0),
                    child: Container(
                    width: double.infinity,
                    height: 1.0,
                    color: style.Colors.secondColor,
          ),
        ),
              itemCount: search.length
        ));
      }
  }
}
