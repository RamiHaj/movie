import 'package:movie/models/video.dart';

class VideoResponse
{
  List<Video>? videos;
  String? error;

  VideoResponse(this.error,this.videos);

  VideoResponse.fromjson(Map<String , dynamic> json)
  {
    videos = (json['results'] as List).map((e) => Video.fromjson(e)).toList();
    error = json['error'];
  }

  VideoResponse.withError(String valueError)
  {
    videos = null;
    error = valueError;
  }
}