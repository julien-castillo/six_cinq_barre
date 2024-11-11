import 'package:app_six_cinq_barre/gsheet_setup.dart';
import 'package:app_six_cinq_barre/pages/navigation_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slide_to_act/slide_to_act.dart';

class AbsencesPage extends StatefulWidget {
  final String musicianName;

  const AbsencesPage({Key? key, required this.musicianName}) : super(key: key);

  @override
  _AbsencesPageState createState() => _AbsencesPageState();
}

class _AbsencesPageState extends State<AbsencesPage> {
  List<Map<String, dynamic>> rehearsalData = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchRehearsalData();
  }

  Future<void> fetchRehearsalData() async {
    final sheet = await gsheetAbsencesDetails;
    if (sheet == null) return;

    final rows = await sheet.values.allRows();
    final headers = rows.first.sublist(2);

    setState(() {
      rehearsalData = rows
          .sublist(1)
          .map((row) {
            final musician = row[0];
            if (musician != widget.musicianName) return null;

            final data = <String, dynamic>{'musician': musician};
            for (var i = 2; i < row.length; i++) {
              data[headers[i - 2]] = row[i] == 'true';
            }
            return data;
          })
          .where((element) => element != null)
          .cast<Map<String, dynamic>>()
          .toList();
    });
  }

  Future<void> updateAbsenceStatus(String date, bool isAbsent) async {
    final sheet = await gsheetAbsencesDetails;
    if (sheet == null) return;

    final rows = await sheet.values.allRows();
    final headers = rows.first;
    final dateIndex = headers.indexOf(date);
    if (dateIndex == -1) return;

    final musicianRowIndex =
        rows.indexWhere((row) => row[0] == widget.musicianName);
    if (musicianRowIndex == -1) return;

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
      backgroundColor: Colors.black,
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
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const SizedBox(height: 10),
                      _buildGlassmorphicButton(context, Icons.home, 'Accueil'),
                    ],
                  );
                }
                final rehearsal = rehearsalData[index];
                final dates = rehearsal.keys.where((key) => key != 'musician');

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final date in dates) ...[
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.cyan.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: rehearsal[date] ? Colors.deepOrange : Colors.green,
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10.0,
                              spreadRadius: 2.0,
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Répétition du $date",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color:
                                    rehearsal[date] ? Colors.deepOrange : Colors.green,
                              ),
                            ),
                            const SizedBox(height: 10),
                            SlideAction(
                              text: rehearsal[date]
                                  ? 'Annuler mon absence'
                                  : 'Déclarer mon absence',
                              sliderButtonIcon: Icon(
                                _isLoading
                                    ? Icons.hourglass_top
                                    : (rehearsal[date]
                                        ? Icons.cancel
                                        : Icons.check_circle),
                                color: Colors.white,
                              ),
                              sliderRotate: false,
                              sliderButtonIconPadding: 14,
                              innerColor:
                                  rehearsal[date] ? Colors.deepOrange : Colors.green,
                              outerColor: Colors.cyan.withOpacity(0.2),
                              textStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                              borderRadius: 12,
                              onSubmit: () async {
                                setState(() {
                                  _isLoading = true;
                                });

                                final newStatus = !rehearsal[date];
                                await updateAbsenceStatus(date, newStatus);
                                await fetchRehearsalData();

                                setState(() {
                                  _isLoading = false;
                                });
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
