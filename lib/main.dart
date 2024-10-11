import 'package:app_six_cinq_barre/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'dart:async';
import 'package:app_six_cinq_barre/pages/navigation_wrapper.dart'; // Import du NavigationWrapper
import 'package:app_six_cinq_barre/gsheet_setup.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await gSheetInit();
  await initializeDateFormatting('fr_FR', null);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: true,
      home: NavigationWrapper(
        initialIndex: 0,
        child: HomePage(),
      ),
    );
  }
}
