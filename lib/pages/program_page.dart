import 'package:app_six_cinq_barre/gsheet_setup.dart';
import 'package:app_six_cinq_barre/pages/navigation_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProgramPage extends StatefulWidget {
  const ProgramPage({super.key});

  @override
  _ProgramPageState createState() => _ProgramPageState();
}

class _ProgramPageState extends State<ProgramPage> {
  List<Map<String, String>> dataFromSheet = [];

  @override
  void initState() {
    super.initState();
    readDataProgramFromSheet();
  }

  Future<void> readDataProgramFromSheet() async {
    var rawSheetData = await gsheetProgramDetails!.values.map.allRows();
    if (rawSheetData != null) {
      setState(() {
        dataFromSheet = rawSheetData.map((row) {
          return {
            'title': row['program_title'] ?? '',
            'subtitle': row['program_subtitle'] ?? '',
            'text': row['program_text'] ?? '',
          };
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.cyan,
        title: const Text('Programme'),
      ),
      backgroundColor: Colors.black,
      body: dataFromSheet.isEmpty
          ? const Center(child: CircularProgressIndicator(color: Colors.cyan))
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: dataFromSheet.length + 1, // Augmente itemCount de 1
              itemBuilder: (context, index) {
                if (index == dataFromSheet.length) {
                  // Affiche le bouton "Accueil" après le dernier élément
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const SizedBox(height: 10),
                      _buildGlassmorphicButton(context, Icons.home, 'Accueil'),
                    ],
                  );
                }
                final row = dataFromSheet[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: _buildGlassmorphicRectangleProgram(
                    context,
                    Icons.theater_comedy,
                    row['title'] ?? "",
                    row['subtitle'] ?? "",
                    row['text'] ?? "",
                  ),
                );
              },
            ),
    );
  }

  Widget _buildGlassmorphicRectangleProgram(BuildContext context, IconData icon,
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 30, color: Colors.cyan),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 20, color: Colors.cyan),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            textAlign: TextAlign.center,
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
