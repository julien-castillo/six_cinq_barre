import 'package:app_six_cinq_barre/pages/login_page.dart';
import 'package:app_six_cinq_barre/pages/navigation_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:app_six_cinq_barre/gsheet_setup.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await gSheetInit();
  await initializeDateFormatting('fr_FR', null);
  final prefs = await SharedPreferences.getInstance();
  final rememberMe = prefs.getBool('rememberMe') ?? false;
  final musicianName = prefs.getString('musicianName');

  runApp(MyApp(rememberMe: rememberMe, musicianName: musicianName));
}

class MyApp extends StatelessWidget {
  final bool rememberMe;
  final String? musicianName;

  const MyApp({super.key, required this.rememberMe, this.musicianName});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: rememberMe && musicianName != null
          ? NavigationWrapper(initialIndex: 0, musicianName: musicianName!)
          : const LoginPage(),
    );
  }
}
