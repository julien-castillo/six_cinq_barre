import 'package:flutter/material.dart';
import 'package:app_six_cinq_barre/main.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ContributionPage extends StatelessWidget {
  const ContributionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.cyan,
          title: const Text('Cotisations')),
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildGlassmorphicRectangle1(
              context,
              Icons.euro,
              "Cotisation",
              "Votre contribution est précieuse !",
              "Merci d'utiliser le RIB ci-dessous pour régler votre cotisation.",
            ),
            const SizedBox(height: 80),
            _buildGlassmorphicRectangle2(
              context,
              "Montant de la cotisation :",
              "30 € (minimum !)",
            ),
            const SizedBox(height: 20),
            _buildGlassmorphicCreditCard(
              context,
              "123 123", // Exemple de RIB
              "BNPPBP", // Si $bic est utilisée
            ),
          ],
        ),
      ),
      floatingActionButton: GestureDetector(
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MyApp()),
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
                  // colorFilter: const ColorFilter.mode(Color(0xFF00BCD4), BlendMode.srcIn),
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
          const Text(
            "FR76 3000 4000 1234 5678 9012 121", // RIB à mettre
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 15),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Code BIC: BNPAFRPP",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              Text(
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
