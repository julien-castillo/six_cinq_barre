import 'dart:async';
import 'dart:ui';
import 'package:app_six_cinq_barre/functions.dart';
import 'package:app_six_cinq_barre/gsheet_setup.dart';
import 'package:flutter/material.dart';

class RehearsalPage extends StatefulWidget {
  const RehearsalPage({super.key});

  @override
  State<RehearsalPage> createState() => _RehearsalPageState();
}

class _RehearsalPageState extends State<RehearsalPage> {
  final inputText = TextEditingController();
  List dataFromSheet = [];
  DateTime? closestDate;
  int? closestIndex;

  @override
  void initState() {
    super.initState();
    readDataFromSheet();
  }

  Future<void> readDataFromSheet() async {
    dataFromSheet = (await gsheetRehearsalsDetails!.values.map.allRows())!;
    if (dataFromSheet.isNotEmpty) {
      var closestData = getClosestFutureDate(dataFromSheet);
      closestDate = closestData?['date'];
      closestIndex =
          closestData?['index']; // Indice de la répétition la plus proche
    } else {
      closestDate = null;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: formatDaysUntilNextRehearsal(closestDate),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.black, // Fond noir
        child: Stack(
          children: [
            dataFromSheet.isEmpty
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.cyan),
                  )
                : SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ListView.builder(
                          itemCount: dataFromSheet.length,
                          controller: ScrollController(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final row = dataFromSheet[index];
                            final date = formatDateFromSheet(row['date']);
                            final lieu = row['lieu'];
                            final adresse = row['adresse'];
                            final heure = row['heure'];
                            final programme = row['programme'];
                            final formation = row['formation'];
                            final isClosestFutureDate =
                                closestIndex != -1 && index == closestIndex;
                            return GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Dialog(
                                      backgroundColor: Colors
                                          .transparent, // Rendre le fond transparent
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          child: BackdropFilter(
                                            filter: ImageFilter.blur(
                                                sigmaX: 30.0,
                                                sigmaY: 30.0), // Flou
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.8,
                                              padding:
                                                  const EdgeInsets.all(12.0),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                                color: Colors.white.withOpacity(
                                                    0.2), // Couleur de fond avec opacité
                                                border: Border.all(
                                                  color: Colors.cyan,
                                                  width: 0.8,
                                                ),
                                              ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  ClipOval(
                                                    // Utilisation de ClipOval pour créer un cercle
                                                    child: Image.asset(
                                                      'assets/images/Guillemette_Daboval.jpg',
                                                      height: 250,
                                                      width:
                                                          250, // Assurez-vous que la largeur et la hauteur sont égales
                                                      fit: BoxFit.cover,
                                                      alignment:
                                                          Alignment.topCenter,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 16),
                                                  Text('Répétition du $date : ',
                                                      style: const TextStyle(
                                                          color: Colors.orange,
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.w500)),
                                                  const Divider(
                                                      color: Colors.grey),
                                                  Text('$lieu : ',
                                                      style: const TextStyle(
                                                          color: Colors.cyan,
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.w500)),
                                                  Text(
                                                    '$adresse',
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.white,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  const Divider(
                                                      color: Colors.grey),
                                                  const Text('Programme : ',
                                                      style: TextStyle(
                                                          color: Colors.cyan,
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.w500)),
                                                  Text(
                                                    '$programme',
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.white,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  const Divider(
                                                      color: Colors.grey),
                                                  const Text('Formation : ',
                                                      style: TextStyle(
                                                          color: Colors.cyan,
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.w500)),
                                                  Text('$formation',
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 18)),
                                                  const SizedBox(height: 16),
                                                  Align(
                                                    alignment:
                                                        Alignment.bottomRight,
                                                    child: IconButton(
                                                      icon: const Icon(
                                                          Icons.close,
                                                          color: Colors.cyan),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
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
                              },
                              child: Card(
                                color: isClosestFutureDate
                                    ? Colors.cyan.withOpacity(0.3)
                                    : Colors.black.withOpacity(0.1),
                                margin: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 10,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  child: Container(
                                    padding: isClosestFutureDate
                                        ? EdgeInsets.all(12.0)
                                        : EdgeInsets.all(4.0),
                                    decoration: BoxDecoration(
                                      color: Colors.cyan.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(30),
                                      border: isClosestFutureDate
                                          ? Border.all(
                                              color: Colors.orange, width: 3)
                                          : Border.all(
                                              color: Colors.cyan,
                                              width: 1,
                                            ),
                                    ),
                                    child: ListTile(
                                      leading: const Icon(
                                        Icons.music_note,
                                        size: 30,
                                        color: Colors.cyanAccent,
                                      ),
                                      title: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '$date ($heure)',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: isClosestFutureDate
                                                  ? Colors.orange
                                                  : Colors.cyan,
                                            ),
                                          ),
                                          Text(
                                            '$lieu',
                                            style: const TextStyle(
                                                fontSize: 18,
                                                color: Colors.white),
                                          ),
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                const TextSpan(
                                                  text: 'Formation: ',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: '$formation',
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.cyan,
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                                ),
                                              ],
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
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
