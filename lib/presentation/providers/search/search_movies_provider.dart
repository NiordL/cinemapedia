


import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/repositories/movies_repository.dart';
import 'package:cinemapedia/presentation/delegates/search_movie_delegate.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');



final searchedMoviesProvider = StateNotifierProvider<SearchMoviesNotifier, List<Movie>>((ref) {

  final moviesRepository = ref.read(movieRepositoryProvider);

  return SearchMoviesNotifier(
    searchMovies: moviesRepository.searchMovies,
    ref: ref
  );
});

typedef SearchMoviesCallback = Future<List<Movie>> Function(String query);

class SearchMoviesNotifier extends StateNotifier<List<Movie>> {

  final SearchMoviesCallback searchMovies;

  final Ref ref;



  SearchMoviesNotifier({
    required this.ref,
    required this.searchMovies,
  }): super([]);


  Future<List<Movie>> searchMoviesByQuery(String query) async {

    final List<Movie> movies = await searchMovies(query);
    ref.read(searchQueryProvider.notifier).update((state) => query);

    state = movies;

    return movies;
  }


}




















