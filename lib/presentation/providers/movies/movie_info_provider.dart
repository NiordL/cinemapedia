import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import '../../../domain/entities/movie.dart';


final movieInfoProvider = StateNotifierProvider<MovieMapNotifier, Map<String, Movie>>((ref){

  final movieRepository = ref.watch(movieRepositoryProvider);
  return MovieMapNotifier(getMovie: movieRepository.getMovieById);
});

typedef GetMovieCalBack = Future<Movie>Function(String movieId);

class MovieMapNotifier extends StateNotifier<Map<String,Movie>>{

  final GetMovieCalBack getMovie;

  MovieMapNotifier({
    required this.getMovie,
  }):super({});

  Future<void> loadMovie(String movieId) async{
    if (state [movieId] != null) return;

    final movie = await getMovie(movieId);

    state = {...state, movieId: movie}; 
  }
}