import 'package:movie/models/movie_response.dart';
import 'package:movie/shared/network.dart';
import 'package:rxdart/rxdart.dart';

class MovieListBloc
{
  final MovieRepository _repository = MovieRepository();
  final BehaviorSubject<MovieResponse> _subject = BehaviorSubject<MovieResponse>();

  getMovies()async
  {
    MovieResponse response = await _repository.getMovies();
    _subject.sink.add(response);
  }

  dipose()
  {
    _subject.close();
  }

  BehaviorSubject<MovieResponse> get subject => _subject;
}

final movieBloc = MovieListBloc();