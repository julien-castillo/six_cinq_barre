// import 'package:app_six_cinq_barre/gsheet_setup.dart';

// insertDataIntoSheet(userDetailsList) async {
//   await gsheetRehearsalsDetails!.values.map.appendRows(userDetailsList);
//   print('===> Data Stored in gsheet_app_65_barre ! <===');
// }

// insertDataIntoAdminSheet(adminDetailsList) async { // Fonction pour la feuille Admin
//   await gsheetMusiciansDetails!.values.map.appendRows(adminDetailsList);
//   print('===> Data Stored in Admin sheet ! <===');
// }

// List dataFromSheet = [];
// List dataFromAdminSheet = [];

// readDataFromSheet() async {
//   dataFromSheet = (await gsheetRehearsalsDetails!.values.map.allRows())!;
//   print('===> Data Fetched from gsheet_app_65_barre ! <===');
// }

// readDataFromAdminSheet() async { // Fonction pour lire la feuille Admin
//   dataFromAdminSheet = (await gsheetMusiciansDetails!.values.map.allRows())!;
//   print('===> Data Fetched from Admin sheet ! <===');
// }

// List<Map<String, String>> cordesMusicians = [];

// Future<void> readDataStringsFromAdminSheet() async {
//   List<Map<String, String>> allData = (await gsheetMusiciansDetails!.values.map.allRows())!;
  
//   // Filtrer les musiciens avec "Cordes" dans la colonne "pupitre"
//   cordesMusicians = allData.where((row) => row['pupitre'] == 'Cordes').toList();
  
//   // Rafraîchir l'affichage (utilise setState si tu es dans un StatefulWidget)
// }


// updateDataFromSheet() async {
//   await gsheetRehearsalsDetails!.values.map
//       .insertRowByKey('', {'name': 'updated New New Name'}); // ID
//   print('===> Data Updated ! <===');
// }

// updateDataFromAdminSheet() async { 
//   await gsheetMusiciansDetails!.values.map
//   .insertRowByKey('', {'name': 'updated New New Name'}); // ID
//   print('===> Data Updated ! <===');
// }

// deleteDataFromSheet() async {
//   final index = await gsheetRehearsalsDetails!.values.rowIndexOf(''); // ID
//   await gsheetRehearsalsDetails!.deleteRow(index);
//   print('===> Row Deleted ! <===');
// }

// deleteDataFromAdminSheet() async {
//   final index = await gsheetMusiciansDetails!.values.rowIndexOf(''); // ID
//   await gsheetMusiciansDetails!.deleteRow(index);
//   print('===> Row Deleted ! <===');
// }

// DateTime excelDateToDateTime(int excelDate) {
//   return DateTime(1900, 1, 1).add(Duration(days: excelDate - 2));
// }
