import 'package:flutter/cupertino.dart';
import 'package:movie/models/video_response.dart';
import 'package:movie/shared/network.dart';
import 'package:rxdart/rxdart.dart';

class VideoBloc
{
  final MovieRepository _repository = MovieRepository();
  final BehaviorSubject<VideoResponse>? _subject = BehaviorSubject<VideoResponse>();

  getVideo(int id)async
  {
    VideoResponse response = await _repository.getVideosMovies(id);
    _subject!.sink.add(response);
  }
  @mustCallSuper
  void dipose()async
  {
    await _subject!.drain();
    _subject!.close();
  }
  void drainStream(){_subject!.value = null as VideoResponse;}

  BehaviorSubject<VideoResponse>? get subject => _subject;
}

final videoBloc = VideoBloc();