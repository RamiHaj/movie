import 'package:movie/models/movie_response.dart';
import 'package:movie/shared/network.dart';
import 'package:rxdart/rxdart.dart';

class MovieListPlayingBloc
{
  final MovieRepository _repository = MovieRepository();
  final BehaviorSubject<MovieResponse> _subject = BehaviorSubject<MovieResponse>();

  getNowPlayingMovie()async
  {
    MovieResponse response = await _repository.getPlayingMovies();
    _subject.sink.add(response);
  }

  dipose()
  {
    _subject.close();
  }

  BehaviorSubject<MovieResponse> get subject => _subject;
}
final movieNowPlaying = MovieListPlayingBloc();