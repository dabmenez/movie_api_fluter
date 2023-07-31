//essa tela mostrará os tetalhes do filme escolhido na tela Homescreen.dart

// Importando as dependências necessárias
import 'package:flutter/material.dart';
import 'package:projeto_inicial/pages/HomeScreen.dart';
import '../models/movie.dart';
import '../api/api.dart';
import 'package:projeto_inicial/widget/constants.dart';
import 'package:intl/intl.dart';

// Classe da tela de detalhes do filme
// ignore: must_be_immutable
class MovieDetailScreen extends StatelessWidget {
  final Movie movie;
  final Api api = Api();
  final numberFormat = NumberFormat(
      "#,##0.0", "en_US"); //formatar o numero do orçamento do filme
  late Future<Map<int, String>> genreMap;
  List<String> productionCompanyNames = [];

  // Função para formatar o tempo em horas e minutos
  String formatTime(int minutes) {
    int hours = minutes ~/ 60;
    int remainingMinutes = minutes % 60;

    if (hours > 0) {
      return '${hours}h e ${remainingMinutes}min';
    } else {
      return '$remainingMinutes minutos';
    }
  }

  // Função para formatar valores com vírgulas
  String formatarValorComVirgulas(int valorDoJson) {
    final numberFormat = NumberFormat("#,##0", "en_US");
    int valor = valorDoJson;
    return numberFormat.format(valor);
  }

  // Função para carregar os dados da API, como gêneros e elenco
  Future<void> _loadData() async {
    genreMap = _loadGenreMap();
  }

  // Função para carregar o mapeamento de IDs de gêneros para seus nomes
  Future<Map<int, String>> _loadGenreMap() async {
    try {
      final genres = await Api().getGenreMovies();
      final Map<int, String> genreIdToName = {};
      for (final genre in genres) {
        genreIdToName[genre.id] = genre.name;
      }
      return genreIdToName;
    } catch (e) {
      // Lidar com erros, se necessário
      return {}; // Ou qualquer outro valor padrão
    }
  }

  // Construtor da classe, que recebe um objeto Movie como parâmetro
  MovieDetailScreen({required this.movie}) {
    genreMap = _loadGenreMap(); // Inicializa genreMap no construtor
  }

