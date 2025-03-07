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
      home: AgePredictionScreen(),
    );
  }
}

class AgePredictionScreen extends StatefulWidget {
  @override
  _AgePredictionScreenState createState() => _AgePredictionScreenState();
}

class _AgePredictionScreenState extends State<AgePredictionScreen> {
  String name = '';
  int? age;
  String ageCategory = '';
  String ageImage = '';

  Future<void> predictAge() async {
    if (name.isNotEmpty) {
      try {
        final response = await http.get(Uri.parse('https://api.agify.io/?name=$name'));
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          setState(() {
            age = data['age'];
            if (age != null) {
              if (age! < 30) {
                ageCategory = 'Joven';
                ageImage = 'https://i.pinimg.com/1200x/6c/50/fe/6c50fedcbd921cb0990e1abdc9c971d7.jpg';
              } else if (age! < 60) {
                ageCategory = 'Adulto';
                ageImage = 'https://us.123rf.com/450wm/djvstock/djvstock1706/djvstock170612021/80777886-adulto-cara-icono-de-dibujos-animados-ilustraci%C3%B3n-vectorial-dise%C3%B1o-gr%C3%A1fico.jpg';
              } else {
                ageCategory = 'Anciano';
                ageImage = 'https://st4.depositphotos.com/1967477/25828/v/950/depositphotos_258283142-stock-illustration-vector-illustration-cartoon-senior-elderly.jpg';
              }
            }
          });
        } else {
          setState(() {
            age = null;
            ageCategory = 'Error al predecir';
            ageImage = '';
          });
        }
      } catch (e) {
        setState(() {
          age = null;
          ageCategory = 'Error al predecir';
          ageImage = '';
        });
        print('Error al predecir edad: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Predice tu Edad',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Ingresa tu nombre y descubre tu predicción',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Nombre',
                      hintText: 'Escribe tu nombre',
                      border: OutlineInputBorder(),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    onChanged: (value) {
                      setState(() {
                        name = value;
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.analytics_outlined),
                      label: Text('Predecir Edad'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: name.isEmpty ? null : predictAge,
                    ),
                  ),
                  SizedBox(height: 16),
                  if (age != null || ageCategory == 'Error al predecir')
                    Card(
                      color: Colors.grey[100],
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                              ageCategory,
                              style: TextStyle(fontSize: 24),
                              textAlign: TextAlign.center,
                            ),
                            if (age != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  'Edad predicha: $age años',
                                  style: TextStyle(fontSize: 20),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            if (ageImage.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Image.network(
                                  ageImage,
                                  height: 150,
                                  fit: BoxFit.cover,
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