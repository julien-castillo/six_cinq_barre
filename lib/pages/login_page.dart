import 'package:flutter/material.dart';
import 'package:app_six_cinq_barre/pages/navigation_wrapper.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:app_six_cinq_barre/gsheet_setup.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slide_to_act/slide_to_act.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  String _errorMessage = '';
  bool _rememberMe = false;
  bool _isLoading = false;
  bool _isConnected = false;
  bool _isConnectionFailed = false;

  @override
  void initState() {
    super.initState();
  }

  void _toggleRememberMe(bool? value) {
    setState(() {
      _rememberMe = value ?? false;
    });
  }

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
                  const SizedBox(height: 10),
                  _buildLoginIcon(),
                  const SizedBox(height: 20),
                  _buildEmailField(),
                  const SizedBox(height: 20),
                  _buildCheckbox(),
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

  Widget _buildCheckbox() {
    return Theme(
      data: Theme.of(context).copyWith(
        unselectedWidgetColor: Colors.cyan,
      ),
      child: CheckboxListTile(
        title: const Text(
          'Me connecter automatiquement lors de ma prochaine visite',
          style: TextStyle(color: Colors.cyan),
        ),
        value: _rememberMe,
        onChanged: _toggleRememberMe,
        controlAffinity: ListTileControlAffinity.leading,
        activeColor: Colors.cyan,
        checkColor: Colors.white,
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.cyan.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.cyan,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10.0,
                spreadRadius: 2.0,
              ),
            ],
          ),
          padding: const EdgeInsets.all(0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SlideAction(
                onSubmit: _isLoading ? null : () => _verifyAndNavigate(context),
                text: "Connexion",
                sliderButtonIcon: const Icon(
                  Icons.lock_open_outlined,
                  color: Colors.white,
                ),
                sliderRotate: false,
                sliderButtonIconPadding: 14,
                innerColor: Colors.cyan,
                outerColor: Colors.cyan.withOpacity(0.2),
                textStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
                borderRadius: 12,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _verifyAndNavigate(BuildContext context) async {
    if (_isLoading) return;
    setState(() {
      _errorMessage = '';
      _isLoading = true;
      _isConnected = false;
      _isConnectionFailed = false;
    });

    final email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() {
        _errorMessage = 'Veuillez entrer un email';
        _isLoading = false;
        _isConnectionFailed = true;
      });
      return;
    }

    try {
      print("Vérification de l'email : $email");
      final result = await verifyEmail(email);
      print("Résultat de verifyEmail : $result");

      if (result['isValid'] == 'true') {
        setState(() {
          _isConnected = true;
          _isConnectionFailed = false;
        });

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
            'musicianName', result['musicianName'] ?? 'Musicien');
        await prefs.setBool('rememberMe', _rememberMe);
        await prefs.setBool('isAdmin', result['isAdmin'] ?? false);
        final musicianName = prefs.getString('musicianName') ?? 'Musicien';

        // Attendre un court instant pour montrer l'icône de succès
        await Future.delayed(const Duration(milliseconds: 500));

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
          _isConnectionFailed = true;
        });
      }
    } catch (e) {
      print("Erreur dans _verifyAndNavigate : $e");
      setState(() {
        _errorMessage = 'Une erreur est survenue. Veuillez réessayer.';
        _isConnectionFailed = true;
      });
    } finally {
      setState(() {
        _isLoading = false;
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
    Color iconColor;
    IconData iconData;

    if (_isConnected) {
      iconColor = Colors.green;
      iconData = Icons.check;
    } else if (_isConnectionFailed) {
      iconColor = Colors.red;
      iconData = Icons.lock_outline;
    } else {
      iconColor = Colors.cyan;
      iconData = Icons.lock_outline;
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: iconColor, width: 2),
        shape: BoxShape.circle,
      ),
      padding: const EdgeInsets.all(20),
      child: Icon(iconData, color: iconColor, size: 80),
    );
  }
}
