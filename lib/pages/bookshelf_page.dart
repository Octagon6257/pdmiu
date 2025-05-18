import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/book_provider.dart';
import '../utils/responsive.dart';

class BookshelfPage extends StatefulWidget {
  const BookshelfPage({super.key});

  @override
  BookshelfPageState createState() => BookshelfPageState();
}

class BookshelfPageState extends State<BookshelfPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<BooksProvider>(context, listen: false).loadBooks();
  }

  @override
  Widget build(BuildContext context) {
    final booksProvider = Provider.of<BooksProvider>(context);

    if (booksProvider.books.isEmpty) {
      return const Center(child: Text('No books in your shelf.'));
    }

    if (Responsive.isPortrait(context)) {
      return ListView.builder(
        itemCount: booksProvider.books.length,
        itemBuilder: (context, index) {
          final book = booksProvider.books[index];
          return ListTile(
            title: Text(book.title),
            subtitle: Text(book.author),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _confirmDelete(context, book, booksProvider),
            ),
          );
        },
      );
    } else {
      return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3,
        ),
        itemCount: booksProvider.books.length,
        itemBuilder: (context, index) {
          final book = booksProvider.books[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: Center(
              child: ListTile(
                title: Text(book.title),
                subtitle: Text(book.author),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _confirmDelete(context, book, booksProvider),
                ),
              ),
            ),
          );
        },
      );
    }
  }

  Future<void> _confirmDelete(BuildContext context, dynamic book, BooksProvider booksProvider) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Book'),
        content: Text('Are you sure you want to delete "${book.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await booksProvider.deleteBook(book.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${book.title} deleted')),
        );
      }
    }
  }
}