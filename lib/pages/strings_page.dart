import 'package:app_six_cinq_barre/gsheet_setup.dart';
import 'package:app_six_cinq_barre/main.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'dart:ui';
import 'package:intl/intl.dart';

class StringsPage extends StatefulWidget {
  const StringsPage({super.key});

  @override
  _StringsPageState createState() => _StringsPageState();
}

class _StringsPageState extends State<StringsPage> {
  List<Map<String, String>> cordesMusicians = [];

  @override
  void initState() {
    super.initState();
    readDataStringsFromAdminSheet();
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

  Future<void> readDataStringsFromAdminSheet() async {
    final List<Map<String, String>> allData =
        (await gsheetAdminDetails!.values.map.allRows())!;
    setState(() {
      cordesMusicians =
          allData.where((row) => row['pupitre'] == 'Cordes').toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.cyan,
        title: const Text('Cordes'),
      ),
      backgroundColor: Colors.black,
      body: cordesMusicians.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: CarouselSlider.builder(
                itemCount: cordesMusicians.length,
                itemBuilder: (context, index, realIndex) {
                  final musicien = cordesMusicians[index];
                  return _buildGlassmorphicCard(
                    context,
                    musicien["photo"], // Passer l'URL de la photo ici
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

  // Nouvelle fonction pour télécharger l'image à partir de l'URL
  Future<Uint8List?> _fetchImage(String? photoUrl) async {
    if (photoUrl == null || photoUrl.isEmpty) {
      return null;
    }

    try {
      final response = await http.get(Uri.parse(photoUrl));
      print("Statut de la réponse: ${response.statusCode}");
      print("Type de contenu: ${response.headers['content-type']}");

      // Vérifier que la requête a réussi et que le type de contenu est bien une image
      if (response.statusCode == 200) {
        // Vérification supplémentaire pour le type de contenu
        final contentType = response.headers['content-type'];
        if (contentType != null && contentType.startsWith('image/')) {
          print("Image récupérée avec succès.");
          return response.bodyBytes; // Retourner les données de l'image
        } else {
          print("Le type de contenu n'est pas une image.");
        }
      } else {
        print("Erreur lors du chargement de l'image: ${response.statusCode}");
      }
    } catch (e) {
      print("Erreur de chargement de l'image : $e");
    }
    return null;
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
              FutureBuilder<Uint8List?>(
                future: _fetchImage(photoUrl),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasData) {
                    return ClipOval(
                      child: Image.memory(
                        snapshot.data!,
                        height: 200,
                        width: 200,
                        fit: BoxFit.cover,
                      ),
                    );
                  } else {
                    return ClipOval(
                      child: SvgPicture.asset(
                        'assets/images/anonymous.svg',
                        height: 200,
                        width: 200,
                        fit: BoxFit.cover,
                        colorFilter: const ColorFilter.mode(
                            Colors.cyan, BlendMode.srcIn),
                      ),
                    );
                  }
                },
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
                  fontStyle: birthday.isEmpty ? FontStyle.italic : FontStyle.normal,
                ),
              ),
              const Divider(color: Colors.grey),
              Text(
                email.isEmpty ? "email: Non communiqué" : "email: $email",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontStyle: email.isEmpty ? FontStyle.italic : FontStyle.normal,
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
