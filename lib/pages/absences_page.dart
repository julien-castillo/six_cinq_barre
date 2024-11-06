import 'package:app_six_cinq_barre/gsheet_setup.dart';
import 'package:app_six_cinq_barre/pages/navigation_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slide_to_act/slide_to_act.dart';

class AbsencesPage extends StatefulWidget {
  final String musicianName; // Le nom du musicien connecté

  const AbsencesPage({Key? key, required this.musicianName}) : super(key: key);

  @override
  _AbsencesPageState createState() => _AbsencesPageState();
}

class _AbsencesPageState extends State<AbsencesPage> {
  List<Map<String, dynamic>> rehearsalData = []; // Données des répétitions

  @override
  void initState() {
    super.initState();
    fetchRehearsalData();
  }

  // Fonction pour récupérer les données d'absences depuis Google Sheets
  Future<void> fetchRehearsalData() async {
    final sheet = await gsheetAbsencesDetails; // Accède à la feuille 'absences'
    if (sheet == null) return;

    final rows = await sheet.values.allRows(); // Récupère toutes les lignes
    final headers = rows.first; // Première ligne : les dates

    // Parcourt chaque ligne pour créer une map pour chaque répétition
    setState(() {
      rehearsalData = rows
          .sublist(1)
          .map((row) {
            final musician = row[0]; // Colonne avec le nom du musicien
            if (musician != widget.musicianName)
              return null; // Filtre pour le musicien connecté

            // Crée un map avec la date et l'état de l'absence pour chaque répétition
            final data = <String, dynamic>{'musician': musician};
            for (var i = 1; i < headers.length; i++) {
              data[headers[i]] = row[i] == 'true'; // Convertit en booléen
            }
            return data;
          })
          .where((element) => element != null) // Filtre les éléments nulls
          .cast<Map<String, dynamic>>()
          .toList();
    });
  }

  // Fonction pour mettre à jour l'état d'absence dans Google Sheets
  Future<void> updateAbsenceStatus(String date, bool isAbsent) async {
    final sheet = await gsheetAbsencesDetails;
    if (sheet == null) return;

    final rows = await sheet.values.allRows();
    final headers = rows.first;
    final dateIndex =
        headers.indexOf(date); // Trouve l'index de la colonne de la date
    if (dateIndex == -1) return;

    // Trouve l'index de la ligne correspondant au musicien
    final musicianRowIndex =
        rows.indexWhere((row) => row[0] == widget.musicianName);
    if (musicianRowIndex == -1) return;

    // Met à jour la cellule avec la nouvelle valeur d'absence
    await sheet.values.insertValue(
      isAbsent.toString(),
      column: dateIndex + 1,
      row: musicianRowIndex + 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes absences'),
        centerTitle: true,
        backgroundColor: Colors.cyan,
      ),
      backgroundColor: Colors.black, // Définition de l'arrière-plan en noir
      body: rehearsalData.isEmpty
          ? const Center(
              child: CircularProgressIndicator(
              color: Colors.cyan,
            ))
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: rehearsalData.length + 1,
              itemBuilder: (context, index) {
                if (index == rehearsalData.length) {
                        // Affiche le bouton "Accueil" après le dernier élément
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const SizedBox(height: 10),
                            _buildGlassmorphicButton(
                                context, Icons.home, 'Accueil'),
                          ],
                        );
                      }
                final rehearsal = rehearsalData[index];

                // Exclut la première clé "musician" pour ne garder que les dates
                final dates = rehearsal.keys.where((key) => key != 'musician');

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final date in dates) ...[
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.cyan
                              .withOpacity(0.2), // Couleur de fond extérieure
                          borderRadius:
                              BorderRadius.circular(12), // Arrondi des bords
                          border: Border.all(
                            color: rehearsal[date]
                                ? Colors.red
                                : Colors
                                    .green, // Vert si présent, rouge si absent
                            width: 1,
                          ), // Couleur de la bordure
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10.0,
                              spreadRadius: 2.0,
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(10), // Espacement interne
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start, // Alignement à gauche
                          children: [
                            Text(
                              "Répétition du $date",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: rehearsal[date]
                                    ? Colors.red
                                    : Colors
                                        .green, // Vert si présent, rouge si absent
                              ),
                            ),
                            const SizedBox(height: 10),
                            SlideAction(
                              text: rehearsal[date]
                                  ? 'Annuler mon absence'
                                  : 'Déclarer mon absence',
                              sliderButtonIcon: Icon(
                                rehearsal[date]
                                    ? Icons.cancel
                                    : Icons.check_circle,
                                color: Colors.white,
                              ),
                              sliderRotate: false,
                              sliderButtonIconPadding: 14,
                              innerColor: rehearsal[date]
                                  ? Colors.red
                                  : Colors.green, // Couleur de fond intérieure
                              outerColor: Colors.cyan.withOpacity(
                                  0.2), // Couleur de fond extérieure lorsqu'on glisse
                              textStyle: const TextStyle(
                                color: Colors
                                    .white, // Couleur du texte dans le slider
                                fontSize: 18, // Taille du texte
                                fontWeight: FontWeight.w500,
                              ),
                              borderRadius: 12, // Arrondi des bords
                              onSubmit: () async {
                                final newStatus = !rehearsal[date];
                                await updateAbsenceStatus(date, newStatus);

                                // Recharger les données pour afficher l'état actuel
                                await fetchRehearsalData();
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                    ]
                  ],
                );
              },
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
