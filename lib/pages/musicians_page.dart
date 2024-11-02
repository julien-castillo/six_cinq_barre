import 'package:app_six_cinq_barre/functions.dart';
import 'package:app_six_cinq_barre/gsheet_setup.dart';
import 'package:app_six_cinq_barre/pages/brass_page.dart';
import 'package:app_six_cinq_barre/pages/navigation_wrapper.dart';
import 'package:app_six_cinq_barre/pages/percussions_page.dart';
import 'package:app_six_cinq_barre/pages/strings_page.dart';
import 'package:app_six_cinq_barre/pages/woodwinds_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MusiciansPage extends StatefulWidget {
  const MusiciansPage({super.key});

  @override
  _MusiciansPageState createState() => _MusiciansPageState();
}

class _MusiciansPageState extends State<MusiciansPage> {
  List<Map<String, dynamic>> _currentMonthBirthdays = [];
  List<Map<String, dynamic>> _nextMonthBirthdays = [];
  String currentMonthName = '';
  String nextMonthName = '';

  @override
  void initState() {
    super.initState();
    readDataFromAdminSheet();
    _setMonthNames();
  }

  void _setMonthNames() {
    Intl.defaultLocale = 'fr_FR';

    DateTime now = DateTime.now();
    currentMonthName = DateFormat('MMMM').format(now);

    // Calculer le mois prochain
    DateTime nextMonth = DateTime(now.year, now.month + 1, 1);
    nextMonthName = DateFormat('MMMM').format(nextMonth);
  }

  void readDataFromAdminSheet() async {
    try {
      List<Map<String, dynamic>> data = await fetchGoogleSheetsData();

      DateFormat format = DateFormat('dd/MM/yyyy');
      DateTime now = DateTime.now();

      setState(() {
        _currentMonthBirthdays = data.where((entry) {
          var birthdayValue = entry['birthday'];
          DateTime? birthday;

          // Vérifier si la valeur est un nombre (numéro de série)
          if (birthdayValue is num) {
            birthday = DateTime.fromMillisecondsSinceEpoch(
                (birthdayValue.toInt() - 25569) * 86400000);
          } else if (birthdayValue is String && birthdayValue.isNotEmpty) {
            try {
              birthday = format.parse(birthdayValue);
            } catch (e) {
              print(
                  "Erreur lors du parsing de la date pour ${entry['musicien']}: $e");
            }
          }

          // Vérifier si l'anniversaire est dans le mois actuel
          return birthday != null && birthday.month == now.month;
        }).toList();

        // Trier les anniversaires du mois actuel par jour et mois en ordre décroissant
        _currentMonthBirthdays.sort((a, b) {
          DateTime dateA = format.parse(a['birthday']);
          DateTime dateB = format.parse(b['birthday']);

          // Comparer d'abord par mois en ordre décroissant
          if (dateA.month == dateB.month) {
            // Ensuite comparer par jour en ordre décroissant
            return dateA.day.compareTo(dateB.day);
          } else {
            return dateA.month.compareTo(dateB.month);
          }
        });

        // Filtrer les anniversaires du mois suivant
        _nextMonthBirthdays = data.where((entry) {
          var birthdayValue = entry['birthday'];
          DateTime? birthday;

          // Vérifier si la valeur est un nombre (numéro de série)
          if (birthdayValue is num) {
            birthday = DateTime.fromMillisecondsSinceEpoch(
                (birthdayValue.toInt() - 25569) * 86400000);
          } else if (birthdayValue is String && birthdayValue.isNotEmpty) {
            try {
              birthday = format.parse(birthdayValue);
            } catch (e) {
              print(
                  "Erreur lors du parsing de la date pour ${entry['musicien']}: $e");
            }
          }

          // Vérifier si l'anniversaire est dans le mois suivant
          return birthday != null && birthday.month == (now.month % 12) + 1;
        }).toList();

        // Trier les anniversaires du mois suivant par jour et mois en ordre décroissant
        _nextMonthBirthdays.sort((a, b) {
          DateTime dateA = format.parse(a['birthday']);
          DateTime dateB = format.parse(b['birthday']);

          // Comparer d'abord par mois en ordre décroissant
          if (dateA.month == dateB.month) {
            // Ensuite comparer par jour en ordre décroissant
            return dateA.day.compareTo(dateB.day);
          } else {
            return dateA.month.compareTo(dateB.month);
          }
        });
      });
    } catch (e) {
      print("Erreur lors de la récupération des données : $e");
    }
  }

