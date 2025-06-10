import 'package:flutter/material.dart';
import 'package:pdmiu/providers/book_provider.dart';
import 'package:provider/provider.dart';
import 'pages/home_page.dart';
import 'services/database_helper.dart';
import 'package:google_fonts/google_fonts.dart';

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
          colorSchemeSeed: const Color(0xFF6750A4),
          textTheme: GoogleFonts.loraTextTheme(ThemeData().textTheme),
          useMaterial3: true,
        ),
        home: const HomePage(),
      ),
    );
  }
}