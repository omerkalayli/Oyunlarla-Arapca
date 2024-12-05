import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kitaplar_ve_yazarlari/string_extensions.dart';
import 'package:kitaplar_ve_yazarlari/words/word_card.dart';
import 'package:kitaplar_ve_yazarlari/words/word_component.dart';
import 'package:kitaplar_ve_yazarlari/words/words_page.dart';
import 'package:palette_generator/palette_generator.dart';

class WordsController extends GetxController {
  final RxBool doesWordsInitialized = RxBool(false);

  List<int> wrongWordIDs = [];

  void addToWrongWordIDs() {
    if (!wrongWordIDs.contains(shownWordId)) {
      wrongWordIDs.add(shownWordId);
    }
  }

  void resetWrongWordIDs() {
    wrongWordIDs = [];
  }

  var topics = [
    "Lügat",
    "Nahiv, Coğrafya",
    "Sarf, Hadis, Mesel",
    "Belagat, Arap edebiyatı",
    "Edebi tenkit, Meğazi, Tarih, Seyahatname, Mizah - Hikaye,\nMenkıbe-i hikaye",
  ];

  List<List<WordComponent>> words = [
    [
      // Lügat
      WordComponent(
          id: 0, author: "Halil b. Ahmed el-Ferâhîdî", book: "Kitabu'l-Ayn"),
      WordComponent(id: 1, author: "Ebu Ali el-Kâlî", book: "el-Bari"),
      WordComponent(id: 2, author: "el-Ezherî", book: "Tehzibu'l-Luga"),
      WordComponent(id: 3, author: "İbn Abbâd", book: "el-Muhît fi’l-Luga"),
      WordComponent(id: 4, author: "İbn Dureyd", book: "el-Cemhere"),
      WordComponent(id: 5, author: "el-Farabi", book: "Divanu’l-edeb"),
      WordComponent(id: 6, author: "el-Cevheri", book: "Tâcu’l-Luga"),
      WordComponent(id: 7, author: "İbn Manzûr", book: "Lisanu’l-Arab"),
      WordComponent(id: 8, author: "el-Fîrûzâbâdî", book: "el-Kamusu’l-Muhit"),
      WordComponent(id: 9, author: "ez-Zebîdî", book: "Tâcu’l-Arûs"),
    ],
    [
      // Nahiv, Coğrafya
      WordComponent(
          id: 10,
          author: "Halil b. Ahmed el-Ferâhîdî",
          book: "el-Cumel fin’nahv"),
      WordComponent(id: 11, author: "Sibeveyh", book: "el-Kitab"),
      WordComponent(id: 12, author: "el-Muberred", book: "el-Muktadab"),
      WordComponent(id: 13, author: "İbnu’s-Serrâc", book: "el-Usûl fi’nahv"),
      WordComponent(id: 14, author: "ez-Zeccâcî", book: "el-Cumel"),
      WordComponent(id: 15, author: "İbn Mâlik", book: "el-Elfiyye"),
      WordComponent(id: 16, author: "İbnu’l-Hâcib", book: "el-Kâfiye"),
      WordComponent(id: 17, author: "Yakut el-Hamevi", book: "Mucemu’l-Buldân"),
      WordComponent(id: 18, author: "el-Makdîsî", book: "Ahsenu’t-Tekâsîm"),
      WordComponent(id: 19, author: "el-İdrîsî", book: "Nuzhetu’l-Muştâk"),
    ],
    [
      // Hadis, Mesel, Sarf
      WordComponent(id: 20, author: "Ebû Osman el-Mâzînî", book: "et-Tasrîf"),
      WordComponent(id: 21, author: "İbnu’l-Hâcib", book: "eş-Şâfiye"),
      WordComponent(id: 22, author: "İbn Cinnî", book: "el-Munsif"),
      WordComponent(id: 23, author: "Ali b. Mesud", book: "Merâhu’l-Ervâh"),
      WordComponent(id: 24, author: "ez-Zencânî", book: "el-İzzî"),
      WordComponent(id: 25, author: "İmam Mâlik", book: "el-Muvatta"),
      WordComponent(id: 26, author: "Ahmed b. Hambel", book: "el-Müsned"),
      WordComponent(id: 27, author: "el-Buhârî", book: "el-Câmi’u’s-Sâhîh"),
      WordComponent(id: 28, author: "el-Meydânî", book: "Mecmeu’l-Emsâl"),
      WordComponent(id: 29, author: "el-Asmaî", book: "Kitâbu’l-Emsâl"),
    ],
    [
      // Belagat, Arap edebiyatı
      WordComponent(id: 30, author: "el-Muberred", book: "el-Belaga"),
      WordComponent(id: 31, author: "İbnu’l-Mu’tez", book: "Kitâbu’l-Bedî"),
      WordComponent(id: 32, author: "el-Curcânî", book: "Esrâru’l-Belaga"),
      WordComponent(id: 33, author: "es-Sekkâkî", book: "Miftâhu’l-Ulûm"),
      WordComponent(id: 34, author: "el-Kazvînî", book: "Telhîsul-Miftâh"),
      WordComponent(id: 35, author: "el-Câhiz", book: "el-Beyân vet’Tebyîn"),
      WordComponent(id: 36, author: "İbn Kuteybe", book: "Uyûnu’l-Ahbâr"),
      WordComponent(
          id: 37, author: "el-Muberred", book: "el-Kâmil Fi’l-Luga ve’l-Edeb"),
      WordComponent(id: 38, author: "İbn Abd Rabbihi", book: "el-İkdu’l-Ferîd"),
      WordComponent(id: 39, author: "el-Câhiz", book: "Kitâbu’l-Hayavân"),
    ],
    [
      // Edebi tenkit, Meğazi, Tarih, Seyahatname, Mizah - Hikaye, Menkıbe-i Hikaye
      WordComponent(
          id: 40, author: "el-Asmaî", book: "Kitabu Fuhûleti’ş-Şuara"),
      WordComponent(id: 41, author: "Kudâme b. Cafer", book: "Nakdu’ş-Şiir"),
      WordComponent(
          id: 42,
          author: "İbn İshâk-İbn Hişâm",
          book: "Sîretu İbn İshâk-İbn Hişâm"),
      WordComponent(id: 43, author: "İbn Kesîr", book: "el-Bidâye ve’n-Nihâye"),
      WordComponent(
          id: 44, author: "et-Taberî", book: "Tarihu’r-Rusûl ve’l-Mulûk"),
      WordComponent(id: 45, author: "İbn Esîr", book: "el-Kâmil fi’Tarih"),
      WordComponent(id: 46, author: "İbn Fadlân", book: "Risale İbn Fadlan"),
      WordComponent(id: 47, author: "İbn Cubeyr", book: "Rihletu İbn Cubeyr"),
      WordComponent(id: 48, author: "İbn Battûta", book: "Rihletu İbn Battûta"),
      WordComponent(id: 49, author: "el-Cahiz", book: "Kitâbu’l-Buhelâ"),
      WordComponent(
          id: 50, author: "İbn Habib en-Nisâbûrî", book: "Ukelâu’l-Mecânîn"),
      WordComponent(
          id: 51, author: "İbn Cevzî", book: "Kitabu’l-Hamkâ ve’l-Mugaffelîn"),
    ]
  ].obs;
  List<WordComponent> getUnitWords(int topicID) {
    return words[topicID];
  }

