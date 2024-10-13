import 'package:app_six_cinq_barre/gsheet_setup.dart';
import 'package:app_six_cinq_barre/main.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PercussionPage extends StatefulWidget {
  const PercussionPage({super.key});

  @override
  _PercussionPageState createState() => _PercussionPageState();
}

class _PercussionPageState extends State<PercussionPage> {
  List<Map<String, String>> percussionMusicians = [];

  @override
  void initState() {
    super.initState();
    readDataPercussionFromAdminSheet();
  }

  String formatDateFromSheet(String serialDate) {
    if (serialDate.isEmpty || int.tryParse(serialDate) == null) {
      return '';
    }

    final baseDate = DateTime(1899, 12, 30);
    final serialNumber = int.parse(serialDate);
    final date = baseDate.add(Duration(days: serialNumber));
    return DateFormat('dd/MM/yyyy').format(date);
  }

  Future<void> readDataPercussionFromAdminSheet() async {
    final List<Map<String, String>> allData =
        (await gsheetAdminDetails!.values.map.allRows())!;
    setState(() {
      percussionMusicians = allData
          .where((row) =>
              row['pupitre'] == 'Percussions' || row['pupitre'] == 'Harpe')
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.cyan,
        title: const Text('Percussions & harpe'),
      ),
      backgroundColor: Colors.black,
      body: percussionMusicians.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: CarouselSlider.builder(
                itemCount: percussionMusicians.length,
                itemBuilder: (context, index, realIndex) {
                  final musicien = percussionMusicians[index];
                  return _buildGlassmorphicCard(
                    context,
                    _getDirectImageUrl(
                        musicien["photo"]), // Convertir l'URL ici
                    musicien["musicien"]!,
                    musicien["instrument"]!,
                    formatDateFromSheet(musicien['birthday']!),
                    musicien["email"]!,
                  );
                },
                options: CarouselOptions(
                  height: 500,
                  enlargeCenterPage: true,
                  autoPlay: false,
                  autoPlayInterval: const Duration(seconds: 3),
                  aspectRatio: 2.0,
                  viewportFraction: 0.8,
                  enableInfiniteScroll: false,
                ),
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

  // Nouvelle fonction pour obtenir l'URL directe
  String _getDirectImageUrl(String? photoUrl) {
    if (photoUrl == null || photoUrl.isEmpty) {
      return '';
    }

    // Extraire l'identifiant du fichier à partir de l'URL
    final RegExp regExp = RegExp(r'/d/([^/]+)');
    final match = regExp.firstMatch(photoUrl);

    if (match != null && match.groupCount > 0) {
      String fileId = match.group(1)!; // Récupérer l'identifiant
      return 'https://drive.google.com/uc?id=$fileId'; // Formater l'URL correcte
    } else {
      return ''; // Retourner une chaîne vide si l'identifiant n'est pas trouvé
    }
  }

  Widget _buildGlassmorphicCard(
    BuildContext context,
    String? photoUrl, // Accepte photoUrl comme nullable
    String nom,
    String instrument,
    String birthday,
    String email,
  ) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.0),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 30.0, sigmaY: 30.0),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: Colors.white.withOpacity(0.2),
            border: Border.all(color: Colors.cyan, width: 0.8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Vérifiez si photoUrl n'est pas vide et non nul
              if (photoUrl != null && photoUrl.isNotEmpty)
                ClipOval(
                  child: Image.network(
                    photoUrl, // Utilisez Image.network pour charger l'image depuis l'URL
                    height: 200,
                    width: 200,
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                  ),
                )
              else
                ClipOval(
                  child: SvgPicture.asset(
                    'assets/images/anonymous.svg', // Remplacez par le chemin de votre SVG
                    height: 200,
                    width: 200,
                    fit: BoxFit.cover,
                    colorFilter:
                        const ColorFilter.mode(Colors.cyan, BlendMode.srcIn),
                  ),
                ),
              const SizedBox(height: 16),
              Text(
                nom,
                style: const TextStyle(
                  color: Colors.cyan,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                instrument,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              const Divider(color: Colors.grey),
              Text(
                birthday.isEmpty
                    ? "Date de naissance: Non communiquée"
                    : "Date de naissance: $birthday",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontStyle: birthday.isEmpty
                      ? FontStyle.italic
                      : FontStyle
                          .normal, // Changer le style en italique si birthday est vide
                ),
              ),
              const Divider(color: Colors.grey),
              Text(
                email.isEmpty ? "email: Non communiqué" : "email: $email",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontStyle: email.isEmpty
                      ? FontStyle.italic
                      : FontStyle
                          .normal, // Changer le style en italique si email est vide
                ),
              ),
            ],
          ),
        ),
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
