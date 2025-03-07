import 'package:flutter/material.dart';
import 'screens/gender.dart';
import 'screens/age.dart';
import 'screens/universities.dart';
import 'screens/home.dart';
import 'screens/weather.dart';
import 'screens/pokemon.dart';
import 'screens/about.dart';
import 'screens/wordspress.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mi app',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    home(),
    GenderPredictionScreen(),
    AgePredictionScreen(),
    UniversitiesScreen(),
    WeatherScreen(),
    PokemonScreen(),
    NewsScreen(),
    AboutScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context); // Close the drawer after selection

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu'),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menú',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              selected: _selectedIndex == 0,
              onTap: () => _onItemTapped(0),
            ),
            ListTile(
              leading: Icon(Icons.person_outline),
              title: Text('Genero'),
              selected: _selectedIndex == 1,
              onTap: () => _onItemTapped(1),
            ),
            ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text('Edad'),
              selected: _selectedIndex == 2,
              onTap: () => _onItemTapped(2),
            ),
                        ListTile(
              leading: Icon(Icons.school),
              title: Text('Universidades'),
              selected: _selectedIndex == 3,
              onTap: () => _onItemTapped(3),
            ),

            ListTile(
              leading: Icon(Icons.wb_sunny),
              title: Text('Clima'),
              selected: _selectedIndex == 4,
              onTap: () => _onItemTapped(4),
            ),
            ListTile(
              leading: Icon(Icons.catching_pokemon),
              title: Text('Pokemon'),
              selected: _selectedIndex == 5,
              onTap: () => _onItemTapped(5),
            ),
            ListTile(
              leading: Icon(Icons.newspaper),
              title: Text('Noticias'),
              selected: _selectedIndex == 6,
              onTap: () => _onItemTapped(6),
            ),
            ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('Acerca de mi'),
              selected: _selectedIndex == 7,
              onTap: () => _onItemTapped(7),
            ),
          ],
        ),
      ),
    );
  }
}