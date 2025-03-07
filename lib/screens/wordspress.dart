import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Noticias WordPress',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NewsScreen(),
    );
  }
}

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  List<dynamic> newsPosts = [];
  bool isLoading = true;
  String errorMessage = '';
  final String logoUrl = 'assets/logoweb.png';
  final String apiUrl = 'https://www.marketinghoy.net/wp-json/wp/v2/posts?per_page=3';

  // Función para obtener las noticias
  Future<void> fetchNews() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        setState(() {
          newsPosts = jsonDecode(response.body);
          isLoading = false;
          errorMessage = '';
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Error al cargar las noticias: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error al conectar con la API: $e';
      });
      print('Error: $e');
    }
  }

  // Función para abrir enlaces
  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      print('No se pudo abrir el enlace: $url');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchNews(); // Carga las noticias al iniciar
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Noticias Marketing Hoy'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo de Marketing Hoy
              Image.asset(
                logoUrl,
                height: 80,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.error, size: 80, color: Colors.red);
                },
              ),
              SizedBox(height: 20),
              // Título de la sección
              Text(
                'Últimas Noticias',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              // Contenido dinámico
              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : errorMessage.isNotEmpty
                      ? Text(
                          errorMessage,
                          style: TextStyle(fontSize: 18, color: Colors.red),
                        )
                      : newsPosts.isEmpty
                          ? Text(
                              'No se encontraron noticias.',
                              style: TextStyle(fontSize: 18),
                            )
                          : Column(
                              children: newsPosts.map((post) {
                                return Card(
                                  elevation: 2,
                                  margin: EdgeInsets.symmetric(vertical: 8),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Titular
                                        Text(
                                          post['title']['rendered'].replaceAll(RegExp(r'<[^>]*>'), ''),
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        // Resumen
                                        Text(
                                          post['excerpt']['rendered']
                                              .replaceAll(RegExp(r'<[^>]+>'), '')
                                              .trim(),
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(fontSize: 14),
                                        ),
                                        SizedBox(height: 10),
                                        // Botón "Visitar"
                                        Align(
                                          alignment: Alignment.bottomRight,
                                          child: ElevatedButton(
                                            onPressed: () => _launchUrl(post['link']),
                                            child: Text('Visitar'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
            ],
          ),
        ),
      ),
    );
  }
}