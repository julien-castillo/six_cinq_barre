import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:app_six_cinq_barre/pages/contribution_page.dart';
import 'package:app_six_cinq_barre/pages/musicians_page.dart';
import 'package:app_six_cinq_barre/pages/program_page.dart';
import 'package:app_six_cinq_barre/pages/resources_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                padding: const EdgeInsets.all(32.0),
                mainAxisSpacing: 20.0,
                crossAxisSpacing: 20.0,
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
                ],
              ),
            ),
            const Text(
              "Orchestre 6/5 barré",
              style: TextStyle(
                  fontSize: 40, fontFamily: 'Poppins', color: Colors.cyan),
            ),
            const Text(
              "Dirigé par Guillemette Daboval.",
              style: TextStyle(fontSize: 20, color: Colors.cyan),
              textAlign: TextAlign.center,
            ),
            SvgPicture.asset(
              "assets/images/65barre_conductor.svg",
              colorFilter: const ColorFilter.mode(Colors.cyan, BlendMode.srcIn),
              height: 200,
            ),
            const Padding(padding: EdgeInsets.only(bottom: 30)),
          ],
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
        width: 150,
        height: 150,
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
                const SizedBox(height: 10),
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
}
