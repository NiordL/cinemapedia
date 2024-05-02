import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/movie.dart';


typedef SearchMoviesCallback = Future<List<Movie>> Function(String query);


class SearchMovieDelegate extends SearchDelegate<Movie?>{

  final SearchMoviesCallback searchMovies;
  List<Movie> initialmovies;

  StreamController<List<Movie>> debounceMovies = StreamController.broadcast();
  StreamController<bool> isLoadingStream = StreamController.broadcast();



  Timer? _debouncerTimer;

  SearchMovieDelegate( {
    required this.initialmovies,
    required this.searchMovies,
  }):super(
    searchFieldLabel: 'Buscar películas',
    //textInputAction: TextInputAction.done,
  );

  void clearStreams(){
    debounceMovies.close();
  }

  void _onQueryChanged( String query) {
    isLoadingStream.add(true);
    
    if (_debouncerTimer?.isActive ?? false) _debouncerTimer!.cancel();

    _debouncerTimer = Timer (const Duration(milliseconds: 500), () async {
      if ( query.isEmpty) {
        debounceMovies.add([ ]);
        return;
      }
      final movies = await searchMovies( query );
      initialmovies = movies;

      debounceMovies.add(movies);
      isLoadingStream.add(false);
    });
  }


  Widget buildresultsAndSuggestions() {
    return StreamBuilder(
      initialData: initialmovies,
      stream: debounceMovies.stream,
      builder: (context, snapshot){

        final movies = snapshot.data ?? [];
        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) => _MovieItem(
            movie: movies[index],
            onMovieSelected: (context, movie) {
              clearStreams();
              close(context, movie);
            }
          ),
        );
      } ,
    );

  }


  //@override
  //String get searchFieldLabel => 'Buscar película';

  @override
  List<Widget>? buildActions(BuildContext context) {
        
    return[
      StreamBuilder(
        initialData: false,
        stream: isLoadingStream.stream,
        builder: (context, snapshot) {
          if (snapshot.data ?? false) {
            return SpinPerfect(
              duration: const Duration(seconds:  2),
              infinite: true,
              child: IconButton(
                onPressed: () => query = '',
                icon: const Icon(Icons.refresh_rounded)
              ),
            );
          }
            return FadeIn(
              animate: query.isNotEmpty,
              duration: const Duration(milliseconds: 200),
              child: IconButton(
                onPressed: () => query = '',
                icon: const Icon(Icons.clear)
              ),
            );
        }
      ),        
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          clearStreams();
          close(context, null);
      },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    
    return buildresultsAndSuggestions();

  }

  @override
  Widget buildSuggestions(BuildContext context) {
    _onQueryChanged(query);
    return buildresultsAndSuggestions();

    

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
        padding:const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
      
          const SizedBox(width: 10,),
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