import 'package:app_six_cinq_barre/pages/absences_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:app_six_cinq_barre/pages/contribution_page.dart';
import 'package:app_six_cinq_barre/pages/musicians_page.dart';
import 'package:app_six_cinq_barre/pages/program_page.dart';
import 'package:app_six_cinq_barre/pages/resources_page.dart';
import 'package:app_six_cinq_barre/gsheet_setup.dart';

class HomePage extends StatefulWidget {
  final String musicianName;
  const HomePage({Key? key, required this.musicianName}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List dataFromSheet = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final data = await readDataInformationsFromSheet();
      setState(() {
        dataFromSheet = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Erreur de chargement. Veuillez réessayer.';
        isLoading = false;
      });
      print('Erreur lors du chargement des données : $e');
    }
  }

  Future<List> readDataInformationsFromSheet() async {
    const maxRetries = 3;
    const retryDelay = Duration(seconds: 5);

    for (var i = 0; i < maxRetries; i++) {
      try {
        return await gsheetInformationsDetails!.values.map.allRows() ?? [];
      } catch (e) {
        if (e.toString().contains('Quota exceeded')) {
          if (i < maxRetries - 1) {
            await Future.delayed(retryDelay);
          } else {
            rethrow;
          }
        } else {
          rethrow;
        }
      }
    }
    throw Exception('Échec après $maxRetries tentatives');
  }

  // Future<void> readDataInformationsFromSheet() async {
  //   dataFromSheet = (await gsheetInformationsDetails!.values.map.allRows())!;
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Builder(
        builder: (context) {
          if (isLoading) {
            return const Center(
                child: CircularProgressIndicator(color: Colors.cyan));
          } else if (errorMessage.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(errorMessage, style: TextStyle(color: Colors.white)),
                  ElevatedButton(
                    onPressed: loadData,
                    child: const Text('Actualiser'),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.cyan),
                  ),
                ],
              ),
            );
          }
          return FutureBuilder<void>(
            future: readDataInformationsFromSheet(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator(color: Colors.cyan));
              } else if (snapshot.hasError) {
                return Center(
                    child: Text('Erreur de chargement des données',
                        style: TextStyle(color: Colors.white)));
              } else {
                return _buildHomeContent();
              }
            },
          );
        },
      ),
    );
  }

  Widget _buildHomeContent() {
    final informationsText =
        dataFromSheet.isNotEmpty && dataFromSheet[0]['informations'] != null
            ? dataFromSheet[0]['informations']
            : 'Aucune information particulière pour le moment ;-)';

    return Container(
      color: Colors.black,
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Text(
              //   "Bienvenue ${widget.musicianName}",
              //   style: const TextStyle(fontSize: 18, color: Colors.orange),
              //   textAlign: TextAlign.center,
              // ),
              const SizedBox(height: 10),
              _buildHeader(),
              const SizedBox(height: 10),
              _buildGlassmorphicRectangleInformations(
                context,
                "Informations :",
                informationsText,
              ),
              const SizedBox(height: 20),
              _buildGridView(),
              const SizedBox(height: 20),
              _buildGlassmorphicCardAbsences(
                context,
                'Absences',
                // Icons.picture_as_pdf,
                Colors.transparent,
                const Color(0xFF048B9A),
                AbsencesPage(musicianName: widget.musicianName,),
                const BorderRadius.only(
                  // topRight: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                  // topLeft: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
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
        Text(
          "Dirigé par Guillemette Daboval",
          style: TextStyle(fontSize: 20, color: Colors.cyan),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildGridView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 15.0,
        crossAxisSpacing: 15.0,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _buildGlassmorphicCard(
            context,
            'Cotisations',
            Icons.euro,
            Colors.transparent,
            const Color(0xFF048B9A),
            const ContributionPage(),
            const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
              bottomLeft: Radius.circular(30),
            ),
          ),
          _buildGlassmorphicCard(
            context,
            'Musiciens',
            Icons.people,
            Colors.transparent,
            const Color(0xFF048B9A),
            const MusiciansPage(),
            const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          _buildGlassmorphicCard(
            context,
            'Programme',
            Icons.menu_book,
            Colors.transparent,
            const Color(0xFF048B9A),
            const ProgramPage(),
            const BorderRadius.only(
              topLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
              bottomLeft: Radius.circular(30),
            ),
          ),
          _buildGlassmorphicCard(
            context,
            'Ressources',
            Icons.picture_as_pdf,
            Colors.transparent,
            const Color(0xFF048B9A),
            const ResourcesPage(),
            const BorderRadius.only(
              topRight: Radius.circular(30),
              bottomRight: Radius.circular(30),
              bottomLeft: Radius.circular(30),
            ),
          ),
          // const SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget _buildGlassmorphicCard(
    BuildContext context,
    String title,
    IconData icon,
    Color backgroundColor,
    Color overlayColor,
    Widget page,
    BorderRadius borderRadius,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: SizedBox(
        width: 120,
        height: 120,
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 50, color: Colors.cyan),
                const SizedBox(height: 5),
                Text(
                  title,
                  style: const TextStyle(fontSize: 20, color: Colors.cyan),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGlassmorphicRectangleInformations(
      BuildContext context, String title, String subtitle) {
    return Container(
      width: 380,
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
              Text(
                title,
                style: const TextStyle(fontSize: 20, color: Colors.cyan),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 18, color: Colors.orange),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildGlassmorphicCardAbsences(
    BuildContext context,
    String title,
    // IconData icon,
    Color backgroundColor,
    Color overlayColor,
    Widget page,
    BorderRadius borderRadius,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: SizedBox(
        width: 180,
        height: 60,
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon(icon, size: 50, color: Colors.cyan),
                const SizedBox(height: 5),
                Text(
                  title,
                  style: const TextStyle(fontSize: 20, color: Colors.cyan),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