  // Método build, onde a interface da tela é construída
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Container(
        //----------------------------------------------------------------------
        //carrega as infomações de titulo, tempo de filme, nota do filme,
        //orçamento
        //---------------------------------------------------------------------
        child: SingleChildScrollView(
          child: FutureBuilder<Map<String, dynamic>>(
            future: api.getMovieDetails(movie.id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text(
                  'Erro ao carregar os detalhes do filme.',
                  style: TextStyle(color: Colors.white),
                );
              } else {
                final movieDetails = snapshot.data;
                final title = movieDetails?['title'] ?? 'N/A';
                final runtime = movieDetails?['runtime'] ?? 0;
                final voteAverage = movieDetails?['vote_average'] ?? 0.0;
                final budget = movieDetails?['budget'] ?? 0;
                final List<dynamic> productionCompaniesData =
                    movieDetails?['production_companies'];

                //--------------------------------------------------------------
                //mostra o titulo do filme
                //--------------------------------------------------------------

                return Container(
                  width: 360,
                  height: 1224,
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 360,
                          height: 303,
                          decoration: BoxDecoration(color: Color(0xFFF5F5F5)),
                        ),
                      ),
                      Positioned(
                        left: 72,
                        top: 136,
                        child: Container(
                          width: 216,
                          height: 318,
                          decoration: ShapeDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                  '${Constants.imagePath}${movie.backdropPath}'),
                              fit: BoxFit.cover,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            shadows: [
                              BoxShadow(
                                color: Color(0x3300384C),
                                blurRadius: 20,
                                offset: Offset(0, 20),
                                spreadRadius: -10,
                              )
                            ],
                          ),
                        ),
                      ),

                      //--------------------------------------------------------
                      // mostra a nota do filme
                      //--------------------------------------------------------

                      Positioned(
                        left: 0,
                        right: 0, // Ocupa toda a largura disponível
                        top:
                            486, // Define a distância vertical a partir do topo
                        child: Center(
                          child: Container(
                            width: 62,
                            height: 29,
                            child: Stack(
                              children: [
                                Positioned(
                                  left: 38,
                                  top: 9,
                                  child: Text(
                                    '/ 10',
                                    style: TextStyle(
                                      color: Color(0xFF868E96),
                                      fontSize: 14,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 0,
                                  top: 0,
                                  child: Text(
                                    '${numberFormat.format(voteAverage)}',
                                    style: TextStyle(
                                      color: Color(0xFF00384C),
                                      fontSize: 24,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      //--------------------------------------------------------
                      // mostra o titulo
                      //-------------------------------------------------------

                      Positioned(
                        left: 0,
                        right: 0, // Ocupa toda a largura disponível
                        top:
                            547, // Define a distância vertical a partir do topo
                        child: Center(
                          child: Text(
                            '${title}',
                            style: TextStyle(
                              color: Color(0xFF343A40),
                              fontSize: 14,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      //--------------------------------------------------------
                      // botão de voltar
                      //--------------------------------------------------------

                      Positioned(
                        left: 20,
                        top:
                            58, // Altere o valor aqui para ajustar a posição vertical do botão "Voltar"
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeScreen()),
                            );
                          },
                          child: Container(
                            width: 80,
                            height: 32,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  width: 0.50,
                                  color: Color(0xFFF9F9F9),
                                ),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              shadows: [
                                BoxShadow(
                                  color: Color(0x19000000),
                                  blurRadius: 10,
                                  offset: Offset(0, 10),
                                  spreadRadius: -10,
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                '< Voltar',
                                style: TextStyle(
                                  color: Color(0xFF6C7070),
                                  fontSize: 12,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      //--------------------------------------------------------
                      // informa o titlo original do filme
                      //--------------------------------------------------------

                      Center(
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: 0,
                              bottom: 50), // Ajuste o valor conforme necessário
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'original title: ',
                                style: TextStyle(
                                  color: Color(0xFF5E6770),
                                  fontSize: 10,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                '${movie.originalTitle}',
                                style: TextStyle(
                                  color: Color(0xFF5E6770),
                                  fontSize: 10,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      //--------------------------------------------------------
                      //mostra as informações de duração e ano
                      //--------------------------------------------------------

                      Positioned(
                        left: 44,
                        top: 620,
                        child: Container(
                          width: 98,
                          height: 35,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 0,
                                top: 0,
                                child: Container(
                                  width: 98,
                                  height: 35,
                                  decoration: ShapeDecoration(
                                    color: Color(0xFFF1F3F5),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 16,
                                top: 8,
                                child: Container(
                                  width: 66,
                                  height: 17,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        left: 34,
                                        top: 0,
                                        child: Text(
                                          '${movie.releaseDate.year}',
                                          style: TextStyle(
                                            color: Color(0xFF343A40),
                                            fontSize: 14,
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 0,
                                        top: 1,
                                        child: Text(
                                          'Ano:',
                                          style: TextStyle(
                                            color: Color(0xFF868E96),
                                            fontSize: 12,
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 154,
                        top: 620,
                        child: Container(
                          width: 163,
                          height: 35,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 0,
                                top: 0,
                                child: Container(
                                  width: 163,
                                  height: 35,
                                  decoration: ShapeDecoration(
                                    color: Color(0xFFF1F3F5),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 16,
                                top: 8,
                                child: Container(
                                  width: 131,
                                  height: 17,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        left: 62,
                                        top: 0,
                                        child: Text(
                                          '${formatTime(runtime)}',
                                          style: TextStyle(
                                            color: Color(0xFF343A40),
                                            fontSize: 14,
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 0,
                                        top: 1,
                                        child: Text(
                                          'Duração:',
                                          style: TextStyle(
                                            color: Color(0xFF868E96),
                                            fontSize: 12,
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      //--------------------------------------------------------
                      //carrega as informações de genero dos filmes
                      //--------------------------------------------------------

                      Positioned(
                        left: 59,
                        top: 667,
                        child: Container(
                          width: 243,
                          height: 30,
                          child: FutureBuilder<Map<int, String>>(
                            future:
                                genreMap, // Supondo que genreMap é o Future<Map<int, String>> que mapeia IDs para nomes de gêneros
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Center(
                                    child:
                                        Text('Erro ao carregar os gêneros.'));
                              } else {
                                final genreMapData = snapshot.data ?? {};
                                final genreNames = movie.genreIds
                                    .map((genreId) =>
                                        genreMapData[genreId] ??
                                        'Unknown Genre')
                                    .toList();

                                //----------------------------------------------
                                //mostra as informações de generos de filmes
                                //----------------------------------------------

                                return SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: genreNames
                                        .map(
                                          (genre) => Padding(
                                            padding:
                                                EdgeInsets.only(right: 8.0),
                                            child: Container(
                                              width: 70,
                                              height: 30,
                                              decoration: ShapeDecoration(
                                                shape: RoundedRectangleBorder(
                                                  side: BorderSide(
                                                    width: 0.50,
                                                    strokeAlign: BorderSide
                                                        .strokeAlignCenter,
                                                    color: Color(0xFFE9ECEF),
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  genre,
                                                  style: TextStyle(
                                                    color: Color(0xFF5E6770),
                                                    fontSize: 14,
                                                    fontFamily: 'Montserrat',
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ),

                      //----------------------------------------------------------
                      //mostra as informações de descrição, produtora e orçamento
                      //----------------------------------------------------------

                      Positioned(
                        left: 20,
                        top: 735,
                        child: Text(
                          'Descrição',
                          style: TextStyle(
                            color: Color(0xFF5E6770),
                            fontSize: 14,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 20,
                        top: 760,
                        child: SizedBox(
                          width: 320,
                          child: Text(
                            '${movie.overview}',
                            style: TextStyle(
                              color: Color(0xFF343A40),
                              fontSize: 12,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 20,
                        top: 893,
                        child: Container(
                          width: 320,
                          height: 35,
                          decoration: ShapeDecoration(
                            color: Color(0xFFF1F3F5),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 20,
                        top: 932,
                        child: Container(
                          width: 320,
                          height: 35,
                          decoration: ShapeDecoration(
                            color: Color(0xFFF1F3F5),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 128,
                        top: 901,
                        child: Text(
                          '\$ ${formatarValorComVirgulas(budget)}',
                          style: TextStyle(
                            color: Color(0xFF343A40),
                            fontSize: 14,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 135,
                        top: 940,
                        child: Text(
                          '${productionCompaniesData[0]['name']}',
                          style: TextStyle(
                            color: Color(0xFF343A40),
                            fontSize: 12,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 36,
                        top: 902,
                        child: Text(
                          'ORÇAMENTO:',
                          style: TextStyle(
                            color: Color(0xFF868E96),
                            fontSize: 12,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 36,
                        top: 941,
                        child: Text(
                          'PRODUTORAS: ',
                          style: TextStyle(
                            color: Color(0xFF868E96),
                            fontSize: 12,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      //--------------------------------------------------------
                      //carrega as informações de elenco e diretor
                      //--------------------------------------------------------

                      Positioned(
                        left: 26,
                        top: 1020,
                        child: Container(
                          width: 253,
                          height: 300,
                          child: FutureBuilder<Map<String, dynamic>>(
                            future: Api().getActorDetails(movie.id),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text(
                                  'Erro ao carregar os detalhes do filme.',
                                  style: TextStyle(color: Colors.white),
                                );
                              } else {
                                final actorDetails = snapshot.data;
                                final castList =
                                    actorDetails?['cast'] as List<dynamic>?;
                                final crewList =
                                    actorDetails?['crew'] as List<dynamic>?;

                                String getDirectorName() {
                                  final director = crewList?.firstWhere(
                                    (item) => item['job'] == 'Director',
                                    orElse: () => null,
                                  );
                                  return director != null
                                      ? director['name'] ?? 'N/A'
                                      : 'N/A';
                                }

                                List<String> getActorsNames() {
                                  if (castList == null || castList.isEmpty) {
                                    return ['N/A'];
                                  }

                                  final actors = castList
                                      .where((item) =>
                                          item['known_for_department'] ==
                                          'Acting')
                                      .take(5) // Limita o número de atores a 3
                                      .map((actor) => actor['name'] as String)
                                      .toList();

                                  while (actors.length < 3) {
                                    actors.add('N/A');
                                  }

                                  return actors;
                                }

                                //----------------------------------------------
                                //mostra informações de diretor e elenco
                                //----------------------------------------------

                                return SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Diretor',
                                              style: TextStyle(
                                                color: Color(0xFF5E6770),
                                                fontSize: 14,
                                                fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            SizedBox(
                                              width: 316,
                                              child: Text(
                                                '${getDirectorName()}',
                                                style: TextStyle(
                                                  color: Color(0xFF343A40),
                                                  fontSize: 12,
                                                  fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 20),
                                            Text(
                                              'Elenco',
                                              style: TextStyle(
                                                color: Color(0xFF5E6770),
                                                fontSize: 14,
                                                fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            SizedBox(
                                              width: 320,
                                              child: Text(
                                                'Elenco: ${getActorsNames().join(', ')} ',
                                                style: TextStyle(
                                                  color: Color(0xFF343A40),
                                                  fontSize: 12,
                                                  fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
