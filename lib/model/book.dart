class Book {
  final int? id;
  final String title;
  final String author;

  Book({this.id, required this.title, required this.author});

  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'author': author};
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'] as int?,
      title: map['title'] as String,
      author: map['author'] as String,
    );
  }
}