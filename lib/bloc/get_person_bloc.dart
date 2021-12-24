import 'package:movie/models/person_response.dart';
import 'package:movie/shared/network.dart';
import 'package:rxdart/rxdart.dart';

class PersonListMovieBloc
{
  final MovieRepository _repository = MovieRepository();
  final BehaviorSubject<PersonResponse> _subject = BehaviorSubject<PersonResponse>();

  getPersonMovie()async
  {
    PersonResponse response = await _repository.getPerson();
    _subject.sink.add(response);
  }

  dipose()
  {
    _subject.close();
  }

  BehaviorSubject<PersonResponse> get subject => _subject;
}
final personBloc = PersonListMovieBloc();
