import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PokemonScreen(),
    );
  }
}

class PokemonScreen extends StatefulWidget {
  @override
  _PokemonScreenState createState() => _PokemonScreenState();
}

class _PokemonScreenState extends State<PokemonScreen> {
  String pokemonName = '';
  Map<String, dynamic>? pokemonData;
  String errorMessage = '';

  Future<void> searchPokemon() async {
    if (pokemonName.isNotEmpty) {
      final url = 'https://pokeapi.co/api/v2/pokemon/${pokemonName.toLowerCase()}';
      try {
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          setState(() {
            pokemonData = jsonDecode(response.body);
            errorMessage = '';
          });
        } else {
          setState(() {
            pokemonData = null;
            errorMessage = 'Pokémon no encontrado. Verifica el nombre.';
          });
        }
      } catch (e) {
        setState(() {
          pokemonData = null;
          errorMessage = 'Pokémon no encontrado. Verifica el nombre.';
        });
        print('Error al buscar Pokémon: $e');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    pokemonName = 'pikachu';
    searchPokemon();
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
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
              'Información de Pokémon',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Buscar Pokémon',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 16),
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'Nombre del Pokémon',
                            border: OutlineInputBorder(),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                          onChanged: (value) {
                            pokemonName = value;
                          },
                          controller: TextEditingController(text: pokemonName),
                        ),
                        SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: searchPokemon,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                            ),
                            child: Text('Buscar'),
                          ),
                        ),
                        SizedBox(height: 16),
                        if (pokemonData != null) ...[
                          Text(
                            _capitalize(pokemonData!['name']),
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(height: 8),
                          Image.network(
                            pokemonData!['sprites']['front_default'],
                            height: 150,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Experiencia Base: ${pokemonData!['base_experience']}',
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Habilidades:',
                            style: TextStyle(fontSize: 18),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: (pokemonData!['abilities'] as List<dynamic>)
                                .map((ability) => Padding(
                                      padding: const EdgeInsets.only(left: 16.0, top: 4.0),
                                      child: Text(
                                        '• ${_capitalize(ability['ability']['name'])}',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ))
                                .toList(),
                          ),
                        ],
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
            ),
          ),
        ],
      ),
    );
  }
}