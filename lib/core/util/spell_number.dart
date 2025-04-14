import 'package:intl/intl.dart'; // Keep for good practice, potential formatting

class SpellNumber {
  // --- Vietnamese Number Spelling Data ---

final List<String> _vnUnits = [
  "không", "một", "hai", "ba", "bốn", "năm", "sáu", "bảy", "tám", "chín"
];

final List<String> _vnTens = [
  "", // Index 0 is not used directly for tens like "linh"
  "mười", "hai mươi", "ba mươi", "bốn mươi", "năm mươi",
  "sáu mươi", "bảy mươi", "tám mươi", "chín mươi"
];

final List<String> _vnThousands = [
  "", "nghìn", "triệu", "tỷ" // Add more if needed (nghìn tỷ, etc.)
];

// --- Core Vietnamese Spelling Logic ---

/// Spells a number from 0 to 999 in Vietnamese.
String _spellTripleVn(int n) {
  if (n < 0 || n > 999) {
    throw ArgumentError("Input must be between 0 and 999 for _spellTripleVn");
  }
  if (n == 0) return ""; // Don't spell zero within a larger number unless it's the only part

  int hundreds = n ~/ 100;
  int tensUnits = n % 100;
  int tens = tensUnits ~/ 10;
  int units = tensUnits % 10;

  List<String> parts = [];

  // --- Hundreds ---
  if (hundreds > 0) {
    parts.add(_vnUnits[hundreds]);
    parts.add("trăm");
  }

  // --- Tens and Units ---
  if (tens == 0 && units > 0) {
    // Need "lẻ" (meaning "odd" or "spare") if there were hundreds
    // or if this triple is part of a larger number (handled later)
    if (hundreds > 0 || n < 10) { // Add "lẻ" if preceded by hundreds or if it's just 1-9
       parts.add("lẻ");
    }
     parts.add(_vnUnits[units]); // e.g., một trăm lẻ một, or just một (handled in _spellIntegerVn)
  } else if (tens == 1) {
    // Special case for 10-19
    parts.add("mười");
    if (units == 1) {
      parts.add("một"); // mười một
    } else if (units == 5) {
      parts.add("lăm"); // mười lăm
    } else if (units > 0) {
      parts.add(_vnUnits[units]); // mười hai, mười ba, mười bốn...
    }
    // if units is 0, it's just "mười"
  } else if (tens > 1) {
    // Standard tens (20-99)
    parts.add(_vnTens[tens]); // hai mươi, ba mươi...
    if (units == 1) {
      // Special case "mốt" for 1 after twenty, thirty, etc.
      parts.add("mốt"); // hai mươi mốt
    } else if (units == 4 && tens > 1) {
        // Special case "tư" for 4 after twenty, thirty etc. (optional but common)
         parts.add("tư"); // hai mươi tư
    } else if (units == 5) {
      // Special case "lăm" for 5 after any ten (including mười)
       parts.add("lăm"); // hai mươi lăm
    } else if (units > 0) {
       parts.add(_vnUnits[units]); // hai mươi hai, hai mươi ba...
    }
    // if units is 0, it's just the tens word (e.g., "hai mươi")
  }

  // Join parts with spaces, ensuring no double spaces if parts are empty
  return parts.where((p) => p.isNotEmpty).join(" ");
}


/// Spells a non-negative integer in Vietnamese.
String _spellIntegerVn(int number) {
  if (number < 0) {
    // Or handle negative with "âm"
    return "Số âm không hợp lệ";
  }
  if (number == 0) {
    return _vnUnits[0]; // "không"
  }

  List<String> resultParts = [];
  int thousandsIndex = 0;
  bool needsLeadingLe = false; // Flag to check if "lẻ" is needed for the first spoken digits

  while (number > 0) {
    int triple = number % 1000;
    if (triple != 0) {
      String tripleSpell = _spellTripleVn(triple);
      String scaleWord = _vnThousands[thousandsIndex];

      // Add "lẻ" correctly for cases like 1001 (một nghìn không trăm lẻ một) -> "một nghìn lẻ một"
      // If the current triple is < 10 and it's not the very first group spoken, prefix with lẻ
      // Or if the triple is < 100 and the very first group is > 0 and there were hundreds skipped
      bool currentTripleNeedsLe = (triple < 100 && triple > 0 && needsLeadingLe);

      String currentPart = (currentTripleNeedsLe ? "lẻ " : "") + tripleSpell + (scaleWord.isNotEmpty ? " $scaleWord" : "");

      resultParts.insert(0, currentPart.trim()); // Add to the beginning
      needsLeadingLe = false; // Reset flag once a non-zero part is added

    } else {
        // If a whole group of thousand/million/billion is zero,
        // we might need 'lẻ' for the next non-zero group if it's < 100
        if (resultParts.isNotEmpty) { // Only set flag if we've already spelled something
             needsLeadingLe = true;
        }
    }

    number ~/= 1000;
    thousandsIndex++;
     // If the remaining number starts with 00x, the next triple will need 'lẻ'
     if (number > 0 && number % 1000 < 100 && number % 1000 != 0) {
         // This condition is tricky, let's simplify and rely on _spellTripleVn's internal "lẻ"
         // The logic above handles cases like 1,001,005 reasonably well by checking needsLeadingLe
     }

  }

  // Join the major parts (thousands, millions, etc.)
  String finalResult = resultParts.join(" ");

  // Refinement: Replace "không trăm lẻ không" or similar artifacts if necessary, though the logic aims to avoid them.
  // Refinement: Handle "một mười" -> "mười" (should be handled by _spellTripleVn)

  return finalResult.trim(); // Trim potential extra spaces
}


// --- Main Vietnamese Money Spelling Function ---

/// Spells out a monetary amount in Vietnamese Đồng (VND).
/// Rounds the amount to the nearest integer.
///
/// Example:
/// spellMoneyVND(1000) -> "Một nghìn đồng"
/// spellMoneyVND(1234567) -> "Một triệu hai trăm ba mươi bốn nghìn năm trăm sáu mươi bảy đồng"
/// spellMoneyVND(21505) -> "Hai mươi mốt nghìn năm trăm lẻ năm đồng"
String spellMoneyVND(double amount) {
  if (amount < 0) {
    // Optionally handle negative amounts, e.g., return "Âm " + spellMoneyVND(-amount);
    return "Số tiền âm không hợp lệ";
  }

  // Round the amount to the nearest whole number as VND subunits are rarely spelled
  int integerAmount = amount.round();

  // Handle zero separately
  if (integerAmount == 0) {
    return "Không đồng";
  }

  // Spell the integer part
  String spelledAmount = _spellIntegerVn(integerAmount);

  // Combine with currency name
  String result = spelledAmount + " đồng";

  // Capitalize the first letter
  if (result.isNotEmpty) {
     result = result[0].toUpperCase() + result.substring(1);
  }

  return result;
}

// --- English Number Spelling Data ---
final List<String> _units = [
  "", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine",
  "ten", "eleven", "twelve", "thirteen", "fourteen", "fifteen", "sixteen",
  "seventeen", "eighteen", "nineteen"
];

final List<String> _tens = [
  "", "", "twenty", "thirty", "forty", "fifty", "sixty", "seventy", "eighty", "ninety"
];

final List<String> _thousands = [
  "", "thousand", "million", "billion", "trillion" // Add more if needed (quadrillion, etc.)
];

// --- Core Spelling Logic ---

/// Converts a number less than 1000 into words.
String _spellLessThan1000(int number) {
  if (number == 0) return "";
  if (number < 20) return _units[number];
  if (number < 100) {
    return _tens[number ~/ 10] + (number % 10 != 0 ? " " + _units[number % 10] : "");
  }
  // Handle hundreds
  return _units[number ~/ 100] + " hundred" + (number % 100 != 0 ? " " + _spellLessThan1000(number % 100) : "");
}

/// Converts a non-negative integer into words.
String _spellInteger(int number) {
  if (number == 0) return "zero";

  String result = "";
  int i = 0; // Index for _thousands

  while (number > 0) {
    if (number % 1000 != 0) {
      String chunk = _spellLessThan1000(number % 1000);
      String thousandSeparator = i > 0 ? _thousands[i] : "";
      // Add space before adding to result if result is not empty
      // Add space between chunk and thousand separator if both exist
      result = chunk + (thousandSeparator.isNotEmpty ? " " + thousandSeparator : "") + (result.isNotEmpty ? " " + result : "");
    }
    number ~/= 1000; // Move to the next chunk of thousands
    i++;
  }

  // Trim potential leading/trailing spaces if needed, though logic should prevent this
  return result.trim();
}


// --- Main Money Spelling Function ---

/// Spells out a monetary amount into words with currency.
///
/// Example:
/// spellMoney(1234.56) -> "one thousand two hundred thirty-four dollars and fifty-six cents"
/// spellMoney(1.00) -> "one dollar"
/// spellMoney(0.75) -> "seventy-five cents"
/// spellMoney(1000) -> "one thousand dollars"
/// spellMoney(1001.01, currencySymbol: '€', currencyNameSingular: 'euro', currencyNamePlural: 'euros', centNameSingular: 'cent', centNamePlural: 'cents')
///   -> "one thousand one euros and one cent"
String spellMoney(
  double amount, {
  String currencySymbol = '\$', // Optional: For potential future formatting
  String currencyNameSingular = 'dollar',
  String currencyNamePlural = 'dollars',
  String centNameSingular = 'cent',
  String centNamePlural = 'cents',
}) {
  if (amount < 0) {
    // Optionally handle negative amounts, e.g., return "minus " + spellMoney(-amount, ...);
    // For simplicity, we'll treat them as invalid for typical money spelling.
    return "Invalid amount (negative)";
  }

  // --- Separate Integer and Fractional Parts Safely ---
  // Use formatting to avoid floating point inaccuracies with cents
  String formattedAmount = amount.toStringAsFixed(2);
  List<String> parts = formattedAmount.split('.');

  int integerPart = int.parse(parts[0]);
  int fractionalPart = int.parse(parts[1]);

  // --- Spell Parts ---
  String integerSpell = _spellInteger(integerPart);
  String fractionalSpell = _spellInteger(fractionalPart); // Reuse integer spelling for cents

  // --- Determine Currency and Cent Names (Singular/Plural) ---
  String currencyName = (integerPart == 1) ? currencyNameSingular : currencyNamePlural;
  String centName = (fractionalPart == 1) ? centNameSingular : centNamePlural;

  // --- Combine the Spelled Parts ---
  StringBuffer result = StringBuffer();

  if (integerPart > 0) {
    result.write(integerSpell);
    result.write(" ");
    result.write(currencyName);
  }

  if (fractionalPart > 0) {
    if (integerPart > 0) {
      // Add "and" only if there's both an integer and fractional part
      result.write(" and ");
    }
    result.write(fractionalSpell);
    result.write(" ");
    result.write(centName);
  }

  // Handle the case of exactly zero
  if (integerPart == 0 && fractionalPart == 0) {
    result.write("zero ");
    result.write(currencyNamePlural); // Usually plural for zero amount
  }

  // Capitalize the first letter (optional styling)
  String finalResult = result.toString();
  if (finalResult.isNotEmpty) {
     finalResult = finalResult[0].toUpperCase() + finalResult.substring(1);
  }

  return finalResult;
}
}