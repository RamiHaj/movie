import 'package:movie/models/genre_response.dart';
import 'package:movie/shared/network.dart';
import 'package:rxdart/rxdart.dart';

class GenreListBloc
{
  final MovieRepository _repository = MovieRepository();
  final BehaviorSubject<GenreResponse> _subject = BehaviorSubject<GenreResponse>();

  getGenre()async
  {
    GenreResponse response = await _repository.getGenre();
    _subject.sink.add(response);
  }

  dipose()
  {
    _subject.close();
  }

  BehaviorSubject<GenreResponse> get subject => _subject;

}

final genreBloc = GenreListBloc();