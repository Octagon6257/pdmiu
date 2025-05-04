import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/book_provider.dart';
import 'services/database_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.database;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<BooksProvider>(
          create: (_) => BooksProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Virtual Bookshelf',
        theme: ThemeData(
          primarySwatch: Colors.teal,
          textTheme: const TextTheme(
            bodyMedium: TextStyle(fontSize: 16.0),
          ),
        ),
        home: Scaffold(
          appBar: AppBar(title: const Text('Virtual Bookshelf')),
          body: const Center(child: Text('Coming soon!')),
        ),
      ),
    );
  }
}