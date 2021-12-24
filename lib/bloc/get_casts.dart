import 'package:flutter/cupertino.dart';
import 'package:movie/models/cast_response.dart';
import 'package:movie/shared/network.dart';
import 'package:rxdart/rxdart.dart';

class CastListBloc
{
  final MovieRepository _repository = MovieRepository();
  final BehaviorSubject<CastResponse> _subject = BehaviorSubject<CastResponse>();

  getCasts(int id)async
  {
    CastResponse response = await _repository.getCasts(id);
    _subject.sink.add(response);
  }
  @mustCallSuper
  void dipose()async
  {
    await _subject.drain();
    _subject.close();
  }
  void drainStream(){_subject.value = null as CastResponse;}

  BehaviorSubject<CastResponse> get subject => _subject;
}

final castBloc = CastListBloc();