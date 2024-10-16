import 'dart:async';
import 'dart:ui';
import 'package:app_six_cinq_barre/functions.dart';
import 'package:app_six_cinq_barre/gsheet_setup.dart';
import 'package:app_six_cinq_barre/main.dart';
import 'package:flutter/material.dart';

class ConcertPage extends StatefulWidget {
  const ConcertPage({super.key});

  @override
  State<ConcertPage> createState() => _ConcertPageState();
}

class _ConcertPageState extends State<ConcertPage> {
  List<Map<String, dynamic>> dataFromSheet = [];

  @override
  void initState() {
    super.initState();
    readDataFromSheet();
  }

  Future<void> readDataFromSheet() async {
    var rawSheetData = await gsheetConcertsDetails!.values.map.allRows();
    if (rawSheetData != null) {
      dataFromSheet = rawSheetData.map((row) {
        return {
          'date': formatDateFromSheet(row['date'] ?? ''),
          'heure': row['heure'] ?? '',
          'lieu': row['lieu'] ?? '',
          'informations_concert': row['informations_concert'] ?? '',
          'programme': row['programme'] ?? '',
        };
      }).toList();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   centerTitle: true,
      //   backgroundColor: Colors.cyan,
      //   title: const Text('Concerts'),
      // ),
      backgroundColor: Colors.black,
      body: dataFromSheet.isEmpty
          ? const Center(child: CircularProgressIndicator(color: Colors.cyan))
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: dataFromSheet.length,
              itemBuilder: (context, index) {
                final row = dataFromSheet[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: _buildGlassmorphicRectangleConcert(
                    context,
                    Icons.calendar_month,
                    row['programme'],
                    row['date'],
                    row['heure'],
                    row['lieu'],
                    row['informations_concert'],
                  ),
                );
              },
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 48.0), // Ajuste la valeur ici
        child: GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MyApp()),
            );
          },
          child: _buildGlassmorphicButton(context, Icons.home, 'Accueil'),
        ),
      ),
    );
  }

  // Widget _buildGlassmorphicRectangleConcert(
  //   BuildContext context,
  //   IconData icon,
  //   String programme,
  //   String date,
  //   String heure,
  //   String lieu,
  //   String informationsConcert,
    
  // ) {
  //   return Container(
  //     padding: const EdgeInsets.all(16.0),
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(20),
  //       color: Colors.cyan.withOpacity(0.2),
  //       border: Border.all(color: Colors.cyan.withOpacity(0.5), width: 1.5),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withOpacity(0.2),
  //           blurRadius: 10.0,
  //           spreadRadius: 2.0,
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             Icon(icon, size: 30, color: Colors.cyan),
  //             const SizedBox(width: 10),
  //             Text(
  //               programme,
  //               style: const TextStyle(fontSize: 20, color: Colors.cyan),
  //             ),
  //           ],
  //         ),
  //         const SizedBox(height: 10),
  //         Text(
  //           '$date à $heure',
  //           style: const TextStyle(fontSize: 18, color: Colors.orange),
  //         ),
  //         const SizedBox(height: 10),
  //         Text(
  //           'Lieu : $lieu',
  //           style: const TextStyle(fontSize: 18, color: Colors.white),
  //         ),
  //         const SizedBox(height: 10),
  //         Text(
  //           informationsConcert,
  //           textAlign: TextAlign.center,
  //           style: const TextStyle(fontSize: 18, color: Colors.white),
  //         ),
  //         const SizedBox(height: 10),
  //       ],
  //     ),
  //   );
  // }

Widget _buildGlassmorphicRectangleConcert(
  BuildContext context,
  IconData icon,
  String programme,
  String date,
  String heure,
  String lieu,
  String informationsConcert,
) {
  return GestureDetector(
    onTap: () {
      _showConcertDetailsDialog(context, date, heure, lieu, informationsConcert, programme);
    },
    child: Container(
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
              Icon(icon, size: 30, color: Colors.cyan),
              const SizedBox(width: 10),
              Flexible(
              child: Text(
                programme,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20, color: Colors.cyan),
              ),
          ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '$date à $heure',
            style: const TextStyle(fontSize: 18, color: Colors.orange),
          ),
          const SizedBox(height: 10),
          Text(
            'Lieu : $lieu',
            style: const TextStyle(fontSize: 18, color: Colors.white),
          ),
          const SizedBox(height: 10),
          Text(
            informationsConcert,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, color: Colors.white),
          ),
          const SizedBox(height: 10),
        ],
      ),
    ),
  );
}

void _showConcertDetailsDialog(BuildContext context, String date, String heure, String lieu, String informationsCncert, String programme) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: ClipRRect(
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
                      child: Image.asset(
                        'assets/images/Guillemette_Daboval.jpg',
                        height: 250,
                        width: 250,
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text('$lieu : ', style: const TextStyle(color: Colors.cyan, fontSize: 20, fontWeight: FontWeight.w500)),
                    Text('$date à $heure', style: const TextStyle(fontSize: 18, color: Colors.white)),
                    const Divider(color: Colors.grey),
                    const Text('Programme : ', style: TextStyle(color: Colors.cyan, fontSize: 20, fontWeight: FontWeight.w500)),
                    Text('$programme', style: const TextStyle(fontSize: 18, color: Colors.white)),
                    const Divider(color: Colors.grey),
                    Text('$informationsCncert', style: const TextStyle(fontSize: 18, color: Colors.white)),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.cyan),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
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