  void shuffleWords(int topicID) {
    words[topicID].shuffle();
  }

  List<WordComponent> getFlattenedList() {
    return words.expand((innerList) => innerList).toList();
  }

  WordComponent? getNextWord(int topicID) {
    List<WordComponent> unitWords = words[topicID];
    int index = unitWords
        .indexOf(unitWords.firstWhere((word) => word.id == shownWordId));
    if (unitWords.last.id == shownWordId) {
      return null;
    } else {
      shownWordId = unitWords[index + 1].id;
      return unitWords[index + 1];
    }
  }

  WordComponent getWord(int topicID) {
    WordComponent firstWord = words[selectedTopic ?? 0][0];
    shownWordId = firstWord.id;
    return firstWord;
  }

  int? selectedTopic;
  int shownWordId = 0;

  List<WordComponent> getWords(int topicID, int wordCount) {
    try {
      List<WordComponent> unitWords = List.from(words[topicID]);
      List<WordComponent> returnWords = List.empty(growable: true);
      var flatListWords = words.expand((innerList) => innerList).toList();
      WordComponent shownWordComponent =
          flatListWords.firstWhere((word) => word.id == shownWordId);
      print(shownWordComponent.book + " " + shownWordComponent.author);
      returnWords.add(shownWordComponent);
      int remainingWordCount = wordCount - 1;

      while (remainingWordCount != 0) {
        int length = unitWords.length;
        int randomId = Random().nextInt(length);

        if (unitWords[randomId].id == shownWordId) {
          continue;
        }
        if (shownWordId == 35 && unitWords[randomId].id == 39) {
          continue;
        } else if (shownWordId == 39 && unitWords[randomId].id == 35) {
          continue;
        }
        print(randomId.toString() + " " + shownWordId.toString());
        returnWords.add(unitWords[randomId]);
        unitWords.removeAt(randomId);
        remainingWordCount--;
      }
      returnWords.shuffle();
      return returnWords;
    } catch (e) {
      return List.empty();
    }
  }
}
