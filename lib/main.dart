import 'package:app_six_cinq_barre/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:app_six_cinq_barre/gsheet_setup.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await gSheetInit();
  await initializeDateFormatting('fr_FR', null);
  await SharedPreferences.getInstance();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: NavigationWrapper(initialIndex: 0),
      home : LoginPage(),
    );
  }
}
