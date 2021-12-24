import 'package:flutter/cupertino.dart';
import 'package:movie/models/movie_details_response.dart';
import 'package:movie/shared/network.dart';
import 'package:rxdart/rxdart.dart';

class MovieDetailsBloc
{
  final MovieRepository _repository = MovieRepository();
  final BehaviorSubject<MovieDetailsResponse>? _subject = BehaviorSubject<MovieDetailsResponse>();

  getMoviesDetails(int id)async
  {
    MovieDetailsResponse response = await _repository.getDetailsMovie(id);
    _subject!.sink.add(response);
  }
  @mustCallSuper
  void dipose()async
  {
    await _subject!.drain();
    _subject!.close();
  }
  void drainStream(){_subject!.value = dynamic as MovieDetailsResponse;}

  BehaviorSubject<MovieDetailsResponse>? get subject => _subject;
}

final movieDetailBloc = MovieDetailsBloc();