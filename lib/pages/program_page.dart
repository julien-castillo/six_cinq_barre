import 'package:flutter/material.dart';
import 'package:app_six_cinq_barre/main.dart';

class ProgramPage extends StatelessWidget {
  const ProgramPage({super.key});

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.cyan,
        title: const Text('Programme')
        ),
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildGlassmorphicRectangle1(
              context,
              Icons.theater_comedy,
              "Carmen, Georges Bizet",
              "- Version concert - ",
              "Opéra-comique en 4 actes de Georges Bizet, livret d'Henri Meilhac et Ludovic Halévy. Création le 3 mars 1875. ",
            ),
            const SizedBox(height: 20),
            _buildGlassmorphicRectangle2(
              context,
              Icons.queue_music,
              "Musique de chambre",
              "Différentes oeuvres de musique de chambre seront interprétées :",
              "Trio d'anches, quatuors, quintette, nonette, dextuor...",
            ),
          ],
        ),
      ),
      floatingActionButton: GestureDetector(
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MyApp()),
          );
        },
        child: _buildGlassmorphicButton(context, Icons.home, 'Accueil'),
      ),
    );
  }

  Widget _buildGlassmorphicRectangle1(BuildContext context, IconData icon, String title, String subtitle, String text) {
  return Container(
    width: 340,
    padding: const EdgeInsets.all(16.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: Colors.cyan.withOpacity(0.2),
      border: Border.all(color: Colors.cyan.withOpacity(0.5), width: 1.5),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 10.0,
          spreadRadius: 2.0,
        ),
      ],
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center, // Centre le contenu de la ligne
          children: [
            Icon(icon, size: 30, color: const Color(0xFF00BCD4)),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(fontSize: 20, color: Colors.cyan),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          subtitle,
          style: const TextStyle(fontSize: 18, color: Colors.white),
        ),
        const SizedBox(height: 10),
        Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18, color: Colors.white),
        ),
      ],
    ),
  );
}

Widget _buildGlassmorphicRectangle2(BuildContext context, IconData icon, String title, String subtitle, String text) {
  return Container(
    width: 340,
    padding: const EdgeInsets.all(16.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: Colors.cyan.withOpacity(0.2),
      border: Border.all(color: Colors.cyan.withOpacity(0.5), width: 1.5),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 10.0,
          spreadRadius: 2.0,
        ),
      ],
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center, // Centre le contenu de la ligne
          children: [
            Icon(icon, size: 30, color: const Color(0xFF00BCD4)),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(fontSize: 20, color: Colors.cyan),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          subtitle,
          style: const TextStyle(fontSize: 18, color: Colors.white),
        ),
        const SizedBox(height: 10),
        Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18, color: Colors.white),
        ),
      ],
    ),
  );
}

  Widget _buildGlassmorphicButton(BuildContext context, IconData icon, String title) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
          bottomLeft: Radius.circular(20),
        ),
        color: Colors.cyan.withOpacity(0.2),
        border: Border.all(color: Colors.cyan.withOpacity(0.5), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10.0,
            spreadRadius: 2.0,
          ),
        ],
      ),
      child: Center(
        child: Icon(icon, size: 30, color: Colors.cyan),
      ),
    );
  }
}


