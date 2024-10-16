import 'package:app_six_cinq_barre/gsheet_setup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:app_six_cinq_barre/pages/contribution_page.dart';
import 'package:app_six_cinq_barre/pages/musicians_page.dart';
import 'package:app_six_cinq_barre/pages/program_page.dart';
import 'package:app_six_cinq_barre/pages/resources_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List dataFromSheet = [];

  @override
  void initState() {
    super.initState();
    readDataInformationsFromSheet();
  }

  Future<void> readDataInformationsFromSheet() async {
    dataFromSheet = (await gsheetInformationsDetails!.values.map.allRows())!;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final informationsText =
        dataFromSheet.isNotEmpty && dataFromSheet[0]['informations'] != null
            ? dataFromSheet[0]['informations']
            : 'Aucune information particulière pour le moment ;-)';

    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 10), // Espace en haut
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Orchestre",
                      style: TextStyle(
                        fontSize: 30,
                        fontFamily: 'Poppins',
                        color: Colors.cyan,
                      ),
                    ),
                    const SizedBox(
                        width: 10), // Espace entre le texte et le SVG
                    SvgPicture.asset(
                      "assets/images/65barre.svg",
                      colorFilter:
                          const ColorFilter.mode(Colors.cyan, BlendMode.srcIn),
                      height: 75, // Ajuste la taille selon les besoins
                    ),
                  ],
                ),
                const Text(
                  "Dirigé par Guillemette Daboval.",
                  style: TextStyle(fontSize: 20, color: Colors.cyan),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20), // Espace avant le rectangle
                _buildGlassmorphicRectangleInformations(
                  context,
                  "Informations :",
                  informationsText,
                ),
                const SizedBox(
                    height: 20), // Espace entre le rectangle et la grille
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 15.0,
                    crossAxisSpacing: 15.0,
                    shrinkWrap: true,
                    physics:
                        const NeverScrollableScrollPhysics(), // Désactive le scroll interne de la grille
                    children: [
                      _buildGlassmorphicCard(
                        context,
                        'Cotisations',
                        Icons.euro,
                        const Color.fromARGB(0, 0, 0, 0),
                        const Color(0xFF048B9A),
                        const ContributionPage(),
                        const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                          bottomLeft: Radius.circular(30),
                        ),
                      ),
                      _buildGlassmorphicCard(
                        context,
                        'Musiciens',
                        Icons.people,
                        const Color.fromARGB(0, 0, 0, 0),
                        const Color(0xFF048B9A),
                        const MusiciansPage(),
                        const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                      ),
                      _buildGlassmorphicCard(
                        context,
                        'Programme',
                        Icons.menu_book,
                        const Color.fromARGB(0, 0, 0, 0),
                        const Color(0xFF048B9A),
                        const ProgramPage(),
                        const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                          bottomLeft: Radius.circular(30),
                        ),
                      ),
                      _buildGlassmorphicCard(
                        context,
                        'Ressources',
                        Icons.picture_as_pdf,
                        const Color.fromARGB(0, 0, 0, 0),
                        const Color(0xFF048B9A),
                        const ResourcesPage(),
                        const BorderRadius.only(
                          topRight: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                          bottomLeft: Radius.circular(30),
                        ),
                      ),
                      const SizedBox(width: 80),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGlassmorphicCard(
    BuildContext context,
    String title,
    IconData icon,
    Color backgroundColor,
    Color overlayColor,
    Widget page,
    BorderRadius borderRadius,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: SizedBox(
        width: 120,
        height: 120,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            color: overlayColor.withOpacity(0.2),
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 50, color: Colors.cyan),
                const SizedBox(height: 5),
                Text(
                  title,
                  style: const TextStyle(fontSize: 20, color: Colors.cyan),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGlassmorphicRectangleInformations(
      BuildContext context, String title, String subtitle) {
    return Container(
      width: 380,
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
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
