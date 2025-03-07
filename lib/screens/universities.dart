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
      home: UniversitiesScreen(),
    );
  }
}

class UniversitiesScreen extends StatefulWidget {
  @override
  _UniversitiesScreenState createState() => _UniversitiesScreenState();
}

class _UniversitiesScreenState extends State<UniversitiesScreen> {
  String country = '';
  List<dynamic> universities = [];
  String errorMessage = '';

  Future<void> searchUniversities() async {
    if (country.isNotEmpty) {
      final formattedCountry = country[0].toUpperCase() + country.substring(1).toLowerCase();
      try {
        final response = await http.get(
          Uri.parse('http://universities.hipolabs.com/search?country=${Uri.encodeComponent(formattedCountry)}'),
        );
        if (response.statusCode == 200) {
          setState(() {
            universities = jsonDecode(response.body);
            errorMessage = universities.isEmpty ? 'No se encontraron universidades' : '';
          });
        } else {
          setState(() {
            universities = [];
            errorMessage = 'Error al buscar universidades';
          });
        }
      } catch (e) {
        setState(() {
          universities = [];
          errorMessage = 'Error al buscar universidades';
        });
        print('Error al buscar universidades: $e');
      }
    }
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      print('No se pudo abrir el enlace: $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.0),
            color: Colors.grey[200],
            child: Text(
              'Universidades por País',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Card(
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Buscar Universidades',
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 16),
                            TextField(
                              decoration: InputDecoration(
                                labelText: 'Nombre del País (en inglés)',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) {
                                country = value;
                              },
                            ),
                            SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: searchUniversities,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                ),
                                child: Text('Buscar'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    if (universities.isNotEmpty)
                      ...universities.map((uni) => Card(
                            elevation: 4,
                            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    uni['name'],
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 8),
                                  Text('Dominio: ${uni['domains'][0]}'),
                                  SizedBox(height: 8),
                                  GestureDetector(
                                    onTap: () => _launchUrl(uni['web_pages'][0]),
                                    child: Text(
                                      uni['web_pages'][0],
                                      style: TextStyle(
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )),
                    if (errorMessage.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Text(
                          errorMessage,
                          style: TextStyle(fontSize: 18, color: Colors.red),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}