import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/movie.dart';


typedef SearchMoviesCallback = Future<List<Movie>> Function(String query);


class SearchMovieDelegate extends SearchDelegate<Movie?>{

  final SearchMoviesCallback searchMovies;
  StreamController<List<Movie>> debounceMovies = StreamController.broadcast();
  Timer? _debouncerTimer;

  SearchMovieDelegate({
    required this.searchMovies,
  });

  void _onQueryChanged( String query) {
    
    if (_debouncerTimer?.isActive ?? false) _debouncerTimer!.cancel();

    _debouncerTimer = Timer (const Duration(milliseconds: 500), () {
      print('Buscando películas');
    });
  }

  @override
  String get searchFieldLabel => 'Buscar película';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return[
      //if(query.isNotEmpty)
        FadeIn(
          animate: query.isNotEmpty,
          duration: const Duration(milliseconds: 200),
          child: IconButton(
            onPressed: () => query = '',
            icon: const Icon(Icons.clear)
          ),
        )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null), icon: Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return const Text('BuildResults');

  }

  @override
  Widget buildSuggestions(BuildContext context) {
    _onQueryChanged(query);

    return StreamBuilder(
      stream: debounceMovies.stream,
      builder: (context, snapshot){

        final movies = snapshot.data ?? [];

        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) => _MovieItem(
            movie: movies[index],
            onMovieSelected: close,),
        );
      } ,
    );

  }

}


class _MovieItem extends StatelessWidget {

  final Movie movie;
  final Function onMovieSelected;

  const _MovieItem({
    required this.movie,
    required this.onMovieSelected
  });

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        onMovieSelected(context, movie);
      } ,
      child: Padding(
        padding:EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(children: [
          //image
          SizedBox(
            width: size.width * 0.2,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                movie.posterPath,
                loadingBuilder: (context, child, loadingProgress) => FadeIn(child: child),
              ),),
          ),
      
          SizedBox(width: 10,),
          SizedBox(
            width: size.width * 0.7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(movie.title, style: textStyles.titleMedium,),
      
                (movie.overview.length > 100)
                  ? Text ('${movie.overview.substring(0,100)}...')
                  :Text(movie.overview),
      
                Row(
                  children: [
                    Icon(Icons.star_half_rounded, color: Colors.yellow.shade800,),
                    const SizedBox( width: 5,),
                    Text( 
                      HumanFormats.number(movie.voteAverage, 1),
                      style: textStyles.bodyMedium!.copyWith(color: Colors.yellow.shade800),
                      )
                  ],
                )
              ],),
          )
      
          //description
        ],), 
      ),
    );
  }
}