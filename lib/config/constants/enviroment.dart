import 'package:flutter_dotenv/flutter_dotenv.dart';

class Enviroment{
  static String theMovieDbKey = dotenv.env['THE_MOVIEDB-KEY'] ?? 'No hay api key';
}