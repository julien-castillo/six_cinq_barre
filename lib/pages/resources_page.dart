import 'package:app_six_cinq_barre/main.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ResourcesPage extends StatelessWidget {
  const ResourcesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.cyan,
        title: const Text('Ressources'),
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView( // Rendre la page scrollable
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildGlassmorphicRectangle1(
                context,
                Icons.music_note,
                "Partitions",
                "- Version imslp, édition Choudens - ",
                "Accéder aux paritions :",
              ),
              const SizedBox(height: 20),
              _buildGlassmorphicRectangle2(
                context,
                Icons.cut,
                "Coupes :",
                "Voici les différentes coupes à réaliser :",
              ),
              const SizedBox(height: 20),
              _buildGlassmorphicRectangle3(
                context,
                'n°6 : Récitatif "Quels regards"',
                "De la mesure 5 Andante Moderato à 'José', levée de la mesure 20",
              ),
              const SizedBox(height: 20),
              _buildGlassmorphicRectangle3(
                context,
                'n°6 : Récitatif "Quels regards"',
                "De la mesure 5 Andante Moderato à 'José', levée de la mesure 20",
              ),
              const SizedBox(height: 20),
              _buildGlassmorphicRectangle3(
                context,
                'n°6 : Récitatif "Quels regards"',
                "De la mesure 5 Andante Moderato à 'José', levée de la mesure 20",
              ),
              const SizedBox(height: 80), // Espace pour le bouton en bas
            ],
          ),
        ),
      ),
      floatingActionButton: Align( // Positionner le bouton en bas à droite
        alignment: Alignment.bottomRight,
        child: GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MyApp()),
            );
          },
          child: _buildGlassmorphicButton(context, Icons.home, 'Accueil'),
        ),
      ),
    );
  }

  Widget _buildGlassmorphicRectangle1(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    String description,
  ) {
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 30, color: const Color(0xFF00BCD4)),
              const SizedBox(width: 10),
              Expanded( // Permet au texte d'aller à la ligne
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 20, color: Colors.cyan),
                  textAlign: TextAlign.center, // Centre le texte
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, color: Colors.white),
          ),
          const SizedBox(height: 10),
          Column(
            children: [
              Text(
                description,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () => _launchURL('https://www.cadeau-bois.fr'), // Remplace par ton lien
                child: const Icon(
                  Icons.picture_as_pdf,
                  color: Colors.yellow,
                  size: 50,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Fonction pour lancer l'URL (moderne)
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _buildGlassmorphicRectangle2(BuildContext context, IconData icon,
      String title, String text) {
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
              Expanded( // Permet au texte d'aller à la ligne
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 20, color: Colors.cyan),
                  textAlign: TextAlign.center, // Centre le texte
                ),
              ),
            ],
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

   Widget _buildGlassmorphicRectangle3(BuildContext context, String title, String text) {
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
              Expanded( // Permet au texte d'aller à la ligne
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 20, color: Colors.cyan),
                  textAlign: TextAlign.center, // Centre le texte
                ),
              ),
            ],
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

  Widget _buildGlassmorphicButton(
      BuildContext context, IconData icon, String title) {
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
