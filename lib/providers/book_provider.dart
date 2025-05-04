import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/database_helper.dart';

class BooksProvider with ChangeNotifier {
  List<Book> books = [];

  Future<void> loadBooks() async {
    books = await DatabaseHelper.instance.getBooks();
    notifyListeners();
  }

  Future<void> addBook(Book book) async {
    await DatabaseHelper.instance.insertBook(book);
    await loadBooks();
  }

  Future<void> deleteBook(int id) async {
    await DatabaseHelper.instance.deleteBook(id);
    await loadBooks();
    notifyListeners();
  }
}