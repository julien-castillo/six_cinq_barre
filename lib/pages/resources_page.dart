import 'package:flutter/material.dart';
import 'package:app_six_cinq_barre/main.dart';

class ResourcesPage extends StatelessWidget {
  const ResourcesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.cyan,
        title: const Text('Ressources')
        ),
      backgroundColor: Colors.black,
      body: const Center(
        child: Text(
          'Ressources',
          style: TextStyle(color: Colors.cyan, fontSize: 24),
        ),
      ),
      floatingActionButton: GestureDetector(
        onTap: () {
          // Naviguer vers la HomePage lorsque le bouton est pressé
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MyApp()),
          );
        },
        child: _buildGlassmorphicButton(
          context,
          Icons.home, // Icône du bouton
          'Accueil',   // Titre du bouton (si nécessaire)
        ),
      ),
    );
  }

  Widget _buildGlassmorphicButton(BuildContext context, IconData icon, String title) {
    return Container(
      width: 60, // Ajustez la taille si nécessaire
      height: 60, // Ajustez la taille si nécessaire
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
          bottomLeft: Radius.circular(20),
        ), // Bord arrondi
        color: Colors.cyan.withOpacity(0.2), // Couleur de fond avec opacité
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
        child: Icon(icon, size: 30, color: Colors.cyan), // Icône du bouton
      ),
    );
  }
}