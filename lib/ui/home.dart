import 'package:firestore_test/constants/const.dart';
import 'package:firestore_test/models/user.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/api_service.dart';
import '../widgets/book_card.dart';
import '../models/book.dart';

class HomeScreen extends StatefulWidget {
  final Myuser user;
  const HomeScreen({super.key, required this.user});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Book> books = [];
  List<Book> filteredBooks = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchBooks();
  }

  void _fetchBooks() async {
    books = await ApiService().fetchBooks();
    setState(() {
      filteredBooks = books;
    });
  }

  void _searchBooks(String query) {
    final results = books.where((book) {
      final title = book.title.toLowerCase();
      final author = book.author.toLowerCase();
      final searchLower = query.toLowerCase();
      return title.contains(searchLower) || author.contains(searchLower);
    }).toList();

    setState(() {
      filteredBooks = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookstore'),
        actions: [
          IconButton(
              onPressed: () {
                context.push(Myroutes.profile, extra: widget.user);
              },
              icon: const Icon(Icons.person))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search by title or author',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: _searchBooks,
              ),
            ),
            Expanded(
              child: filteredBooks.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: filteredBooks.length,
                      itemBuilder: (context, index) {
                        return BookCard(
                            book: filteredBooks[index], user: widget.user);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
