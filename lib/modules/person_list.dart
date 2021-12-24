import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:movie/bloc/get_person_bloc.dart';
import 'package:movie/models/person.dart';
import 'package:movie/models/person_response.dart';
import 'package:movie/shared/theme/colors.dart' as style;

class PersonList extends StatefulWidget {
  const PersonList({Key? key}) : super(key: key);

  @override
  _PersonListState createState() => _PersonListState();
}

class _PersonListState extends State<PersonList> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    personBloc.getPersonMovie();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:  [
        const SizedBox(
          height: 15.0,
        ),
        const Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text(
              'Trending Persons At The Week',
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
        StreamBuilder<PersonResponse>(
        stream: personBloc.subject.stream,
        builder: (context , AsyncSnapshot<PersonResponse> snapshot)
        {
          if(snapshot.hasData)
          {
            if(snapshot.data!.error != null && snapshot.data!.error!.isNotEmpty)
          {
            return buildErrorWidget(snapshot.data!.error!);
          }
            return buildPersonWidget(snapshot.data);
          }else if(snapshot.hasError)
          {
            return buildErrorWidget(snapshot.data!.error!);
          }else
          {
            return buildLoadingPersonWidget();
          }
          },
        ),
      ],
    );
  }
  Widget buildLoadingPersonWidget()
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

  Widget buildPersonWidget(PersonResponse? data)
  {
    List<Person>? persons = data!.person;
    if(persons!.isEmpty)
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
          height: 150.0,
          padding: const EdgeInsets.only(left: 8.0),
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: persons.length,
              itemBuilder: (context , index)
              {
                return Container(
                  padding: const EdgeInsets.only(right: 10.0,top: 10.0),
                  child: Column(
                    children: [
                      persons[index].profileImg == null
                        ?Container(
                        height: 70.0,
                        width: 70.0,
                        decoration: const BoxDecoration(
                          color: style.Colors.secondColor,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(FontAwesomeIcons.userAlt,color: Colors.white,),
                      )
                        :Container(
                        height: 70.0,
                        width: 70.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage('https://image.tmdb.org/t/p/w500/${persons[index].profileImg}')
                          )
                        ),
                      ),
                      const SizedBox(height: 10,),
                      Text(
                        persons[index].name!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          height: 1.4
                        ),
                      ),
                      const SizedBox(height: 5.0,),
                      Text(
                        'Trending for ${persons[index].known!}',
                        style: const TextStyle(
                          color: style.Colors.titleColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w400
                        ),
                      )
                    ],
                  ),
                );
              }
          ),
        );
      }
  }
}
