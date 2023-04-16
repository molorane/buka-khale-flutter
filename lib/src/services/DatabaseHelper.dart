import 'dart:convert';
import 'dart:io' as io;

import 'package:buka_ea_khale/src/models/book.dart';
import 'package:buka_ea_khale/src/providers/bible_chapters_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../config/exceptions.dart';
import '../models/chapter.dart';
import '../models/verse.dart';
import '../providers/bible_translations_provider.dart';
import '../repositories/bible_repository.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  Future<Database> get database async => _database ??= await initDB("sso");

  Future<Database> initDB(String translation) async {
    final io.Directory document = await getApplicationDocumentsDirectory();
    final String path = join(document.path, "${translation}.db");
    final bool dbExists = await io.File(path).exists();

    if (!dbExists) {
      final ByteData data = await rootBundle.load(join("assets", "sso.db"));
      final List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await io.File(path).writeAsBytes(bytes, flush: true);
    }

    return await openDatabase(path, version: 1);
  }

  Future<void> loadDb() async {
    if (_database == null) _database = await initDB("sso");
  }

  Future<List<Book>> getBooks(String? bookId) async {
    try {
      if (!['', null].contains(bookId)) {
        await loadDb();

        final List<Map> bookText = await _database!
            .query("book", where: 'book_num = ?', whereArgs: [bookId]);

        final chapters = {
          for (var item in bookText) ChapterId(id: item['chapter']),
        }.toList();

        final book = Book(
          id: bookText[0]['id'],
          name: BibleRepository().mapOfBibleBooks[int.parse(bookId!)],
          testament: bookText[0]['id'] >= 40 ? 'New' : 'Old',
          chapters: chapters,
        );

        return [book];
      } else {
        return BibleRepository().getBooks();
      }
    } on DioError catch (e) {
      throw Exceptions.fromDioError(e);
    }
  }

  Future<Chapter> getChapter(
      String bookId, String chapterId, String translationId) async {
    try {
      await loadDb();

      final books = await getBooks(bookId);

      final List<Map> bookText = await _database!
          .query("book", where: 'book_num = ? AND chapter = ?', whereArgs: [bookId, chapterId]);

      final verses = {
        for (var item in bookText)
          Verse.fromDB(item).copyWith(book: books[0])
      }.toList();

      final chapter = Chapter(
        id: int.parse(chapterID),
        number: chapterID,
        translation: translationId,
        verses: verses,
        bookmarked: false,
      );

      return chapter;
    } on DioError catch (e) {
      //await FirebaseCrashlytics.instance.recordError(e, e.stackTrace);
      throw Exceptions.fromDioError(e);
    }
  }

  Future<List<Chapter>> getChapters(String? bookId) async {
    try {
      await loadDb();

      final books = await getBooks(bookId);

      final List<Map> bookText = await _database!
          .query("book", where: 'book_num = ?', whereArgs: [bookId]);

      final verses = {
        for (var item in bookText) Verse.fromDB(item).copyWith(book: books[0])
      }.toList();

      final chapters = [
        for (var item in bookText)
          Chapter(
            id: bookText[0]['chapter'],
            number: bookText[0]['chapter'].toString(),
            translation: translationID,
            verses: verses
                .where((element) => element.chapterId == item['verse'])
                .toList(),
            bookmarked: false,
          )
      ];

      return chapters;
    } on DioError catch (e) {
      //await FirebaseCrashlytics.instance.recordError(e, e.stackTrace);
      throw Exceptions.fromDioError(e);
    }
  }

  Future<List<Verse>> getVerses(
      String bookId, String chapterId, String? verseId) async {
    try {
      await loadDb();

      final List<Map> bookText = await _database!
          .query("book", where: 'book_num = ? AND chapter = ?', whereArgs: [bookId, chapterId]);

      final books = await getBooks(bookId);

      final verses = {
        for (var item in bookText)
          Verse.fromDB(item).copyWith(book: books[0])
      }.toList();

      return verses;
    } on DioError catch (e) {
      throw Exceptions.fromDioError(e);
    }
  }
}
