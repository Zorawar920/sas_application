import 'package:sas_application/language_support/english.dart';
import 'package:sas_application/language_support/french.dart';
import 'package:sas_application/language_support/german.dart';
import 'package:sas_application/language_support/italian.dart';

class Sentiment {
  Map<String, dynamic> analysis(String text,
      {Map? customLang, bool emoji = false, required String languageCode}) {
    try {
      if (text.isEmpty) throw ('err');
      var sentiments = {};
      if (customLang == null) {
        switch (languageCode) {

          /// english
          case 'en':
            sentiments.addAll(en);
            break;

          /// italian
          case 'it':
            sentiments.addAll(it);
            break;

          /// french
          case 'fr':
            sentiments.addAll(fr);
            break;

          /// german
          case 'de':
            sentiments.addAll(de);
            break;
          default:
            throw ('err');
        }
      } else {
        sentiments.addAll(customLang);
      }
      var score = 0;
      var goodwords = [], badwords = [];
      var wordlist = text
          .toLowerCase()
          .replaceAll('\n', ' ')
          .replaceAll('s\s+', ' ')
          .replaceAll(RegExp(r'[.,\/#!?$%\^&\*;:{}=_`\"~()]'), '')
          .trim()
          .split(' ');
      for (var i = 0; i < wordlist.length; i++) {
        sentiments.forEach((key, value) {
          if (key == wordlist[i]) {
            score += value as int;
            if (value < 0) {
              badwords.add([key, value]);
            } else {
              goodwords.add([key, value]);
            }
          }
        });
      }
      var result = {
        'score': score,
        'comparative': wordlist.isNotEmpty ? score / wordlist.length : 0,
        'words': wordlist,
        'good words': goodwords,
        'badword': badwords
      };
      return result;
    } catch (e) {
      throw Exception(e);
    }
  }
}
