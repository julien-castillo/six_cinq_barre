import 'package:app_six_cinq_barre/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:app_six_cinq_barre/pages/home_page.dart';
import 'package:app_six_cinq_barre/pages/rehearsal_page.dart';
import 'package:app_six_cinq_barre/pages/concert_page.dart';

class NavigationWrapper extends StatefulWidget {
  final int initialIndex;
  final String musicianName;

  const NavigationWrapper({
    Key? key,
    required this.initialIndex,
    required this.musicianName,
  }) : super(key: key);

  @override
  _NavigationWrapperState createState() => _NavigationWrapperState();
}

class _NavigationWrapperState extends State<NavigationWrapper> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _setCurrentIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.cyan,
        title: [
          Text("Accueil - ${widget.musicianName}"),
          Text("Liste des Répétitions"),
          Text("Concerts"),
        ][_currentIndex],
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 1,
            color: Colors.black,
          ),
          Expanded(
            child: [
              HomePage(musicianName: widget.musicianName),
              const RehearsalPage(),
              const ConcertPage(),
            ][_currentIndex],
          ),
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: _currentIndex,
        height: 75.0,
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
        onTap: (index) => _setCurrentIndex(index),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    bool isSelected = _currentIndex == index;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 6),
        Icon(icon, size: 30, color: isSelected ? Colors.cyan : Colors.white),
        const SizedBox(height: 1),
        Text(label,
            style: TextStyle(
                color: isSelected ? Colors.black : Colors.white, fontSize: 15)),
      ],
    );
  }
}
