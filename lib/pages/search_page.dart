import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/book.dart';
import '../providers/book_provider.dart';
import '../services/open_library_service.dart';

class SearchPage extends StatefulWidget {

  const SearchPage({super.key});

  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  bool _isLoading = false;

  void _searchBooks() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final results = await OpenLibraryService.searchBooks(_controller.text);
      if (mounted) {
        setState(() {
          _searchResults = results;
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showBookDetails(BuildContext context, Book book, String bookKey) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 16),
            Text('Loading description...'),
          ],
        ),
      ),
    );

    String description = 'No description available';
    if (bookKey.isNotEmpty) {
      try {
        description = await OpenLibraryService.fetchBookDescription(bookKey);
      } catch (e) {
        description = 'Failed to load description';
      }
    }

    if (context.mounted) {
      Navigator.of(context).pop();
    }

    if (context.mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(book.title),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Author: ${book.author}', style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Text('Description:', style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(description),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final booksProvider = Provider.of<BooksProvider>(context, listen: false);
    return Column(
      children: [
        TextField(
          controller: _controller,
          decoration: InputDecoration(
            labelText: 'Search books',
            suffixIcon: IconButton(
              icon: const Icon(Icons.search),
              onPressed: _searchBooks,
            ),
          ),
          onSubmitted: (_) => _searchBooks(),
        ),
        const SizedBox(height: 10),
        _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Expanded(
          child: ListView.builder(
            itemCount: _searchResults.length,
            itemBuilder: (context, index) {
              final result = _searchResults[index];
              final book = result['book'] as Book;
              final bookKey = result['key'] as String;
              return ListTile(
                title: Text(book.title),
                subtitle: Text(book.author),
                trailing: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () async {
                    final scaffoldMessenger = ScaffoldMessenger.of(context);
                    await booksProvider.addBook(book);
                    if (mounted) {
                      scaffoldMessenger.showSnackBar(
                        const SnackBar(content: Text('Book added!')),
                      );
                    }
                  },
                ),
                onTap: () => _showBookDetails(context, book, bookKey),
              );
            },
          ),
        ),
      ],
    );
  }
}