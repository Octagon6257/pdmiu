import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book.dart';

class OpenLibraryService {
  static Future<List<Book>> searchBooks(String query) async {
    final url = Uri.parse('http://openlibrary.org/search.json?q=$query');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final docs = data['docs'] as List;
      return docs.map((doc) {
        final title = doc['title'] ?? 'No Title';
        final author = (doc['author_name'] != null && (doc['author_name'] as List).isNotEmpty)
            ? doc['author_name'][0]
            : 'Unknown Author';
        return Book(title: title, author: author);
      }).toList();
    } else {
      throw Exception('Failed to load books from OpenLibrary');
    }
  }
}