  // Fonction pour récupérer les données depuis Google Sheets
  Future<List<Map<String, dynamic>>> fetchGoogleSheetsData() async {
    // Récupérer les données depuis Google Sheets
    var dataFromAdminSheet =
        (await gsheetMusiciansDetails!.values.map.allRows())!;

    // Transformer les données pour extraire les noms et les anniversaires
    List<Map<String, dynamic>> musiciansData = [];

    for (var row in dataFromAdminSheet) {
      musiciansData.add({
        'musicien': row[
            'musicien'], // Assurez-vous que la clé 'nom' existe dans vos données
        'birthday': formatDateFromSheet(
            row['birthday']!), // Assurez-vous que la clé 'birthday' existe
      });
    }

    return musiciansData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.cyan,
        title: const Text('Musiciens'),
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
      child: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const SizedBox(
                        height:
                            20),
                    _buildBirthdaySection(
                        'Anniversaire(s) du mois', _currentMonthBirthdays),
                    const SizedBox(
                        height:
                            20), // Espace réduit entre les deux sections d'anniversaires
                    _buildBirthdaySection(
                        'Anniversaire(s) en $nextMonthName', _nextMonthBirthdays),
                    const SizedBox(
                        height:
                            10), // Espace réduit entre les deux sections d'anniversaires
                  ],
                ),
              ),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  padding: const EdgeInsets.all(20.0),
                  mainAxisSpacing: 20.0,
                  crossAxisSpacing: 20.0,
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  children: [
                    _buildGlassmorphicCard(
                      context,
                      'Cordes',
                      'assets/images/cello.svg',
                      const Color.fromARGB(0, 0, 0, 0),
                      const Color(0xFF048B9A),
                      const StringsPage(),
                      const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                        bottomLeft: Radius.circular(30),
                      ),
                      110.0,
                      Colors.cyan,
                    ),
                    _buildGlassmorphicCard(
                      context,
                      'Bois',
                      'assets/images/oboe.svg',
                      const Color.fromARGB(0, 0, 0, 0),
                      const Color(0xFF048B9A),
                      const WoodwindsPage(),
                      const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                      110.0,
                      Colors.cyan,
                    ),
                    _buildGlassmorphicCard(
                      context,
                      'Cuivres',
                      'assets/images/horn.svg',
                      const Color.fromARGB(0, 0, 0, 0),
                      const Color(0xFF048B9A),
                      const BrassPage(),
                      const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                        bottomLeft: Radius.circular(30),
                      ),
                      110.0,
                      Colors.cyan,
                    ),
                    _buildGlassmorphicCard(
                      context,
                      'Percussions & harpe',
                      'assets/images/timpani_harp.svg',
                      const Color.fromARGB(0, 0, 0, 0),
                      const Color(0xFF048B9A),
                      const PercussionsPage(),
                      const BorderRadius.only(
                        topRight: Radius.circular(30),
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                      110.0,
                      Colors.cyan,
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20.0, right: 20.0),
                  child: GestureDetector(
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
                    child: _buildGlassmorphicButton(
                        context, Icons.home, 'Accueil'),
                  ),
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
    String svgAssetPath,
    Color backgroundColor,
    Color overlayColor,
    Widget page,
    BorderRadius borderRadius,
    double svgSize,
    Color svgColor,
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 15),
                SvgPicture.asset(
                  svgAssetPath,
                  height: svgSize,
                  width: svgSize,
                  colorFilter: ColorFilter.mode(svgColor, BlendMode.srcIn),
                ),
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

  Widget _buildBirthdaySection(String title, List<Map<String, dynamic>> birthdays) {
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
            const Icon(Icons.cake, color: Colors.yellow), // Icône d'anniversaire
            const SizedBox(width: 8), // Espacement entre l'icône et le texte
            Text(
              title,
              style: const TextStyle(fontSize: 20, color: Colors.cyan),
            ),
          ],
        ),
        const SizedBox(height: 10),
        birthdays.isNotEmpty
            ? Wrap(
                spacing: 10.0,
                children: birthdays.map((birthday) {
                  // Vérifier si l'anniversaire est aujourd'hui
                  bool isToday = _isToday(birthday['birthday']);
                  
                  // Afficher "aujourd'hui" ou la date formatée
                  String displayDate = isToday
                      ? 'aujourd\'hui !'
                      : _formatBirthdayDate(birthday['birthday']);
                  
                  return Container(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      '- ${birthday['musicien']} ($displayDate)',
                      style: TextStyle(
                        color: isToday ? Colors.orange : Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  );
                }).toList(),
              )
            : const Text(
                "Aucun anniversaire à souhaiter",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontStyle: FontStyle.italic),
              ),
      ],
    ),
  );
}

String _formatBirthdayDate(String date) {
  // Parser la date pour récupérer le jour et le mois
  DateTime parsedDate = DateFormat('dd/MM/yyyy').parse(date);
  return DateFormat('d MMMM').format(parsedDate); // Format "12 novembre"
}

bool _isToday(String date) {
  DateTime parsedDate = DateFormat('dd/MM/yyyy').parse(date);
  DateTime today = DateTime.now();
  return parsedDate.day == today.day && parsedDate.month == today.month;
}


}
