class Book {
  final String title;
  final String author;

  Book({required this.title, required this.author});

  Map<String, dynamic> toMap() {
    return {'title': title, 'author': author};
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      title: map['title'] as String,
      author: map['author'] as String,
    );
  }
}