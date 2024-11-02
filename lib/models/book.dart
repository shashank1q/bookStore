class Book {
  final String title;
  final String author;
  final double? rating;
  final int publishYear;
  final int? coverId;

  Book(
      {required this.title,
      required this.author,
      required this.rating,
      required this.publishYear,
      required this.coverId});

  factory Book.fromApiJson(Map<String, dynamic> data) {
    return Book(
      title: data['title_sort'] ?? 'Unknown Title',
      author: (data['author_name'] as List<dynamic>?)?.join(', ') ??
          'Unknown Author',
      rating: data['ratings_average']?.toDouble(),
      publishYear: (data['publish_year'] as List<dynamic>?)?.first ?? 0,
      coverId: data['cover_i'],
    );
  }

  factory Book.fromJson(Map<String, dynamic> data) {
    return Book(
      title: data['title_sort'] ?? 'Unknown Title',
      author: data['author_name'] ?? 'Unknown Author',
      rating: data['ratings_average']?.toDouble(),
      publishYear: data['publish_year'],
      coverId: data['cover_i'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title_sort': title,
      'author_name': author,
      'ratings_average': rating,
      'publish_year': publishYear,
      'cover_i': coverId
    };
  }

  // Generate the cover image URL for displaying
  String get coverImageUrl => coverId != null
      ? "https://covers.openlibrary.org/b/id/$coverId-M.jpg"
      : "";
}
