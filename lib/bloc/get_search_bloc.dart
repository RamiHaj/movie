import 'package:movie/models/search_movie_response.dart';
import 'package:movie/shared/network.dart';
import 'package:rxdart/rxdart.dart';

class SearchBloc
{
  final MovieRepository _repository = MovieRepository();
  final BehaviorSubject<SearchResponse>? _subject = BehaviorSubject<SearchResponse>();

  getMovies(String text)async
  {
    SearchResponse response = await _repository.getSearchMovies(text);
    _subject!.sink.add(response);
  }

  dipose()
  {
    _subject!.close();
  }

  BehaviorSubject<SearchResponse>? get subject => _subject;
}

final searchBloc = SearchBloc();