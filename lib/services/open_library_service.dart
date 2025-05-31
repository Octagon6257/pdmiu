import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book.dart';

class OpenLibraryService {
  static Future<List<Map<String, dynamic>>> searchBooks(String query) async {
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
        final bookKey = doc['key'] ?? '';
        return {
          'book': Book(title: title, author: author),
          'key': bookKey,
        };
      }).toList();
    } else {
      throw Exception('Failed to load books from OpenLibrary');
    }
  }

  static Future<String> fetchBookDescription(String bookKey) async {
    if (bookKey.isEmpty) return 'No description available';
    final url = Uri.parse('http://openlibrary.org$bookKey.json');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['description'] != null) {
        if (data['description'] is String) {
          return data['description'];
        } else if (data['description'] is Map && data['description']['value'] != null) {
          return data['description']['value'];
        }
      }
    }
    return 'No description available';
  }
}