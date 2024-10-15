import 'package:app_six_cinq_barre/gsheet_setup.dart';
import 'package:app_six_cinq_barre/main.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:app_six_cinq_barre/gen/assets.gen.dart';

class BrassPage extends StatefulWidget {
  const BrassPage({super.key});

  @override
  _BrassPageState createState() => _BrassPageState();
}

class _BrassPageState extends State<BrassPage> {
  List<Map<String, String>> brassMusicians = [];
  final CarouselSliderController _carouselController = CarouselSliderController();
int _currentIndex = 0;

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
        (await gsheetMusiciansDetails!.values.map.allRows())!;
    setState(() {
      brassMusicians =
          allData.where((row) => row['pupitre'] == 'Cuivres').toList();
    });
  }

  String normalizeName(String name) {
    const Map<String, String> accentsMap = {
      'à': 'a',
      'â': 'a',
      'ä': 'a',
      'á': 'a',
      'ã': 'a',
      'è': 'e',
      'ê': 'e',
      'ë': 'e',
      'é': 'e',
      'ì': 'i',
      'î': 'i',
      'ï': 'i',
      'ò': 'o',
      'ô': 'o',
      'ö': 'o',
      'ó': 'o',
      'õ': 'o',
      'ù': 'u',
      'û': 'u',
      'ü': 'u',
      'ú': 'u',
      'ç': 'c',
      'ñ': 'n',
      'ý': 'y',
      'ÿ': 'y',
      'À': 'a',
      'Â': 'a',
      'Ä': 'a',
      'Á': 'a',
      'Ã': 'a',
      'È': 'e',
      'Ê': 'e',
      'Ë': 'e',
      'É': 'e',
      'Ì': 'i',
      'Î': 'i',
      'Ï': 'i',
      'Ò': 'o',
      'Ô': 'o',
      'Ö': 'o',
      'Ó': 'o',
      'Õ': 'o',
      'Ù': 'u',
      'Û': 'u',
      'Ü': 'u',
      'Ú': 'u',
      'Ç': 'c',
      'Ñ': 'n',
      'Ý': 'y',
      'Ÿ': 'y',
    };

    accentsMap.forEach((accentedChar, replacement) {
      name = name.replaceAll(accentedChar, replacement);
    });

    return name
        .toLowerCase()
        .replaceAll(' ', '_')
        .replaceAll(RegExp(r'[^a-z0-9_]'), '');
  }

  final List<String> availableImages = Assets.images.musiciens.values
      .map((image) => image.path.split('/').last)
      .toList();

  String _getLocalImageUrl(String musicianName) {
    final normalizedName = normalizeName(musicianName);
    final List<String> extensions = ['.png', '.jpg'];

    for (var ext in extensions) {
      final fileName = '$normalizedName$ext';
      print(availableImages);

      if (availableImages.contains(fileName)) {
        return 'assets/images/musiciens/$fileName';
      }
    }
    return "";
    // return 'assets/images/anonymous.png';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.cyan,
        title: const Text('Cuivres'),
      ),
      backgroundColor: Colors.black,
      body: brassMusicians.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CarouselSlider.builder(
                  carouselController: _carouselController,
                  itemCount: brassMusicians.length,
                  itemBuilder: (context, index, realIndex) {
                    final musicien = brassMusicians[index];
                    return _buildGlassmorphicCard(
                      context,
                      _getLocalImageUrl(musicien["musicien"]!),
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
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: brassMusicians.asMap().entries.map((entry) {
                    return GestureDetector(
                      onTap: () => _carouselController.animateToPage(entry.key),
                      child: Container(
                        width: 8.0,
                        height: 8.0,
                        margin: const EdgeInsets.symmetric(
                            vertical: 40.0, horizontal: 4.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentIndex == entry.key
                              ? Colors.cyan.withOpacity(0.9)
                              : Colors.white.withOpacity(0.4),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
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

  Widget _buildGlassmorphicCard(
    BuildContext context,
    String photoUrl,
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
              ClipOval(
                child: Builder(
                  builder: (context) {
                    if (photoUrl.endsWith('.svg')) {
                      // Utilise SvgPicture si le fichier est un SVG
                      return SvgPicture.asset(
                        photoUrl,
                        height: 200,
                        width: 200,
                        fit: BoxFit.cover,
                        colorFilter: const ColorFilter.mode(
                            Colors.cyan, BlendMode.srcIn),
                      );
                    } else {
                      // Utilise Image.asset pour les fichiers PNG/JPG
                      return Image.asset(
                        photoUrl,
                        height: 200,
                        width: 200,
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                        errorBuilder: (context, error, stackTrace) {
                          // Affiche le SVG si l'image n'existe pas
                          return SvgPicture.asset(
                            'assets/images/anonymous.svg',
                            height: 200,
                            width: 200,
                            fit: BoxFit.cover,
                            colorFilter: const ColorFilter.mode(
                                Colors.cyan, BlendMode.srcIn),
                          );
                        },
                      );
                    }
                  },
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
                  fontStyle:
                      birthday.isEmpty ? FontStyle.italic : FontStyle.normal,
                ),
              ),
              const Divider(color: Colors.grey),
              Text(
                email.isEmpty ? "email: Non communiqué" : "email: $email",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontStyle:
                      email.isEmpty ? FontStyle.italic : FontStyle.normal,
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
