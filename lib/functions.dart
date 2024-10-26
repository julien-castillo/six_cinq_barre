import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatDateFromSheet(String serialDate) {
  if (serialDate.isEmpty || int.tryParse(serialDate) == null) {
    return '';
  }

  final baseDate = DateTime(1899, 12, 30);
  final serialNumber = int.parse(serialDate);
  final date = baseDate.add(Duration(days: serialNumber));
  return DateFormat('dd/MM/yyyy').format(date);
}

String formatDateFromSheetWhithoutYear(String serialDate) {
  if (serialDate.isEmpty || int.tryParse(serialDate) == null) {
    return '';
  }

  final baseDate = DateTime(1899, 12, 30);
  final serialNumber = int.parse(serialDate);
  final date = baseDate.add(Duration(days: serialNumber));

  // Utilisation de la bibliothèque intl pour formater la date en "jour mois"
  return DateFormat('d MMMM', 'fr_FR').format(date);
}

Map<String, dynamic>? getClosestFutureDate(List<dynamic> data) {
  DateTime today = DateTime.now();
  DateTime? closestDate;
  int closestDifference = double.maxFinite.toInt();
  int closestIndex = -1;

  for (var index = 0; index < data.length; index++) {
    var row = data[index];
    if (row['date'] == null ||
        row['date'].isEmpty ||
        int.tryParse(row['date']) == null) {
      continue;
    }

    DateTime rowDate =
        DateTime(1899, 12, 30).add(Duration(days: int.parse(row['date'])));
    int difference = rowDate.difference(today).inDays;

    if (difference >= 0 && difference < closestDifference) {
      closestDate = rowDate;
      closestDifference = difference;
      closestIndex = index;
    }
  }

  return closestIndex != -1
      ? {'date': closestDate, 'index': closestIndex}
      : null;
}

RichText formatDaysUntilNextRehearsal(DateTime? closestDate) {
  if (closestDate == null) {
    return RichText(
      text: TextSpan(
        text: "Aucune répétition à venir",
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
  }

  DateTime today = DateTime.now();
  if (closestDate.year == today.year &&
      closestDate.month == today.month &&
      closestDate.day == today.day) {
    return RichText(
      text: TextSpan(
        text: "Prochaine répétition : ",
        style:
            TextStyle(color: Colors.white, fontSize: 20), // Couleur par défaut
        children: [
          TextSpan(
            text: "aujourd'hui !",
            style:
                TextStyle(color: Colors.orange, fontSize: 20), // Couleur orange
          ),
        ],
      ),
    );
  } else if (closestDate.year == today.year &&
      closestDate.month == today.month &&
      closestDate.day == today.day + 1) {
    return RichText(
      text: TextSpan(
        text: "Prochaine répétition: ",
        style:
            TextStyle(color: Colors.white, fontSize: 20), // Couleur par défaut
        children: [
          TextSpan(
            text: "demain !",
            style:
                TextStyle(color: Colors.orange, fontSize: 20), // Couleur orange
          ),
        ],
      ),
    );
  } else {
    final difference = closestDate.difference(today).inDays + 1;
    return RichText(
      text: TextSpan(
        text: "Prochaine répétition dans:  ",
        style:
            TextStyle(color: Colors.white, fontSize: 20), // Couleur par défaut
        children: [
          TextSpan(
            text: "$difference jours",
            style:
                TextStyle(color: Colors.orange, fontSize: 20), // Couleur orange
          ),
        ],
      ),
    );
  }
}

String normalizeName(String name) {
  const Map<String, String> accentsMap = {
    'à': 'a',
    'â': 'a',
    'ä': 'a',
    'á': 'a',
    'ã': 'a',
    'è': 'e',
    'ê': 'e',
    'ë': 'e',
    'é': 'e',
    'ì': 'i',
    'î': 'i',
    'ï': 'i',
    'ò': 'o',
    'ô': 'o',
    'ö': 'o',
    'ó': 'o',
    'õ': 'o',
    'ù': 'u',
    'û': 'u',
    'ü': 'u',
    'ú': 'u',
    'ç': 'c',
    'ñ': 'n',
    'ý': 'y',
    'ÿ': 'y',
    'À': 'a',
    'Â': 'a',
    'Ä': 'a',
    'Á': 'a',
    'Ã': 'a',
    'È': 'e',
    'Ê': 'e',
    'Ë': 'e',
    'É': 'e',
    'Ì': 'i',
    'Î': 'i',
    'Ï': 'i',
    'Ò': 'o',
    'Ô': 'o',
    'Ö': 'o',
    'Ó': 'o',
    'Õ': 'o',
    'Ù': 'u',
    'Û': 'u',
    'Ü': 'u',
    'Ú': 'u',
    'Ç': 'c',
    'Ñ': 'n',
    'Ý': 'y',
    'Ÿ': 'y',
  };

  accentsMap.forEach((accentedChar, replacement) {
    name = name.replaceAll(accentedChar, replacement);
  });

  return name
      .toLowerCase()
      .replaceAll(' ', '_')
      .replaceAll(RegExp(r'[^a-z0-9_]'), '');
}
