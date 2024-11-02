import 'package:dio/dio.dart';
import '../models/book.dart';

class ApiService {
  static const String apiUrl = 'https://openlibrary.org/search.json?q=trending';

  // Fetch books from the API and convert them to a list of Book instances
  Future<List<Book>> fetchBooks() async {
    try {
      final response = await Dio().get(apiUrl);
      final data = Map.from(response.data);
      return (data['docs'] as List<dynamic>).map((bookData) {
        return Book.fromApiJson(bookData);
      }).toList();
    } catch (e) {
      print('Error fetching books: $e');
      return [];
    }
  }
}
