

import 'package:cinemapedia/infrastructure/datasource/moviedb_datasource.dart';
import 'package:cinemapedia/infrastructure/repositories/movie_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


//este repositorio es inmutable 

final movieRepositoryProvider = Provider((ref) {
  return MoviesRepositoryImpl(MoviedbDatasource());
});
