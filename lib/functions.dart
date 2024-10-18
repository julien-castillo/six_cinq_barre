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

   String getClosestFutureDate(List<dynamic> data) {
    DateTime today = DateTime.now();
    DateTime? closestDate;
    int closestDifference = double.maxFinite.toInt();

    for (var row in data) {
      if (row['date'] == null ||
          row['date'].isEmpty ||
          int.tryParse(row['date']) == null) {
        continue;
      }

      DateTime rowDate =
          DateTime(1899, 12, 30).add(Duration(days: int.parse(row['date'])));
      int difference = rowDate.difference(today).inDays;

      if (difference > 0 && difference < closestDifference) {
        closestDate = rowDate;
        closestDifference = difference;
      }
    }

    return closestDate != null
        ? DateFormat('dd/MM/yyyy').format(closestDate)
        : '';
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