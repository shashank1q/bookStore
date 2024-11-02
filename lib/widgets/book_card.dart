// lib/widgets/book_card.dart
// import 'package:book_manage_internship/routes.dart';
import 'package:firestore_test/constants/const.dart';
import 'package:firestore_test/models/user.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/book.dart';

class BookCard extends StatelessWidget {
  final Book book;
  final Myuser user;
  const BookCard({super.key, required this.book, required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: book.coverImageUrl == ""
            ? Image.asset('assets/noImage.png', width: 50, fit: BoxFit.cover)
            : Image.network(book.coverImageUrl, width: 50, fit: BoxFit.cover),
        title: Text(book.title),
        subtitle: Text("Author: ${book.author}"),
        trailing: Text("Rating: ${book.rating ?? 'N/A'}"),
        onTap: () {
          context.push(Myroutes.bookdetails, extra: [book, user]);
        },
      ),
    );
  }
}
