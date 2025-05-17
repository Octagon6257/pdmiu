import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/book_provider.dart';

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

    return ListView.builder(
      itemCount: booksProvider.books.length,
      itemBuilder: (context, index) {
        final book = booksProvider.books[index];
        return ListTile(
          title: Text(book.title),
          subtitle: Text(book.author),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () async {
              await booksProvider.deleteBook(book.id!);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${book.title} deleted')),
                );
              }
            },
          ),
        );
      },
    );
  }
}