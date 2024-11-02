import 'package:app_six_cinq_barre/gsheet_setup.dart';
import 'package:app_six_cinq_barre/pages/navigation_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContributionPage extends StatefulWidget {
  const ContributionPage({super.key});

  @override
  _ContributionPageState createState() => _ContributionPageState();
}

class _ContributionPageState extends State<ContributionPage> {
  List<Map<String, dynamic>>? dataFromSheet;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      dataFromSheet = await gsheetContributionDetails!.values.map.allRows();
    } catch (e) {
      print('Erreur lors du chargement des données : $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.cyan,
        title: const Text('Cotisations'),
      ),
      backgroundColor: Colors.black,
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
              color: Colors.cyan,
            ))
          : dataFromSheet == null || dataFromSheet!.isEmpty
              ? const Center(child: Text('Aucune donnée trouvée.'))
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildGlassmorphicRectangle1(
                        context,
                        Icons.euro,
                        "Cotisation",
                        dataFromSheet![0]['cotisation_subtitle'] ??
                            "Sous-titre manquant",
                        dataFromSheet![0]['cotisation_text'] ??
                            "Texte manquant",
                      ),
                      const SizedBox(height: 80),
                      _buildGlassmorphicRectangle2(
                        context,
                        "Montant de la cotisation :",
                        dataFromSheet![0]['prix'] ?? "Prix manquant",
                      ),
                      const SizedBox(height: 20),
                      _buildGlassmorphicCreditCard(
                        context,
                        dataFromSheet![0]['RIB'] ?? "RIB manquant",
                        dataFromSheet![0]['BIC'] ?? "BIC manquant",
                      ),
                    ],
                  ),
                ),
      floatingActionButton: GestureDetector(
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
        child: _buildGlassmorphicButton(context, Icons.home, 'Accueil'),
      ),
    );
  }

  Widget _buildGlassmorphicRectangle1(BuildContext context, IconData icon,
      String title, String subtitle, String text) {
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
            mainAxisAlignment:
                MainAxisAlignment.center, // Centre le contenu de la ligne
            children: [
              Icon(icon, size: 30, color: const Color(0xFF00BCD4)),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(fontSize: 20, color: Colors.cyan),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 18, color: Colors.white),
          ),
          const SizedBox(height: 10),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassmorphicRectangle2(
      BuildContext context, String title, String subtitle) {
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
            mainAxisAlignment:
                MainAxisAlignment.center, // Centre le contenu de la ligne
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 20, color: Colors.cyan),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 18, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassmorphicCreditCard(
      BuildContext context, String rib, String bic) {
    return Container(
      width: 340,
      height: 200,
      padding: const EdgeInsets.all(8.0),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 0), // Remonter l'icône de la puce
                child: SvgPicture.asset(
                  "assets/images/chip_icon.svg",
                  colorFilter: const ColorFilter.mode(
                      Color.fromARGB(255, 252, 236, 15), BlendMode.srcIn),
                  height:
                      100, // Ajustement de la hauteur pour plus de précision
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 0), // Remonter l'icône CB
                child: SvgPicture.asset(
                  "assets/images/cb_sans_contact.svg",
                  colorFilter:
                      const ColorFilter.mode(Colors.cyan, BlendMode.srcIn),
                  height: 60, // Ajustement de la hauteur pour plus de précision
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            rib,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Code BIC: $bic",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              const Text(
                '6/5 barré', // Date d’expiration
                style: TextStyle(color: Colors.cyan, fontSize: 18),
              ),
            ],
          ),
        ],
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
}
