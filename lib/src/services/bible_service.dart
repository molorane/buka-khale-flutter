/*
Elisha iOS & Android App
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

import 'dart:convert';

import 'package:buka_ea_khale/src/services/DatabaseHelper.dart';
import 'package:flutter/services.dart';

import 'package:dio/dio.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import 'package:buka_ea_khale/src/config/exceptions.dart';
import 'package:buka_ea_khale/src/models/book.dart';
import 'package:buka_ea_khale/src/models/chapter.dart';
import 'package:buka_ea_khale/src/models/verse.dart';
import 'package:buka_ea_khale/src/providers/bible_chapters_provider.dart';
import 'package:buka_ea_khale/src/providers/bible_translations_provider.dart';
import 'package:buka_ea_khale/src/repositories/bible_repository.dart';

class BibleService {
  BibleService();

  final jsonText = rootBundle.loadString('backend/$translationAbb.json');

  Future<List<Book>> getBooks(String? bookID) async {
    final List<Book> books = await DatabaseHelper.instance.getBooks(bookID);
    return books;
  }

  Future<Chapter> getChapter(String bookID, String chapterID, String translationID) async {
    final Chapter chapter = await DatabaseHelper.instance.getChapter(bookID, chapterID, translationID);
    return chapter;
  }

  Future<List<Chapter>> getChapters(String? bookID) async {
    final List<Chapter> chapters = await DatabaseHelper.instance.getChapters(bookID);
    return chapters;
  }

  Future<List<Verse>> getVerses(String bookID, String chapterID, String? verseID) async {
    final List<Verse> chapters = await DatabaseHelper.instance.getVerses(bookID, chapterID, verseID);
    return chapters;
  }
}
