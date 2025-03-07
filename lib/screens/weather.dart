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
      home: WeatherScreen(),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  String city = 'Santo Domingo'; 
  Map<String, dynamic>? weatherData;
  String errorMessage = '';
  final String apiKey = 'a3f94f72e38f0100d2a3135077d7ceff'; 

 
  Future<void> getWeather() async {
    final url =
        'http://api.openweathermap.org/data/2.5/weather?q=$city,DO&appid=$apiKey&units=metric&lang=es';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          weatherData = jsonDecode(response.body);
          errorMessage = '';
        });
      } else {
        setState(() {
          weatherData = null;
          errorMessage = 'No se pudo obtener el clima. Verifica la ciudad o la conexión.';
        });
      }
    } catch (e) {
      setState(() {
        weatherData = null;
        errorMessage = 'No se pudo obtener el clima. Verifica la ciudad o la conexión.';
      });
      print('Error al obtener el clima: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    getWeather(); 
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
              'Clima en RD',
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
                          'Clima Actual',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 16),
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'Ciudad',
                            border: OutlineInputBorder(),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                          onChanged: (value) {
                            city = value; 
                          },
                          controller: TextEditingController(text: city), 
                        ),
                        SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: getWeather,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue, 
                            ),
                            child: Text('Actualizar Clima'),
                          ),
                        ),
                        SizedBox(height: 16),
                        if (weatherData != null) ...[
                          Text(
                            '${weatherData!['name']}, República Dominicana',
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(height: 8),
                          Text('Temperatura: ${weatherData!['main']['temp']} °C'),
                          Text('Descripción: ${weatherData!['weather'][0]['description']}'),
                          Text('Humedad: ${weatherData!['main']['humidity']}%'),
                          Text('Viento: ${weatherData!['wind']['speed']} m/s'),
                          SizedBox(height: 8),
                          Image.network(
                            'http://openweathermap.org/img/wn/${weatherData!['weather'][0]['icon']}@2x.png',
                            height: 100,
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
