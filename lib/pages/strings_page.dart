import 'package:app_six_cinq_barre/functions.dart';
import 'package:app_six_cinq_barre/gsheet_setup.dart';
import 'package:app_six_cinq_barre/pages/musicians_page.dart';
import 'package:app_six_cinq_barre/pages/navigation_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:ui';
import 'package:app_six_cinq_barre/gen/assets.gen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StringsPage extends StatefulWidget {
  const StringsPage({super.key});

  @override
  _StringsPageState createState() => _StringsPageState();
}

class _StringsPageState extends State<StringsPage> {
  List<Map<String, String>> stringsMusicians = [];
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    readDataStringsFromAdminSheet();
  }

  Future<void> readDataStringsFromAdminSheet() async {
    final List<Map<String, String>> allData =
        (await gsheetMusiciansDetails!.values.map.allRows())!;
    setState(() {
      stringsMusicians =
          allData.where((row) => row['pupitre'] == 'Cordes').toList();
    });
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
        title: const Text('Cordes'),
      ),
      backgroundColor: Colors.black,
      body: stringsMusicians.isEmpty
          ? const Center(child: CircularProgressIndicator(color: Colors.cyan))
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CarouselSlider.builder(
                  carouselController: _carouselController,
                  itemCount: stringsMusicians.length,
                  itemBuilder: (context, index, realIndex) {
                    final musicien = stringsMusicians[index];
                    return _buildGlassmorphicCard(
                      context,
                      _getLocalImageUrl(musicien["musicien"]!),
                      musicien["musicien"]!,
                      musicien["instrument"]!,
                      formatDateFromSheetWhithoutYear(musicien['birthday']!),
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
                  children: stringsMusicians.asMap().entries.map((entry) {
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
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const MusiciansPage()),
              );
            },
            child: _buildGlassmorphicButtonArrow(
                context, Icons.arrow_back, 'Musiciens'),
          ),
          const SizedBox(width: 10), // Espace entre les deux boutons
          GestureDetector(
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              final musicianName =
                  prefs.getString('musicianName') ?? 'Musicien';

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => NavigationWrapper(
                    initialIndex: 0,
                    musicianName: musicianName,
                  ),
                ),
                (Route<dynamic> route) => false,
              );
            },
            child: _buildGlassmorphicButtonHome(context, Icons.home, 'Accueil'),
          ),
        ],
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
                      return SvgPicture.asset(
                        photoUrl,
                        height: 200,
                        width: 200,
                        fit: BoxFit.cover,
                        colorFilter: const ColorFilter.mode(
                            Colors.cyan, BlendMode.srcIn),
                      );
                    } else {
                      return Image.asset(
                        photoUrl,
                        height: 200,
                        width: 200,
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                        errorBuilder: (context, error, stackTrace) {
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
              // Section anniversaire avec icône de gâteau
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.cake, color: Colors.cyan), // Icône du gâteau
                  const SizedBox(
                      width: 8), // Espacement entre l'icône et le texte
                  Text(
                    birthday.isEmpty
                        ? "Anniversaire: Non communiqué"
                        : "Anniversaire: $birthday",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontStyle: birthday.isEmpty
                          ? FontStyle.italic
                          : FontStyle.normal,
                    ),
                  ),
                ],
              ),
              const Divider(color: Colors.grey),
              // Section email avec icône de mail
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.email, color: Colors.cyan), // Icône de l'email
                  const SizedBox(
                      width: 8), // Espacement entre l'icône et le texte
                  Text(
                    email.isEmpty ? "email: Non communiqué" : "$email",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontStyle:
                          email.isEmpty ? FontStyle.italic : FontStyle.normal,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlassmorphicButtonArrow(
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

  Widget _buildGlassmorphicButtonHome(
      BuildContext context, IconData icon, String title) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
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
