import 'package:flutter/material.dart';
import 'package:app_six_cinq_barre/pages/navigation_wrapper.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:app_six_cinq_barre/gsheet_setup.dart'; // Assurez-vous d'importer ce fichier

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
      body: Container(
        color: Colors.black,
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

  Widget _buildLoginButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _verifyAndNavigate(context),
      child: const SizedBox(
        width: double.infinity,
        child: Text(
          "Connexion",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20),
        ),
      ),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: Colors.cyan,
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
    );
  }

  Future<void> _verifyAndNavigate(BuildContext context) async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() {
        _errorMessage = 'Veuillez entrer un email';
      });
      return;
    }

    final isValid = await verifyEmail(email);
    if (isValid) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => const NavigationWrapper(initialIndex: 0)),
        (Route<dynamic> route) => false,
      );
    } else {
      setState(() {
        _errorMessage =
            'Email non reconnu, contactez Fabienne, Coralie ou Sarah';
      });
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

  // void _navigateToHomePage(BuildContext context) {
  //   Navigator.pushAndRemoveUntil(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => const NavigationWrapper(initialIndex: 0),
  //     ),
  //     (Route<dynamic> route) => false,
  //   );
  // }
}
