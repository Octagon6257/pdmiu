import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _controller,
          decoration: InputDecoration(
            labelText: 'Search books',
            suffixIcon: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                // Search functionality to be implemented
              },
            ),
          ),
        ),
        const Expanded(
          child: Center(child: Text('Enter a search term to find books')),
        ),
      ],
    );
  }
}