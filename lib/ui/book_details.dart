// lib/screens/book_details_screen.dart
import 'package:firestore_test/models/user.dart';
import 'package:firestore_test/services/db_services.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/book.dart';

class BookDetailsScreen extends StatelessWidget {
  final Book book;
  final Myuser user;

  final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

  BookDetailsScreen({super.key, required this.book, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(book.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: book.coverImageUrl == ""
                  ? Image.asset('assets/noImage.png')
                  : Image.network(
                      book.coverImageUrl,
                      height: 200,
                      width: 150,
                      fit: BoxFit.cover,
                    ),
            ),
            const SizedBox(height: 20),
            Text("Title: ${book.title}",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text("Author: ${book.author}"),
            Text("Rating: ${book.rating ?? 'N/A'}"),
            Text("Published Year: ${book.publishYear}"),
            const SizedBox(height: 20),
            user.purchased.contains(book)
                ? const SizedBox()
                : ElevatedButton(
                    onPressed: () => _buyBook(context),
                    child: const Text("Buy"),
                  ),
          ],
        ),
      ),
    );
  }

  void _buyBook(BuildContext context) async {
    showDialog(
        barrierColor: Colors.black54,
        barrierDismissible: false,
        context: context,
        builder: (context) => const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ));
    Myuser? temp = await DataService().purchaseBook(user, book);
    Navigator.of(context).pop();
    if (temp != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('purchase successful'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('purchase failed'),
        ),
      );
    }
  }
}
