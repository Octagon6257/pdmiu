import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/database_helper.dart';

class BooksProvider with ChangeNotifier {
  List<Book> books = [];

  Future<void> loadBooks() async {
    books = await DatabaseHelper.instance.getBooks();
    notifyListeners();
  }
}