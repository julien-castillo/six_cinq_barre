import 'package:six_cinq_barre/pages/concert_page.dart';
import 'package:six_cinq_barre/pages/event_page.dart';
import 'package:flutter/material.dart';
import 'pages/home_page.dart';

// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'dart:async';
// import 'dart:math';
// import 'package:asynconf/pages/gsheet_crud.dart';
import 'package:six_cinq_barre/gsheet_setup.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
// );

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

  setCurrentIndex(int index) {
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
          title: const [
            Text("Accueil"),
            Text("Liste des Répétitions"),
            Text("Concerts"),
          ][_currentIndex],
        ),
        body: [
          const HomePage(),
          const EventPage(),
          const ConcertPage(),
        ][_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setCurrentIndex(index),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color.fromARGB(255, 223, 149, 12),
          unselectedItemColor: Colors.grey,
          iconSize: 32,
          elevation: 20,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Accueil',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.sports_bar),
              label: 'Répétitions',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.music_note),
              label: 'Concerts',
            ),
          ],
        ),
      ),
    );
  }
}
