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
  List<Book> _searchResults = [];
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
              final book = _searchResults[index];
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
              );
            },
          ),
        ),
      ],
    );
  }
}