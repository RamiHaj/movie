import 'package:flutter/cupertino.dart';
import 'package:movie/models/movie_response.dart';
import 'package:movie/shared/network.dart';
import 'package:rxdart/rxdart.dart';

class MovieSimilarBloc
{
  final MovieRepository _repository = MovieRepository();
  final BehaviorSubject<MovieResponse> _subject = BehaviorSubject<MovieResponse>();

  getSimilarMovies(int id)async
  {
    MovieResponse response = await _repository.getSimilarMovies(id);
    _subject.sink.add(response);
  }
  @mustCallSuper
  void dipose()async
  {
    await _subject.drain();
    _subject.close();
  }
  void drainStream(){_subject.value = null as MovieResponse;}

  BehaviorSubject<MovieResponse> get subject => _subject;
}

final movieSimilarBloc = MovieSimilarBloc();