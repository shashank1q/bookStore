import 'package:firestore_test/models/user.dart';
import 'package:firestore_test/services/db_services.dart';
import 'package:firestore_test/widgets/book_card.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    RichText(
                      text: TextSpan(
                        text: 'Points: ',
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: user.points.toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    RichText(
                        text: TextSpan(
                      text: 'Email: ',
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: user.email,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )),
                    const SizedBox(height: 10),
                    RichText(
                        text: TextSpan(
                      text: 'Referral code: ',
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: user.uid,
                          recognizer: LongPressGestureRecognizer()
                            ..onLongPress = () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Copied to clipboard'),
                                ),
                              );
                              Clipboard.setData(ClipboardData(text: user.uid));
                            },
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )),
                    const SizedBox(height: 20),
                    const Text(
                      'Book Purchased',
                      style: TextStyle(fontSize: 25),
                    ),
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
              ),
            );
          }
        },
      ),
    );
  }
}
