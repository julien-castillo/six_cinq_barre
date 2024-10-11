import 'package:app_six_cinq_barre/pages/concert_page.dart';
import 'package:app_six_cinq_barre/pages/rehearsal_page.dart';
import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'dart:async';
import 'package:app_six_cinq_barre/gsheet_setup.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await gSheetInit();
  await initializeDateFormatting('fr_FR', null);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;

  void setCurrentIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.cyan,
          title: const [
            Text("Accueil"),
            Text("Liste des Répétitions"),
            Text("Concerts"),
          ][_currentIndex],
        ),
        body: Column(
          children: [
            // Ligne de séparation
            Container(
              height: 1, // Hauteur de la ligne
              color: Colors.black, // Couleur de la ligne
            ),
            Expanded(
              child: [
                const HomePage(),
                const RehearsalPage(),
                const ConcertPage(),
              ][_currentIndex],
            ),
          ],
        ),
        bottomNavigationBar: CurvedNavigationBar(
          index: _currentIndex,
          height: 60.0,
          items: <Widget>[
            _buildNavItem(Icons.home, 'Accueil', 0),
            _buildNavItem(Icons.sports_bar, 'Répétitions', 1),
            _buildNavItem(Icons.music_note, 'Concerts', 2),
          ],
          color: Colors.cyan,
          buttonBackgroundColor: Colors.white,
          backgroundColor: Colors.transparent,
          animationCurve: Curves.easeInOut,
          animationDuration: const Duration(milliseconds: 300),
          onTap: (index) => setCurrentIndex(index),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    bool isSelected = _currentIndex == index;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 6), // Espacement entre l'icône et le haut de la CurvedNavigationBar
        Icon(icon, size: 30, color: isSelected ? Colors.black : Colors.white),
        const SizedBox(height: 1), // Espacement entre l'icône et le texte
        Text(label, style: TextStyle(color: isSelected ? Colors.black : Colors.white)),
      ],
    );
  }
}
