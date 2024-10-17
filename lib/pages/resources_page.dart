import 'package:app_six_cinq_barre/gsheet_setup.dart';
import 'package:flutter/material.dart';
import 'package:app_six_cinq_barre/main.dart';
import 'package:url_launcher/url_launcher.dart';

class ResourcesPage extends StatefulWidget {
  const ResourcesPage({super.key});

  @override
  _ResourcesPageState createState() => _ResourcesPageState();
}

class _ResourcesPageState extends State<ResourcesPage> {
  List<Map<String, String>> dataFromSheet = [];

  @override
  void initState() {
    super.initState();
    readDataResourcesFromSheet();
  }

  Future<void> readDataResourcesFromSheet() async {
    var rawSheetData = await gsheetResourcesDetails!.values.map.allRows();
    if (rawSheetData != null) {
      setState(() {
        dataFromSheet = rawSheetData.map((row) {
          return {
            'partitions_subtitle': row['partitions_subtitle'] ?? '',
            'partitions_text': row['partitions_text'] ?? '',
            'partitions_link': row['partitions_link'] ?? '',
            'ressource_title': row['ressource_title'] ?? '',
            'ressource_icon': row['ressource_icon'] ?? '',
            'ressource_title_icon': row['ressource_title_with_icon'] ?? '',
            'ressource_text_with_icon': row['ressource_text_with_icon'] ?? '',
            'ressource_text': row['ressource_text'] ?? '',
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
        title: const Text('Ressources'),
      ),
      backgroundColor: Colors.black,
      body: dataFromSheet.isEmpty
          ? const Center(child: CircularProgressIndicator(color: Colors.cyan))
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: dataFromSheet.length,
              itemBuilder: (context, index) {
                final row = dataFromSheet[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if ((row['partitions_subtitle'] ?? "").isNotEmpty ||
                        (row['partitions_text'] ?? "").isNotEmpty ||
                        (row['partitions_link'] ?? "").isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: _buildGlassmorphicRectangle1(
                          context,
                          Icons.music_note,
                          row['partitions_subtitle'] ?? "",
                          row['partitions_text'] ?? "",
                          row['partitions_link'] ?? "",
                        ),
                      ),
                    if ((row['ressource_title_icon'] ?? "").isNotEmpty ||
                        (row['ressource_text_with_icon'] ?? "").isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: _buildGlassmorphicRectangle2(
                          context,
                          row['ressource_title_icon'] ?? "",
                          row['ressource_text_with_icon'] ?? "",
                        ),
                      ),
                    if ((row['ressource_title'] ?? "").isNotEmpty ||
                        (row['ressource_text'] ?? "").isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: _buildGlassmorphicRectangle3(
                          context,
                          row['ressource_title'] ?? "",
                          row['ressource_text'] ?? "",
                        ),
                      ),
                  ],
                );
              },
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 48.0),
        child: GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MyApp()),
            );
          },
          child: _buildGlassmorphicButton(context, Icons.home, 'Accueil'),
        ),
      ),
    );
  }

  Widget _buildGlassmorphicRectangle1(
    BuildContext context,
    IconData icon,
    String subtitle,
    String text,
    String link,
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
              Icon(icon, size: 30, color: const Color(0xFF00BCD4)),
              const SizedBox(width: 10),
                Text(
                  "Partitions",
                  style: const TextStyle(fontSize: 20, color: Colors.cyan),
                  textAlign: TextAlign.center,
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
          Column(
            children: [
              Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () => _launchURL(link),
                child: const Icon(
                  Icons.picture_as_pdf,
                  color: Colors.yellow,
                  size: 50,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _buildGlassmorphicRectangle2(
      BuildContext context, String title, String text) {
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
                Text(
                  title,
                  style: const TextStyle(fontSize: 20, color: Color(0xFF00BCD4)),
                  textAlign: TextAlign.center,
                ),
            ],
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

  Widget _buildGlassmorphicRectangle3(BuildContext context, String title, String text) {
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
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(fontSize: 20, color: Colors.cyan),
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
                      const SizedBox(height: 10),
                      Text(
                        text,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildGlassmorphicButton(BuildContext context, IconData icon, String text) {
    return Container(
      width: 140,
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.cyan),
          const SizedBox(width: 10),
          Text(
            text,
            style: const TextStyle(fontSize: 18, color: Colors.cyan),
          ),
        ],
      ),
    );
  }
}
