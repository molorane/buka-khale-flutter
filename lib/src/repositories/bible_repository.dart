/*
Sso iOS & Android App
Copyright (C) 2022 Carlton Aikins

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

import 'package:buka_ea_khale/src/models/book.dart';
import 'package:buka_ea_khale/src/models/chapter.dart';
import 'package:buka_ea_khale/src/models/translation.dart';
import 'package:buka_ea_khale/src/providers/bible_books_provider.dart';
import 'package:buka_ea_khale/src/providers/bible_chapters_provider.dart';
import 'package:buka_ea_khale/src/providers/last_translation_book_chapter_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BibleRepository {
  BibleRepository();

  final _mapOfBibleBooks = <int, String>{
    1: 'Genese',
    2: 'Exoda',
    3: 'Levitike',
    4: 'Numere',
    5: 'Deuteronoma',
    6: 'Joshua',
    7: 'Baahloli',
    8: 'Ruthe',
    9: '1 Samuele',
    10: '2 Samuele',
    11: '1 Marena',
    12: '2 Marena',
    13: '1 Likronike',
    14: '2 Likronike',
    15: 'Esdrase',
    16: 'Nehemia',
    17: 'Esthere',
    18: 'Jobo',
    19: 'Lipesalema',
    20: 'Liproverbia',
    21: 'Moekelesia',
    22: 'Sefela sa Salomone',
    23: 'Esaia',
    24: 'Jeremiea',
    25: 'Lillo tsa Jeremia',
    26: 'Ezekiele',
    27: 'Daniele',
    28: 'Hosea',
    29: 'Joele',
    30: 'Amose',
    31: 'Obadia',
    32: 'Jonase',
    33: 'Mikea',
    34: 'Nahume',
    35: 'Habakuke',
    36: 'Sofonia',
    37: 'Haggai',
    38: 'Zakaria',
    39: 'Malakia',
    40: 'Mattheu',
    41: 'Mareka',
    42: 'Luka',
    43: 'Johanne',
    44: 'Liketso',
    45: 'Baroma',
    46: '1 Bakorinthe',
    47: '2 Bakorinthe',
    48: 'Bagalata',
    49: 'Baefese',
    50: 'Bafilipi',
    51: 'Bakolose',
    52: '1 Bathesalonika',
    53: '2 Bathesalonika',
    54: '1 Timothea',
    55: '2 Timothea',
    56: 'Tite',
    57: 'Filemone',
    58: 'Baheberu',
    59: 'Jakobo',
    60: '1 Peterose',
    61: '2 Peterose',
    62: '1 Johanne',
    63: '2 Johanne',
    64: '3 Johanne',
    65: 'Jude',
    66: 'Ts\'enolo',
  };

  final _mapOfBibleChaptersAndBooks = <int, int>{
    0: 1,
    1: 50,
    2: 40,
    3: 27,
    4: 36,
    5: 34,
    6: 24,
    7: 21,
    8: 4,
    9: 31,
    10: 24,
    11: 22,
    12: 25,
    13: 29,
    14: 36,
    15: 10,
    16: 13,
    17: 10,
    18: 42,
    19: 150,
    20: 31,
    21: 12,
    22: 8,
    23: 66,
    24: 52,
    25: 5,
    26: 48,
    27: 12,
    28: 14,
    29: 3,
    30: 9,
    31: 1,
    32: 4,
    33: 7,
    34: 3,
    35: 3,
    36: 3,
    37: 2,
    38: 14,
    39: 4,
    40: 28,
    41: 16,
    42: 24,
    43: 21,
    44: 28,
    45: 16,
    46: 16,
    47: 13,
    48: 6,
    49: 6,
    50: 4,
    51: 4,
    52: 5,
    53: 3,
    54: 6,
    55: 4,
    56: 3,
    57: 1,
    58: 13,
    59: 5,
    60: 5,
    61: 3,
    62: 5,
    63: 1,
    64: 1,
    65: 1,
    66: 22,
    67: 22,
  };

  final _translations = <Translation>[
    Translation(
        id: 1,
        name: 'King James Version',
        abbreviation: 'kjv',
        language: 'english'),
    Translation(
        id: 2,
        name: 'Southern Sesotho Bible',
        abbreviation: 'sso',
        language: 'sesotho')
  ];

  List<Translation> get translations => _translations;

  Map<int, int> get mapOfBibleChaptersAndBooks => _mapOfBibleChaptersAndBooks;

  Map<int, String> get mapOfBibleBooks => _mapOfBibleBooks;

  List<Book> getBooks() {
    var books = <Book>[];

    for (var item in _mapOfBibleBooks.entries.toList()) {
      var newMap = _mapOfBibleChaptersAndBooks;

      newMap.remove(0);
      newMap.remove(67);

      String testament() {
        if (item.key < 40) return 'Old';
        return 'New';
      }

      final chapters = List<ChapterId>.generate(
          newMap[item.key]!, (i) => ChapterId(id: i + 1));

      final book = Book(
          id: item.key,
          chapters: chapters,
          name: item.value,
          testament: testament());

      books.add(book);
    }

    return books;
  }

  bool _isLastChapterInBook(WidgetRef ref) {
    bool bookChapterBool(int book, int chapter) {
      return (ref.watch(localRepositoryProvider).chapter == chapter &&
          ref.watch(localRepositoryProvider).book == book);
    }

    if (bookChapterBool(1, 50) ||
        bookChapterBool(2, 40) ||
        bookChapterBool(3, 27) ||
        bookChapterBool(4, 36) ||
        bookChapterBool(5, 34) ||
        bookChapterBool(6, 24) ||
        bookChapterBool(7, 21) ||
        bookChapterBool(8, 4) ||
        bookChapterBool(9, 31) ||
        bookChapterBool(10, 24) ||
        bookChapterBool(11, 22) ||
        bookChapterBool(12, 25) ||
        bookChapterBool(13, 29) ||
        bookChapterBool(14, 36) ||
        bookChapterBool(15, 10) ||
        bookChapterBool(16, 13) ||
        bookChapterBool(17, 10) ||
        bookChapterBool(18, 42) ||
        bookChapterBool(19, 150) ||
        bookChapterBool(20, 31) ||
        bookChapterBool(21, 12) ||
        bookChapterBool(22, 8) ||
        bookChapterBool(23, 66) ||
        bookChapterBool(24, 52) ||
        bookChapterBool(25, 5) ||
        bookChapterBool(26, 48) ||
        bookChapterBool(27, 12) ||
        bookChapterBool(28, 14) ||
        bookChapterBool(29, 3) ||
        bookChapterBool(30, 9) ||
        bookChapterBool(31, 1) ||
        bookChapterBool(32, 4) ||
        bookChapterBool(33, 7) ||
        bookChapterBool(34, 3) ||
        bookChapterBool(35, 3) ||
        bookChapterBool(36, 3) ||
        bookChapterBool(37, 2) ||
        bookChapterBool(38, 14) ||
        bookChapterBool(39, 4) ||
        bookChapterBool(40, 28) ||
        bookChapterBool(41, 16) ||
        bookChapterBool(42, 24) ||
        bookChapterBool(43, 21) ||
        bookChapterBool(44, 28) ||
        bookChapterBool(45, 16) ||
        bookChapterBool(46, 16) ||
        bookChapterBool(47, 13) ||
        bookChapterBool(48, 6) ||
        bookChapterBool(49, 6) ||
        bookChapterBool(50, 4) ||
        bookChapterBool(51, 4) ||
        bookChapterBool(52, 5) ||
        bookChapterBool(53, 3) ||
        bookChapterBool(54, 6) ||
        bookChapterBool(55, 4) ||
        bookChapterBool(56, 3) ||
        bookChapterBool(57, 1) ||
        bookChapterBool(58, 13) ||
        bookChapterBool(59, 5) ||
        bookChapterBool(60, 5) ||
        bookChapterBool(61, 3) ||
        bookChapterBool(62, 5) ||
        bookChapterBool(63, 1) ||
        bookChapterBool(64, 1) ||
        bookChapterBool(65, 1) ||
        bookChapterBool(66, 22)) {
      return true;
    }

    return false;
  }

  Future<void> goToNextPreviousChapter(WidgetRef ref, bool isBackward) async {
    bool isFirstChapterInBook() {
      return ref.watch(localRepositoryProvider).chapter == 1;
    }

    bool isGenesisOne() {
      if (ref.watch(localRepositoryProvider).book == 1 &&
          ref.watch(localRepositoryProvider).chapter == 1) {
        return true;
      }
      return false;
    }

    bool isRevelationTwentyTwo() {
      if (ref.watch(localRepositoryProvider).book == 66 &&
          ref.watch(localRepositoryProvider).chapter == 22) {
        return true;
      }
      return false;
    }

    int newBibleChapter = 1;
    int newBibleBook = 1;

    if (isBackward) {
      if (!isGenesisOne()) {
        if (isFirstChapterInBook()) {
          newBibleBook = ref.watch(localRepositoryProvider).book! - 1;
          newBibleChapter = _mapOfBibleChaptersAndBooks[newBibleBook]!;
        } else {
          newBibleBook = ref.watch(localRepositoryProvider).book!;
          newBibleChapter = ref.watch(localRepositoryProvider).chapter! - 1;
        }

        bookID = newBibleBook.toString();
        chapterID = newBibleChapter.toString();

        await ref
            .read(localRepositoryProvider.notifier)
            .changeBibleBook(newBibleBook);
        await ref
            .read(localRepositoryProvider.notifier)
            .changeBibleChapter(newBibleChapter);

        ref.refresh(bibleChaptersProvider);
      } else {
        DoNothingAction();
      }
    } else {
      if (!isRevelationTwentyTwo()) {
        if (_isLastChapterInBook(ref)) {
          newBibleBook = ref.watch(localRepositoryProvider).book! + 1;
          newBibleChapter = 1;
        } else {
          newBibleBook = ref.watch(localRepositoryProvider).book!;
          newBibleChapter = ref.watch(localRepositoryProvider).chapter! + 1;
        }

        bookID = newBibleBook.toString();
        chapterID = newBibleChapter.toString();

        await ref
            .read(localRepositoryProvider.notifier)
            .changeBibleBook(newBibleBook);
        await ref
            .read(localRepositoryProvider.notifier)
            .changeBibleChapter(newBibleChapter);

        ref.refresh(bibleChaptersProvider);
      } else {
        DoNothingAction();
      }
    }
  }

  Future<void> changeChapter(WidgetRef ref, int book, int chapter) async {
    if (ref.watch(localRepositoryProvider).book! == book &&
        ref.watch(localRepositoryProvider).chapter! == chapter) {
      DoNothingAction();
    } else {
      if (ref.watch(localRepositoryProvider).book! == book) {
        chapterID = chapter.toString();
        await ref
            .read(localRepositoryProvider.notifier)
            .changeBibleChapter(chapter);
      } else {
        bookID = book.toString();
        chapterID = chapter.toString();

        await ref.read(localRepositoryProvider.notifier).changeBibleBook(book);
        await ref
            .read(localRepositoryProvider.notifier)
            .changeBibleChapter(chapter);
      }

      ref.refresh(bibleChaptersProvider);
    }
  }
}
