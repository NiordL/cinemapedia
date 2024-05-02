
import 'package:cinemapedia/presentation/views/views.dart';
import 'package:go_router/go_router.dart';

import 'package:cinemapedia/presentation/screens/screens.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    // IMPLEMENTAR
    //StatefulShellRoute(branches: branches, navigatorContainerBuilder: navigatorContainerBuilder)
    ShellRoute(
      builder: (context, state, child) {
        return HomeScreen(childView: child);
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) {
            return const HomeView();
          },
          routes: [
                GoRoute(
                  path: 'movie/:id',
                  name: MovieScreen.name,
                  builder: (context, state) {
                    final movieId = state.pathParameters['id'] ?? 'no-id';

                  return MovieScreen(movieId: movieId,);
                  },
                ),
              ]
            ),
        GoRoute(
          path: '/favorites',
          builder: (context, state) {
            return const FavouritesView();
          } 
        ),
      ]
    )
    

    /*rutas Padre/hijo
    
      ]
    ),
    */



  ]
);