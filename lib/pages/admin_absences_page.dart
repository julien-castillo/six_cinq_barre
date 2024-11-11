import 'package:flutter/material.dart';
import 'package:app_six_cinq_barre/gsheet_setup.dart';
import 'package:app_six_cinq_barre/pages/navigation_wrapper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminAbsencesPage extends StatefulWidget {
  const AdminAbsencesPage({Key? key}) : super(key: key);

  @override
  _AdminAbsencesPageState createState() => _AdminAbsencesPageState();
}

class _AdminAbsencesPageState extends State<AdminAbsencesPage> {
  Map<String, List<Map<String, dynamic>>> absenceData = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAbsenceData();
  }

  Future<void> _loadAbsenceData() async {
    final data = await getAbsenceData();
    print("Données d'absence chargées : $data");
    setState(() {
      absenceData = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Suivi des Absences (Admin)'),
        backgroundColor: Colors.cyan,
      ),
      backgroundColor: Colors.black,
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.cyan))
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildGlassmorphicAdminHeader(context),
                    const SizedBox(height: 30),
                    if (absenceData.isEmpty)
                      Column(
                        children: [
                          _buildNoAbsencesMessage(context),
                          const SizedBox(height: 30),
                        ],
                      )
                    else
                      ...absenceData.entries
                          .map((entry) => Column(
                                children: [
                                  _buildGlassmorphicList(
                                    context,
                                    entry.key, // La date
                                    entry.value, // La liste des absents
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              ))
                          .toList(),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: _buildGlassmorphicButtonArrow(
                            context,
                            Icons.arrow_back,
                            'Retour',
                          ),
                        ),
                        const SizedBox(width: 10), // Espace entre les boutons
                        _buildGlassmorphicButton(
                          context,
                          Icons.home,
                          'Accueil',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildGlassmorphicAdminHeader(BuildContext context) {
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
                "Section Admin -> Absences",
                style: const TextStyle(fontSize: 20, color: Colors.orange),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNoAbsencesMessage(BuildContext context) {
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
      child: Text(
        "Aucune absence prévue, youpi !",
        style: TextStyle(color: Colors.white, fontSize: 18),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildGlassmorphicList(
    BuildContext context,
    String date,
    List<Map<String, dynamic>> absents,
  ) {
    bool isExpanded = false;
    Map<String, int> instrumentCounts = {};

    for (var absent in absents) {
      String instrument = absent['instrument'];
      instrumentCounts[instrument] = (instrumentCounts[instrument] ?? 0) + 1;
    }

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
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style:
                              const TextStyle(fontSize: 20, color: Colors.cyan),
                          children: [
                            TextSpan(text: "Absences du $date "),
                            TextSpan(
                              text: "(${absents.length})",
                              style: const TextStyle(color: Colors.orange),
                            ),
                          ],
                        ),
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
                      Text(
                        instrumentCounts.entries
                            .map((e) => "${e.value} ${e.key}(s)")
                            .join(", "),
                        style:
                            const TextStyle(fontSize: 19, color: Colors.orange),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 30),
                      ...absents
                          .map((absent) => Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Row(
                                  children: [
                                    Icon(Icons.person,
                                        color: Colors.orange, size: 30),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        "${absent['musicien']} (${absent['instrument']})",
                                        style: const TextStyle(
                                            fontSize: 18, color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
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
