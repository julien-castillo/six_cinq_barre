import 'package:flutter/material.dart';
import 'package:app_six_cinq_barre/pages/navigation_wrapper.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:app_six_cinq_barre/gsheet_setup.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slide_to_act/slide_to_act.dart'; // Assurez-vous d'importer ce fichier

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topCenter,
            radius: 1,
            colors: [
              Colors.cyan,
              Colors.black,
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 50),
                  _buildLoginIcon(),
                  const SizedBox(height: 50),
                  _buildEmailField(),
                  const SizedBox(height: 20),
                  _buildLoginButton(context),
                  if (_errorMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text(
                        _errorMessage,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextField(
      controller: _emailController,
      style: const TextStyle(color: Colors.white),
      cursorColor: Colors.cyan,
      decoration: InputDecoration(
        labelText: "Email",
        labelStyle: const TextStyle(color: Colors.cyan),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Colors.cyan),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Colors.cyan),
        ),
      ),
    );
  }

  // Widget _buildLoginButton(BuildContext context) {
  //   return SlideAction(
  //     onSubmit: () =>
  //         _verifyAndNavigate(context), // Action lorsque le slide est terminé
  //     text: "Connexion", // Texte sur le bouton glissable
  //     sliderButtonIcon: const Icon(
  //       Icons.lock_open_outlined, // Icône du bouton de glissement
  //       color: Colors.white,
  //     ),
  //     sliderRotate: false,
  //     sliderButtonIconPadding: 14,
  //     innerColor: Colors.red, // Couleur intérieure du slider
  //     outerColor:
  //         Colors.cyan.withOpacity(0.2), // Couleur extérieure lors du glissement
  //     textStyle: const TextStyle(
  //       color: Colors.white, // Couleur du texte dans le slider
  //       fontSize: 18, // Taille du texte
  //       fontWeight: FontWeight.w500,
  //     ),
  //     borderRadius: 12, // Arrondi des bords
  //   );
  // }

  Widget _buildLoginButton(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.cyan.withOpacity(0.2), // Couleur de fond extérieure
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.cyan,
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
          padding: const EdgeInsets.all(0), // Espacement interne
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Alignement à gauche
            children: [
              SlideAction(
                onSubmit: _isLoading ? null : () => _verifyAndNavigate(context),
                text: "Connexion", // Texte sur le bouton glissable
                sliderButtonIcon: const Icon(
                  Icons.lock_open_outlined, // Icône du bouton de glissement
                  color: Colors.white,
                ),
                sliderRotate: false,
                sliderButtonIconPadding: 14,
                innerColor: Colors.cyan, // Couleur intérieure du slider
                outerColor: Colors.cyan
                    .withOpacity(0.2), // Couleur extérieure lors du glissement
                textStyle: const TextStyle(
                  color: Colors.white, // Couleur du texte dans le slider
                  fontSize: 18, // Taille du texte
                  fontWeight: FontWeight.w500,
                ),
                borderRadius: 12, // Arrondi des bords
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Widget _buildLoginButton(BuildContext context) {
  //   return ElevatedButton(
  //     onPressed: () => _verifyAndNavigate(context),
  //     child: const SizedBox(
  //       width: double.infinity,
  //       child: Text(
  //         "Connexion",
  //         textAlign: TextAlign.center,
  //         style: TextStyle(fontSize: 20),
  //       ),
  //     ),
  //     style: ElevatedButton.styleFrom(
  //       foregroundColor: Colors.black,
  //       backgroundColor: Colors.cyan,
  //       shape: const StadiumBorder(),
  //       padding: const EdgeInsets.symmetric(vertical: 16),
  //     ),
  //   );
  // }

  bool _isLoading = false;

  Future<void> _verifyAndNavigate(BuildContext context) async {
  if (_isLoading) return;

  setState(() {
    _errorMessage = '';
    _isLoading = true;
  });

  final email = _emailController.text.trim();
  if (email.isEmpty) {
    setState(() {
      _errorMessage = 'Veuillez entrer un email';
      _isLoading = false;
    });
    return;
  }

  try {
    // Log pour vérifier que l'email est envoyé correctement
    print("Vérification de l'email : $email");

    final result = await verifyEmail(email);

    // Log pour vérifier le contenu de la réponse
    print("Résultat de verifyEmail : $result");

    if (result['isValid'] == 'true') { // Vérifiez aussi s'il s'agit d'un booléen
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
          'musicianName', result['musicianName'] ?? 'Musicien');
      final musicianName = prefs.getString('musicianName') ?? 'Musicien';

      if (mounted) {
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
      }
    } else {
      setState(() {
        _errorMessage =
            'Email non reconnu, contactez Fabienne, Coralie ou Sarah';
      });
    }
  } catch (e) {
    // Capture d'erreur détaillée
    print("Erreur dans _verifyAndNavigate : $e");
    setState(() {
      _errorMessage = 'Une erreur est survenue. Veuillez réessayer.';
    });
  } finally {
    setState(() {
      _isLoading = false;
    });
  }
}

}

Widget _buildHeader() {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Orchestre",
            style: TextStyle(
              fontSize: 30,
              fontFamily: 'Poppins',
              color: Colors.cyan,
            ),
          ),
          const SizedBox(width: 10),
          SvgPicture.asset(
            "assets/images/65barre.svg",
            colorFilter: const ColorFilter.mode(Colors.cyan, BlendMode.srcIn),
            height: 75,
          ),
        ],
      ),
      const SizedBox(height: 20),
      const Text(
        "Dirigé par Guillemette Daboval",
        style: TextStyle(fontSize: 20, color: Colors.cyan),
        textAlign: TextAlign.center,
      ),
    ],
  );
}

Widget _buildLoginIcon() {
  return Container(
    decoration: BoxDecoration(
      border: Border.all(color: Colors.cyan, width: 2),
      shape: BoxShape.circle,
    ),
    padding: const EdgeInsets.all(20),
    child: const Icon(Icons.lock_outline, color: Colors.cyan, size: 80),
  );
}
