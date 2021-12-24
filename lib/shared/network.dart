import 'package:dio/dio.dart';
import 'package:movie/models/cast_response.dart';
import 'package:movie/models/genre_response.dart';
import 'package:movie/models/movie_details_response.dart';
import 'package:movie/models/movie_response.dart';
import 'package:movie/models/person_response.dart';
import 'package:movie/models/search_movie_response.dart';
import 'package:movie/models/video_response.dart';

class MovieRepository
{
  final String apiKey = '9e9d8a0f24c6df4023a8bf35dd2fc183';

  static String mainUrl = 'https://api.themoviedb.org/3';

  final Dio _dio = Dio();

  var getPopularUrl = '$mainUrl/movie/top_rated';
  var getMoviesUrl = '$mainUrl/discover/movie';
  var getPlayingUrl = '$mainUrl/movie/now_playing';
  var getGenreUrl = '$mainUrl/genre/movie/list';
  var getPersonUrl = '$mainUrl/trending/person/week';
  var getMovieDetail = '$mainUrl/movie';
  var getSearchMovie = '$mainUrl/search/movie';

  Future<MovieResponse> getMovies()async
  {
    var params = {
      'api_key': apiKey,
      'language': 'en-US',
      'page': 1
    };
    try
    {
      Response response = await _dio.get(getPopularUrl , queryParameters:  params);
      return MovieResponse.fromjson(response.data);
    }catch(error , stackTrace)
    {
      print("Exception error: $error stackTrace: $stackTrace");
      return MovieResponse.withError('$error');
    }
  }

  Future<MovieResponse> getPlayingMovies()async
  {
    var params = {
      'api_key': apiKey,
      'language': 'en-US',
      'page': 1
    };
    try
    {
      Response response = await _dio.get(getPlayingUrl , queryParameters:  params);
      return MovieResponse.fromjson(response.data);
    }catch(error , stackTrace)
    {
      print("Exception error: $error stackTrace: $stackTrace");
      return MovieResponse.withError('$error');
    }
  }

  Future<GenreResponse> getGenre()async
  {
    var params = {
      'api_key': apiKey,
      'language': 'en-US',
      'page': 1
    };
    try
    {
      Response response = await _dio.get(getGenreUrl , queryParameters:  params);
      return GenreResponse.fromjson(response.data);
    }catch(error , stackTrace)
    {
      print("Exception error: $error stackTrace: $stackTrace");
      return GenreResponse.withError('$error');
    }
  }

  Future<PersonResponse> getPerson()async
  {
    var params = {
      'api_key': apiKey,
    };
    try
    {
      Response response = await _dio.get(getPersonUrl , queryParameters:  params);
      return PersonResponse.fromjson(response.data);
    }catch(error , stackTrace)
    {
      print("Exception error: $error stackTrace: $stackTrace");
      return PersonResponse.withError('$error');
    }
  }

  Future<MovieResponse> getMovieByGenre(int id)async
  {
    var params = {
      'api_key': apiKey,
      'language': 'en-US',
      'with_genres': id
    };
    try
    {
      Response response = await _dio.get(getMoviesUrl , queryParameters:  params);
      return MovieResponse.fromjson(response.data);
    }catch(error , stackTrace)
    {
      print("Exception error: $error stackTrace: $stackTrace");
      return MovieResponse.withError('$error');
    }
  }

  Future<MovieDetailsResponse> getDetailsMovie(int id)async
  {
    var params = {
      'api_key': apiKey,
      'language': 'en-US',
    };
    try
    {
      Response response = await _dio.get(getMovieDetail+'/$id' , queryParameters:  params);
      return MovieDetailsResponse.fromjson(response.data);
    }catch(error , stackTrace)
    {
      print("Exception error: $error stackTrace: $stackTrace");
      return MovieDetailsResponse.withError('$error');
    }
  }

  Future<CastResponse> getCasts(int id)async
  {
    var params = {
      'api_key': apiKey,
      'language': 'en-US',
    };
    try
    {
      Response response = await _dio.get(getMovieDetail+'/$id'+'/credits' , queryParameters:  params);
      return CastResponse.fromjson(response.data);
    }catch(error , stackTrace)
    {
      print("Exception error: $error stackTrace: $stackTrace");
      return CastResponse.withError('$error');
    }
  }

  Future<MovieResponse> getSimilarMovies(int id)async
  {
    var params = {
      'api_key': apiKey,
      'language': 'en-US',
    };
    try
    {
      Response response = await _dio.get(getMovieDetail+'/$id'+'/similar' , queryParameters:  params);
      return MovieResponse.fromjson(response.data);
    }catch(error , stackTrace)
    {
      print("Exception error: $error stackTrace: $stackTrace");
      return MovieResponse.withError('$error');
    }
  }

  Future<VideoResponse> getVideosMovies(int id)async
  {
    var params = {
      'api_key': apiKey,
      'language': 'en-US',
    };
    try
    {
      Response response = await _dio.get(getMovieDetail+'/$id'+'/videos' , queryParameters:  params);
      return VideoResponse.fromjson(response.data);
    }catch(error , stackTrace)
    {
      print("Exception error: $error stackTrace: $stackTrace");
      return VideoResponse.withError('$error');
    }
  }

  Future<SearchResponse> getSearchMovies(String text)async
  {
    var params = {
      'api_key': apiKey,
      'language': 'en-US',
      'query':text
    };
    try
    {
      Response response = await _dio.get(getSearchMovie , queryParameters:  params);
      return SearchResponse.fromjson(response.data);
    }catch(error , stackTrace)
    {
      print("Exception error: $error stackTrace: $stackTrace");
      return SearchResponse.withError('$error');
    }
  }

}