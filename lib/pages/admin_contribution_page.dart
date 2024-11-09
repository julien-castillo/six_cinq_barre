import 'package:app_six_cinq_barre/gsheet_setup.dart';
import 'package:app_six_cinq_barre/pages/navigation_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:clipboard/clipboard.dart';

class AdminContributionPage extends StatefulWidget {
  const AdminContributionPage({Key? key}) : super(key: key);

  @override
  _AdminContributionPageState createState() => _AdminContributionPageState();
}

class _AdminContributionPageState extends State<AdminContributionPage> {
  Map<String, List<Map<String, String>>> contributionLists = {
    'paid': [],
    'unpaid': []
  };
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadContributionData();
  }

  Future<void> _loadContributionData() async {
    final data = await getContributionMusicians();
    setState(() {
      contributionLists = data;
      isLoading = false;
    });
  }

  Future<void> _copyUnpaidEmails() async {
    final unpaidEmails = contributionLists['unpaid']!
        .map((musician) => musician['email'])
        .where((email) => email != null)
        .join(';');

    await FlutterClipboard.copy(unpaidEmails);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('E-mails copiés dans le presse-papier')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Suivi des Cotisations (Admin)'),
        backgroundColor: Colors.cyan,
      ),
      backgroundColor: Colors.black,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildGlassmorphicAdminHeader(context),
                    const SizedBox(height: 20),
                    _buildGlassmorphicList(
                      context,
                      "Cotisations payées (${contributionLists['paid']!.length})",
                      contributionLists['paid']!,
                      Colors.green, // Couleur de l'icône et de la bordure verte
                      Colors.green.withOpacity(0.5), // Bordure verte
                    ),
                    const SizedBox(height: 20),
                    _buildGlassmorphicList(
                      context,
                      "Cotisations non payées (${contributionLists['unpaid']!.length})",
                      contributionLists['unpaid']!,
                      Colors.red, // Couleur de l'icône et de la bordure rouge
                      Colors.red.withOpacity(0.5), // Bordure rouge
                    ),
                    const SizedBox(height: 50),
                    _buildSlideToActButton(),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerRight,
                      child: _buildGlassmorphicButton(
                          context, Icons.home, 'Accueil'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSlideToActButton() {
    return Container(
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
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Copier les e-mails des retardataires...",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.orange,
            ),
          ),
          const SizedBox(height: 10),
          SlideAction(
            text: 'Glissez pour copier les e-mails',
            sliderButtonIcon: Icon(
              Icons.copy,
              color: Colors.white,
              size: 20,
            ),
            sliderRotate: false,
            sliderButtonIconPadding: 14,
            innerColor: Colors.cyan,
            outerColor: Colors.cyan.withOpacity(0.2),
            textStyle: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            borderRadius: 12,
            onSubmit: () async {
              await _copyUnpaidEmails();
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGlassmorphicList(
    BuildContext context,
    String title,
    List<Map<String, String>> musicians,
    Color iconColor,
    Color borderColor,
  ) {
    bool isExpanded = false;

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return GestureDetector(
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            width: 340,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.cyan.withOpacity(0.2),
              border:
                  Border.all(color: borderColor, width: 2),
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
                    Expanded(
                      child: Text(
                        title,
                        style:
                            const TextStyle(fontSize: 20, color: Colors.cyan),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Icon(
                      isExpanded ? Icons.expand_less : Icons.expand_more,
                      color: Colors.cyan,
                    ),
                  ],
                ),
                if (isExpanded)
                  Column(
                    children: [
                      const SizedBox(height: 20),
                      ...musicians
                          .map((musician) => Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Row(
                                  children: [
                                    Icon(Icons.person,
                                        color: iconColor, size: 30),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        musician['name'] ??
                                            '', // Utilisez 'name' au lieu de l'ensemble de la chaîne
                                        style: const TextStyle(
                                            fontSize: 18, color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ))
                          .toList(),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildGlassmorphicAdminHeader(
    BuildContext context,
  ) {
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
              const SizedBox(width: 10),
              Text(
                "Section Admin -> Cotisations",
                style: const TextStyle(fontSize: 20, color: Colors.orange),
                textAlign: TextAlign.center,
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
