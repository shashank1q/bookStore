import 'package:firestore_test/models/book.dart';

class Myuser {
  final String uid;
  final String email;
  List<Book> purchased;
  int points;

  Myuser(
      {required this.uid,
      required this.email,
      required this.purchased,
      required this.points});

  factory Myuser.fromMap(Map data) {
    return Myuser(
      uid: data['uid'],
      email: data['email'],
      points: data['points'],
      purchased: data['purchased'] != null
          ? List<Book>.from(data['purchased'].map((x) {
              // print(x);
              return Book.fromJson(x);
            }))
          : [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'purchased': purchased,
      'points': points,
    };
  }
}
