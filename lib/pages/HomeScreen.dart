//tela inicial do app, onde estará o titulo 'FILMES" a barra de pesquisa, os generos de pesquisa e
//as thumbnails do filme junto com o nome do filme e 2 generos

// Importando as dependências necessárias
import 'package:flutter/material.dart'; // Importa o pacote de widgets do Flutter
import '../api/api.dart'; // Importa a classe Api que contém as chamadas à API
import '../models/movie.dart'; // Importa o modelo de dados Movie
import '../widget/constants.dart'; // Importa as constantes utilizadas no projeto
import 'MovieDetailScreen.dart'; // Importa a tela de detalhes do filme (MovieDetailScreen)

// Classe HomeScreen que define a tela inicial do aplicativo
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// Classe _HomeScreenState que define o estado da tela inicial
class _HomeScreenState extends State<HomeScreen> {
  // Variáveis para armazenar as listas de filmes em destaque e o mapa de gêneros
  late Future<List<Movie>> trendingMovies;
  late Future<Map<int, String>> genreMap;
  List<Movie> _filteredMovies =
      []; // Lista de filmes filtrada com base na pesquisa
  final TextEditingController _searchController =
      TextEditingController(); // Controlador para a caixa de pesquisa

  @override
  void initState() {
    super.initState();
    _loadData(); // Carrega os dados iniciais
  }

  // Função para carregar os dados iniciais (filmes em destaque e mapa de gêneros)
  Future<void> _loadData() async {
    trendingMovies = Api().getTrendingMovies();
    genreMap = _loadGenreMap();
  }

  // Função para carregar o mapa de gêneros a partir das informações da API
  Future<Map<int, String>> _loadGenreMap() async {
    try {
      final genres = await Api().getGenreMovies();
      final Map<int, String> genreIdToName = {};
      for (final genre in genres) {
        genreIdToName[genre.id] = genre.name;
      }
      return genreIdToName;
    } catch (e) {
      return {};
    }
  }

  // Função para filtrar a lista de filmes com base ne pesquisa (query)
  void _filterMovies(String query) {
    trendingMovies.then((movies) {
      setState(() {
        if (query.isEmpty) {
          _filteredMovies = [];
        } else {
          _filteredMovies = movies
              .where((movie) =>
                  movie.title.toLowerCase().contains(query.toLowerCase()))
              .toList();
        }
      });
    });
  }

  // Função para filtrar a lista de filmes com base no ID do gênero selecionado
  void _filterByGenre(int genreId) {
    trendingMovies.then((movies) {
      setState(() {
        _filteredMovies =
            movies.where((movie) => movie.genreIds.contains(genreId)).toList();
      });
    });
  }

  //--------------------------------------------------------------------------
  // Método build, onde a interface da tela é construída
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null, // Remove a barra de AppBar da tela
      body: SingleChildScrollView(
        child: Column(
          children: [
            //titulo Filmes
            Container(
              padding: EdgeInsets.only(top: 16.0, left: 0.0, right: 250.0),
              child: Text(
                'Filmes',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                    color: Colors.black),
              ),
            ),

            //------------------------------------------------------------------
            // Barra de pesquisa
            //------------------------------------------------------------------

            Padding(
              padding: EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(20.0),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Pesquisar filmes...',
                    hintStyle: TextStyle(color: Colors.black),
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.black,
                    ),
                  ),
                  style: TextStyle(color: Colors.black),
                  onChanged: (value) {
                    _filterMovies(
                        value); // Chama a função de filtrar filmes quando o texto da caixa de pesquisa é alterado
                  },
                ),
              ),
            ),

            //------------------------------------------------------------------
            // Builder para adquirir as informações de genero de filme
            //------------------------------------------------------------------

            FutureBuilder<Map<int, String>>(
              future: genreMap,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error loading genres');
                } else {
                  final genreMapData = snapshot.data ?? {};
                  final genres = genreMapData.keys.toList();

                  return SizedBox(
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: genres.length,
                      itemBuilder: (context, index) {
                        final genreId = genres[index];
                        final genreName = genreMapData[genreId] ?? '';
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 4.0,
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              _filterByGenre(
                                  genreId); // Chama a função para filtrar por gênero quando um botão é pressionado
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.blueGrey,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text(
                              genreName,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
            SizedBox(height: 10),

            //------------------------------------------------------------------
            // builder para adquirir a lista de cartões de filmes em destaque
            //------------------------------------------------------------------

            FutureBuilder<List<Movie>>(
              future: trendingMovies,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error loading movies');
                } else {
                  final movies = _filteredMovies.isNotEmpty
                      ? _filteredMovies
                      : snapshot.data ?? [];

                  return Column(
                    children: movies.map((movie) {
                      return GestureDetector(
                        onTap: () {
                          // Navegar para a tela de detalhes do filme ao clicar em um filme
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  MovieDetailScreen(movie: movie),
                            ),
                          );
                        },
                        //------------------------------------------------------
                        // thumbnail do filme
                        //------------------------------------------------------
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Stack(
                                  children: [
                                    SizedBox(
                                      height: 380,
                                      width: 250,
                                      child: Image.network(
                                        '${Constants.imagePath}${movie.backdropPath}',
                                        filterQuality: FilterQuality.high,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Container(
                                      height: 380,
                                      width: 250,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        gradient: LinearGradient(
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter,
                                          colors: [
                                            Colors.black.withOpacity(0.8),
                                            Colors.transparent,
                                          ],
                                        ),
                                      ),
                                    ),

                                    //titulo do filme
                                    Positioned(
                                      bottom: 8,
                                      left: 8,
                                      right: 8,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            movie.title,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),

                                          //genero do filme
                                          FutureBuilder<Map<int, String>>(
                                            future: genreMap,
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return Text(
                                                    'Loading genres...');
                                              } else if (snapshot.hasError) {
                                                return Text(
                                                    'Error loading genres');
                                              } else {
                                                final genreMapData =
                                                    snapshot.data ?? {};
                                                final genreNames = movie
                                                    .genreIds
                                                    .map((genreId) =>
                                                        genreMapData[genreId] ??
                                                        'Unknown Genre')
                                                    .take(2)
                                                    .toList();
                                                final movieGenres =
                                                    genreNames.join('-');
                                                return Text(
                                                  movieGenres,
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                );
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
