import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AboutScreen(),
    );
  }
}

class AboutScreen extends StatelessWidget {
  final String correo = 'darlinnieve4@gmail.com';
  final String matricula = '2021-2292';
  final String numero = '8094990201';
  final String nombre = 'Darlin de la Nieve';
  final String photoUrl = 'assets/darlin.jpg';

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
              'Acerca de mí',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Información Personal',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 16),
                        Image.asset(
                          photoUrl,
                          width: double.infinity,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Text('Error al cargar la imagen');
                          },
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Nombre: $nombre',
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          'Matricula: $matricula',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Correo: $correo',
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          'Telefono: $numero',
                          style: TextStyle(fontSize: 18),
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