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
      home: GenderPredictionScreen(),
    );
  }
}

class GenderPredictionScreen extends StatefulWidget {
  @override
  _GenderPredictionScreenState createState() => _GenderPredictionScreenState();
}

class _GenderPredictionScreenState extends State<GenderPredictionScreen> {
  String name = '';
  String gender = '';
  Color backgroundColor = Colors.white;

  Future<void> predictGender() async {
    if (name.isNotEmpty) {
      try {
        final response = await http.get(Uri.parse('https://api.genderize.io/?name=$name'));
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          setState(() {
            gender = data['gender'] ?? 'Desconocido';
            backgroundColor = gender == 'male' ? Colors.blue : Colors.pink;
          });
        } else {
          setState(() {
            gender = 'Error al predecir';
            backgroundColor = Colors.grey;
          });
        }
      } catch (e) {
        setState(() {
          gender = 'Error al predecir';
          backgroundColor = Colors.grey;
        });
        print('Error al predecir género: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: backgroundColor,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.0),
              color: Colors.grey[200],
              child: Text(
                'Predicción de Género',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
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
                          'Predice tu Género',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 16),
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'Nombre',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            name = value;
                          },
                        ),
                        SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: predictGender,
                            child: Text('Predecir'),
                          ),
                        ),
                        SizedBox(height: 16),
                        if (gender.isNotEmpty)
                          Text(
                            'Género predicho: $gender',
                            style: TextStyle(fontSize: 20),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text('Menú', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              title: Text('Opción 1'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}