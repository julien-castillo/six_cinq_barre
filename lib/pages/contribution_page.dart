import 'package:app_six_cinq_barre/gsheet_setup.dart';
import 'package:app_six_cinq_barre/pages/navigation_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:flutter/services.dart';

class ContributionPage extends StatefulWidget {
  const ContributionPage({super.key});

  @override
  _ContributionPageState createState() => _ContributionPageState();
}

class _ContributionPageState extends State<ContributionPage> {
  List<Map<String, dynamic>>? dataFromSheet;
  bool isLoading = true;
  String musicianName = '';
  bool cotisationPayee = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      // Charger les données de contribution
      dataFromSheet = await gsheetContributionDetails!.values.map.allRows();

      // Récupérer le nom du musicien depuis SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      musicianName = prefs.getString('musicianName') ?? 'Musicien';

      // Récupérer le statut de cotisation depuis la feuille "musiciens"
      final musicianData = await gsheetMusiciansDetails!.values.map.allRows();
      final musician = musicianData?.firstWhere(
        (row) => row['musicien'] == musicianName,
        orElse: () => {},
      );
      cotisationPayee = musician?['cotisation'] == 'true';
    } catch (e) {
      print('Erreur lors du chargement des données : $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

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
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 15),
                        _buildGlassmorphicRectangle1(
                          context,
                          Icons.euro,
                          "Cotisation",
                          dataFromSheet![0]['cotisation_subtitle'] ??
                              "Sous-titre manquant",
                          dataFromSheet![0]['cotisation_text'] ??
                              "Texte manquant",
                        ),
                        const SizedBox(height: 15),
                        _buildGlassmorphicRectangleCotisation(
                          context,
                          musicianName,
                          cotisationPayee,
                        ),
                        const SizedBox(height: 15),
                        _buildGlassmorphicRectangle2(
                          context,
                          "Montant de la cotisation :",
                          dataFromSheet![0]['prix'] ?? "Prix manquant",
                        ),
                        const SizedBox(height: 15),
                        _buildGlassmorphicCreditCard(
                          context,
                          dataFromSheet![0]['RIB'] ?? "RIB manquant",
                          dataFromSheet![0]['BIC'] ?? "BIC manquant",
                        ),
                        const SizedBox(height: 15),
                        _buildSlideToActButton(context),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: _buildGlassmorphicButton(
                              context, Icons.home, 'Accueil'),
                        ),
                      ],
                    ),
                  ),
                ),
      // floatingActionButton: GestureDetector(
      //   onTap: () async {
      //     final prefs = await SharedPreferences.getInstance();
      //     final musicianName = prefs.getString('musicianName') ?? 'Musicien';
      //     Navigator.pushAndRemoveUntil(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => NavigationWrapper(
      //           initialIndex: 0,
      //           musicianName: musicianName,
      //         ),
      //       ),
      //       (Route<dynamic> route) => false,
      //     );
      //   },
      //   child: _buildGlassmorphicButton(context, Icons.home, 'Accueil'),
      // ),
    );
  }

  Widget _buildSlideToActButton(BuildContext context) {
    return Container(
      width: 300,
      // padding: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.cyan, width: 1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: SlideAction(
        text: "Copier l'IBAN",
        textStyle: const TextStyle(
          color: Colors.cyan,
          fontSize: 18,
        ),
        outerColor: Colors.cyan.withOpacity(0.2),
        innerColor: Colors.cyan,
        sliderButtonIcon: const Icon(
          Icons.arrow_circle_right_outlined,
          color: Colors.black,
        ),
        borderRadius: 12,
        elevation: 0,
        sliderRotate: false,
        sliderButtonIconPadding: 14,
        submittedIcon: const Icon(
          Icons.check,
          color: Colors.green,
        ),
        onSubmit: () {
          final rib = dataFromSheet![0]['RIB'] ?? "RIB manquant";
          Clipboard.setData(ClipboardData(text: rib));
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('IBAN copié dans le presse-papiers')),
          );
          return Future.value(false); // Permet de réinitialiser le slider
        },
      ),
    );
  }

  Widget _buildGlassmorphicRectangle1(BuildContext context, IconData icon,
      String title, String subtitle, String text) {
    return Container(
      width: 340,
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

  Widget _buildGlassmorphicRectangleCotisation(
      BuildContext context, String title, bool cotisationPayee) {
    return Container(
      width: 340,
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
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "- $musicianName - ",
            style: const TextStyle(fontSize: 20, color: Colors.cyan),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                cotisationPayee ? Icons.check_circle : Icons.warning,
                color: cotisationPayee ? Colors.green : Colors.orange,
                size: 24,
              ),
              SizedBox(width: 8),
              Flexible(
                child: Text(
                  cotisationPayee
                      ? "Ta cotisation est réglée pour cette saison, merci !"
                      : "N'oublie pas de régler ta cotisation !",
                  style: TextStyle(
                    fontSize: 18,
                    color: cotisationPayee ? Colors.green : Colors.orange,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGlassmorphicRectangle2(
      BuildContext context, String title, String subtitle) {
    return Container(
      width: 340,
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
