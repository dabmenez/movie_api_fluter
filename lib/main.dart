// Importando as dependências necessárias
import 'package:projeto_inicial/pages/HomeScreen.dart'; // Importa a página inicial (HomeScreen)
import 'package:flutter/material.dart'; // Importa o pacote de widgets do Flutter

// Função principal que inicia o aplicativo
void main() {
  runApp(const MyApp()); // Executa a classe MyApp para iniciar o aplicativo
}

// Classe MyApp que define o aplicativo principal
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:
          false, // Remove o banner "Debug" no canto superior direito
      title: 'App inicial', // Define o título do aplicativo
      theme: ThemeData.dark().copyWith(
        // Define o tema do aplicativo como tema escuro
        scaffoldBackgroundColor: Color.fromARGB(
            255, 255, 255, 255), // Define a cor de fundo da tela principal
        useMaterial3:
            true, // Habilita o uso do Material Design 3.0 (se disponível)
      ),
      home:
          const HomeScreen(), // Define a página inicial do aplicativo como HomeScreen
    );
  }
}
