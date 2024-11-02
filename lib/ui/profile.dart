import 'package:firestore_test/models/user.dart';
import 'package:firestore_test/services/db_services.dart';
import 'package:firestore_test/widgets/book_card.dart';
import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  final Myuser user;
  const Profile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: FutureBuilder(
        future: DataService().getUser(user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.data == null) {
              return const Center(child: Text('User not found'));
            }
            Myuser user = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  const SizedBox(height: 20),
                  Text('Points: ${user.points}'),
                  const SizedBox(height: 10),
                  Text('Email: ${user.email}'),
                  const SizedBox(height: 10),
                  Text('referral code: ${user.uid}'),
                  const SizedBox(height: 20),
                  const Text('Book Purchased'),
                  const SizedBox(height: 10),
                  user.purchased.isEmpty
                      ? const Text('No books purchased')
                      : Column(
                          children: user.purchased
                              .map((book) => BookCard(book: book, user: user))
                              .toList(),
                        ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
