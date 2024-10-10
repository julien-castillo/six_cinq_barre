import 'dart:async';
import 'package:six_cinq_barre/gsheet_setup.dart';
import 'package:flutter/material.dart';
// import 'package:six_cinq_barre/pages/gsheet_crud.dart';
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
  // Vérifiez si serialDate est une chaîne vide ou non numérique
  if (serialDate.isEmpty || int.tryParse(serialDate) == null) {
    return ''; // Retourne une chaîne vide si la date n'est pas valide
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
    // Ajoutez une vérification pour vous assurer que 'date' existe et est valide
    if (row['date'] == null || row['date'].isEmpty || int.tryParse(row['date']) == null) {
      continue; // Ignore les lignes avec une date invalide
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
      : ''; // Retourne une chaîne vide si aucune date future n'est trouvée
}


  @override
  Widget build(BuildContext context) {
    final saisonText = dataFromSheet.isNotEmpty
        ? dataFromSheet[0]['saison']
        : 'Mise à jour en cours...';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('$saisonText'),
        centerTitle: true,
      ),
      body: dataFromSheet.isEmpty
          ? const Center(
              child: CircularProgressIndicator(color: Colors.orange),
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

                      // Vérifie si c'est la date future la plus proche
                      final isClosestFutureDate =
                          closestDate != null && date == closestDate;

                      return Card(
                        color: isClosestFutureDate
                            ? Colors.orangeAccent
                                .shade100 // Couleur de fond spéciale
                            : Colors.white,
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(30),
                                bottomLeft: Radius.circular(30),
                              ),
                            //   side: BorderSide(color: Colors.orange, width: 1)
                            ),
                            elevation: 10,
                            shadowColor: Colors.deepOrangeAccent,
                        child: InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            'assets/images/Guillemette_Daboval.jpg',
                                            height: 250,
                                            fit: BoxFit.cover,
                                            alignment: Alignment.topCenter,
                                          ),
                                          const SizedBox(height: 16),
                                          // const Divider(color: Colors.grey),
                                          // Text('Date: $date',
                                          //     style: const TextStyle(
                                          //         fontSize: 18)),
                                          // const Divider(color: Colors.grey),
                                          // Text('Heure: de $heure',
                                          //     style: const TextStyle(
                                          //         fontSize: 18)),
                                          // const Divider(color: Colors.grey),
                                          Text('$lieu : ',
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold)),
                                          // const Divider(color: Colors.grey),
                                          Text('$adresse',
                                              style: const TextStyle(
                                                  fontSize: 18)),
                                          const Divider(color: Colors.grey),
                                          const Text('Programme : ',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold)),
                                                  Text('$programme',
                                              style: const TextStyle(
                                                  fontSize: 18)),
                                          const Divider(color: Colors.grey),
                                          const Text('Formation : ',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold)),
                                                  Text('$formation',
                                              style: const TextStyle(
                                                  fontSize: 18)),
                                          const SizedBox(height: 16),
                                          Align(
                                            alignment: Alignment.bottomRight,
                                            child: IconButton(
                                              icon: const Icon(Icons.close,
                                                  color: Color.fromARGB(
                                                      255, 223, 149, 12)),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: ListTile(
                            leading: const Icon(
                              Icons.event,
                              size: 35,
                              color: Colors.orange,
                              ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '$date ($heure)',
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Lieu: $lieu',
                                  style: const TextStyle(fontSize: 18),
                                ),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      const TextSpan(
                                        text: 'Formation: ',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '$formation',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold
                                          // backgroundColor:
                                          //     Color.fromARGB(99, 23, 238, 238),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            subtitle: const Text(
                              'Autre info si besoin',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await readDataFromSheet();
          setState(() {});
        },
        backgroundColor: const Color.fromARGB(255, 223, 149, 12),
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
