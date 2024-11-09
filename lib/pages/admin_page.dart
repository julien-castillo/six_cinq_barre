import 'package:app_six_cinq_barre/gsheet_setup.dart';
import 'package:app_six_cinq_barre/pages/admin_absences_page.dart';
import 'package:app_six_cinq_barre/pages/admin_contribution_page.dart';
import 'package:app_six_cinq_barre/pages/navigation_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  List<String> adminMusicians = [];

  @override
  void initState() {
    super.initState();
    _loadAdminMusicians();
  }

  Future<void> _loadAdminMusicians() async {
    final admins = await getAdminMusicians();
    setState(() {
      adminMusicians = admins;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.cyan,
        title: const Text('Admin'),
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // Header centré en haut
                _buildGlassmorphicAdminHeader(context),
                const SizedBox(height: 20),

                // Deux cartes côte à côte
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: _buildGlassmorphicCard(
                        context,
                        'Suivi des cotisations',
                        Icons.euro,
                        const Color.fromARGB(0, 0, 0, 0),
                        const Color(0xFF048B9A),
                        const AdminContributionPage(),
                        const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                          bottomLeft: Radius.circular(30),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: _buildGlassmorphicCard(
                        context,
                        'Suivi des absences',
                        Icons.people,
                        const Color.fromARGB(0, 0, 0, 0),
                        const Color(0xFF048B9A),
                        const AdminAbsencesPage(),
                        const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Liste admin centrée
                _buildGlassmorphicAdminList(context),
                const SizedBox(height: 20),

                // Bouton aligné à droite
                Align(
                  alignment: Alignment.centerRight,
                  child:
                      _buildGlassmorphicButton(context, Icons.home, 'Accueil'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGlassmorphicAdminHeader(
    BuildContext context,
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
              const SizedBox(width: 10),
              Text(
                "Section Admin",
                style: const TextStyle(fontSize: 20, color: Colors.orange),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGlassmorphicAdminList(BuildContext context) {
    bool isExpanded = false;

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return GestureDetector(
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            width: 340,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.cyan.withOpacity(0.2),
              border:
                  Border.all(color: Colors.cyan.withOpacity(0.5), width: 1.5),
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
                    Expanded(
                      child: Text(
                        "Liste des Administrateurs",
                        style:
                            const TextStyle(fontSize: 20, color: Colors.cyan),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Icon(
                      isExpanded ? Icons.expand_less : Icons.expand_more,
                      color: Colors.cyan,
                    ),
                  ],
                ),
                if (isExpanded)
                  Column(
                    children: [
                      const SizedBox(height: 20),
                      // Liste à puces des musiciens admin
                      ...adminMusicians
                          .map((admin) => Row(
                                children: [
                                  const Icon(
                                    Icons.admin_panel_settings,
                                    color: Colors.orange,
                                    size: 40,
                                  ), // Icône de puce
                                  const SizedBox(
                                      width:
                                          8), // Espacement entre l'icône et le texte
                                  Expanded(
                                    child: Text(
                                      admin,
                                      style: const TextStyle(
                                          fontSize: 18, color: Colors.white),
                                    ),
                                  ),
                                  const SizedBox(
                                      height:
                                          30), // Espacement entre chaque ligne
                                ],
                              ))
                          .toList(),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
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
                const SizedBox(height: 15),
                Icon(icon, size: 40, color: Colors.cyan),
                const SizedBox(height: 10),
                Text(
                  title,
                  style: const TextStyle(fontSize: 16, color: Colors.cyan),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGlassmorphicButton(
      BuildContext context, IconData icon, String title) {
    return GestureDetector(
      onTap: () async {
        final prefs = await SharedPreferences.getInstance();
        final musicianName = prefs.getString('musicianName') ?? 'Musicien';
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
      child: Container(
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
      ),
    );
  }
}
