import 'package:movie/models/person.dart';

class PersonResponse
{
  List<Person>? person;
  String? error;

  PersonResponse(this.person , this.error);

  PersonResponse.fromjson(Map<String , dynamic>json)
  {
    person = (json['results'] as List).map((e) => Person.fromjson(e)).toList();
    error = "";
  }

  PersonResponse.withError(String errorValue)
  {
     person = List as List<Person>?;
    error = errorValue;
  }
}