import 'dart:async';
import 'dart:ui';
import 'dart:math'; // Ajouté pour utiliser Random
import 'package:app_six_cinq_barre/gsheet_setup.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RehearsalPage extends StatefulWidget {
  const RehearsalPage({super.key});

  @override
  State<RehearsalPage> createState() => _RehearsalPageState();
}

class _RehearsalPageState extends State<RehearsalPage> {
  final inputText = TextEditingController();
  List dataFromSheet = [];
  String? closestDate;

  @override
  void initState() {
    super.initState();
    readDataFromSheet();
  }

  Future<void> readDataFromSheet() async {
    dataFromSheet = (await gsheetCrudUserDetails!.values.map.allRows())!;
    if (dataFromSheet.isNotEmpty) {
      closestDate = getClosestFutureDate(dataFromSheet);
    } else {
      closestDate = null;
    }
    setState(() {});
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

  String getClosestFutureDate(List<dynamic> data) {
    DateTime today = DateTime.now();
    DateTime? closestDate;
    int closestDifference = double.maxFinite.toInt();

    for (var row in data) {
      if (row['date'] == null ||
          row['date'].isEmpty ||
          int.tryParse(row['date']) == null) {
        continue;
      }

      DateTime rowDate =
          DateTime(1899, 12, 30).add(Duration(days: int.parse(row['date'])));
      int difference = rowDate.difference(today).inDays;

      if (difference > 0 && difference < closestDifference) {
        closestDate = rowDate;
        closestDifference = difference;
      }
    }

    return closestDate != null
        ? DateFormat('dd/MM/yyyy').format(closestDate)
        : '';
  }

  @override
  Widget build(BuildContext context) {
    final saisonText = dataFromSheet.isNotEmpty
        ? dataFromSheet[0]['saison']
        : 'Mise à jour en cours...';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Text('$saisonText'),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.black, // Fond noir
        child: Stack(
          children: [
            // Ajout des cercles de couleurs aléatoires avec flou
            ...List.generate(10, (index) {
              final random = Random();
              final size = random.nextDouble() * 100 +
                  50; // Taille des cercles entre 50 et 150 pixels
              final top =
                  random.nextDouble() * MediaQuery.of(context).size.height;
              final left =
                  random.nextDouble() * MediaQuery.of(context).size.width;
              final color = Color.fromARGB(
                100 +
                    random.nextInt(
                        156), // Transparence pour créer un effet de superposition
                random.nextInt(256),
                random.nextInt(256),
                random.nextInt(256),
              );

              return Positioned(
                top: top,
                left: left,
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 0), // Flou ajouté
                  child: Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              );
            }),
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
                                closestDate != null && date == closestDate;

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
                                                  Text('$lieu : ',
                                                      style: const TextStyle(
                                                          color: Colors.cyan,
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.w500)),
                                                  Text('$adresse',
                                                      style: const TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.white,
                                                      )),
                                                  const Divider(
                                                      color: Colors.grey),
                                                  const Text('Programme : ',
                                                      style: TextStyle(
                                                          color: Colors.cyan,
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.w500)),
                                                  Text('$programme',
                                                      style: const TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.white,
                                                      )),
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
                                    ? Colors.cyan.withOpacity(0.9)
                                    : Colors.black.withOpacity(0.1),
                                margin: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 16),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(30),
                                    bottomLeft: Radius.circular(30),
                                  ),
                                ),
                                elevation: 10,
                                shadowColor: Colors.cyan.withOpacity(0.2),
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(30),
                                    bottomLeft: Radius.circular(30),
                                  ),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX: 30.0, sigmaY: 30.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(30),
                                          bottomLeft: Radius.circular(30),
                                        ),
                                        border: Border.all(
                                          color: Colors.white.withOpacity(0.2),
                                          width: 0.5,
                                        ),
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.white.withOpacity(0.2),
                                            Colors.white.withOpacity(0.05),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
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
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                            Text(
                                              'Lieu: $lieu',
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
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        subtitle: const Text(
                                          'Autre info si besoin',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white),
                                        ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await readDataFromSheet();
          setState(() {});
        },
        backgroundColor: Colors.cyan,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
