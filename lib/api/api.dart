//esse arquivo é responsável por gerenciar os links das APIs

import 'dart:convert';
import 'package:projeto_inicial/models/genre.dart';
import 'package:projeto_inicial/widget/constants.dart';
import 'package:projeto_inicial/models/movie.dart';
import 'package:http/http.dart' as http;

// Classe que encapsula as chamadas à API para obter informações sobre filmes e artistas
class Api {
  // URLs para as diferentes chamadas à API
  static const _trendingUrl =
      'https://api.themoviedb.org/3/trending/movie/day?api_key=${Constants.apiKey}';
  static const _genreUrl =
      'https://api.themoviedb.org/3/genre/movie/list?api_key=${Constants.apiKey}';
  static const _searchUrl =
      'https://api.themoviedb.org/3/search/movie?api_key=${Constants.apiKey}&query=';

  // Obtém detalhes de um filme com base em seu ID
  Future<Map<String, dynamic>> getMovieDetails(int movieId) async {
    final apiKey = Constants.apiKey;
    final url = 'https://api.themoviedb.org/3/movie/$movieId?api_key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body);
      return decodedData;
    } else {
      throw Exception('Erro ao obter os detalhes do filme');
    }
  }

  // Obtém detalhes de um ator com base no ID do filme associado a ele
  Future<Map<String, dynamic>> getActorDetails(int movieId) async {
    final apiKey = Constants.apiKey;
    final url =
        'https://api.themoviedb.org/3/movie/$movieId/credits?api_key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body);
      return decodedData;
    } else {
      throw Exception('Erro ao obter os detalhes do filme');
    }
  }

  // Obtém uma lista de filmes populares (trending)
  Future<List<Movie>> getTrendingMovies() async {
    final response = await http.get(Uri.parse(_trendingUrl));
    if (response.statusCode == 200) {
      final decodeData = json.decode(response.body)['results'] as List;

      return decodeData.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('algo aconteceu');
    }
  }

  // Obtém uma lista de gêneros de filmes disponíveis
  Future<List<Genre>> getGenreMovies() async {
    final response = await http.get(Uri.parse(_genreUrl));
    if (response.statusCode == 200) {
      final decodeData = json.decode(response.body)['genres'] as List;
      return decodeData.map((genre) => Genre.fromJson(genre)).toList();
    } else {
      throw Exception('algo aconteceu');
    }
  }

  // Realiza uma pesquisa de filmes com base em um termo de pesquisa (query)
  Future<List<Movie>> searchMovies(String query) async {
    final response = await http.get(Uri.parse(_searchUrl + query));
    if (response.statusCode == 200) {
      final decodeData = json.decode(response.body)['results'] as List;

      return decodeData.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('Erro ao realizar a pesquisa');
    }
  }
}
