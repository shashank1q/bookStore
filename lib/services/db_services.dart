import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firestore_test/models/book.dart';
import 'package:firestore_test/models/user.dart';

class DataService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // create user
  Future<Myuser?> createUser(User user, String referral) async {
    Myuser myuser =
        Myuser(uid: user.uid, email: user.email!, purchased: [], points: 0);
    try {
      await _db.collection('user').doc(user.uid).set(myuser.toMap());
      if (referral != "") {
        Myuser? temp = await addPoints(referral, myuser);
        if (temp != null) {
          myuser = temp;
        } else {
          print('Invalid referral code');
          _db.collection('user').doc(user.uid).delete();
          return null;
        }
      }
      return myuser;
    } catch (e) {
      print(e);
      return null;
    }
  }

  // get user
  Future<Myuser?> getUser(String uid) async {
    try {
      var snap = await _db.collection('user').doc(uid).get();
      if (snap.data() == null) {
        return null;
      }
      return Myuser.fromMap(snap.data()!);
    } catch (e) {
      print(e);
      return null;
    }
  }

  // add points
  Future<Myuser?> addPoints(String referralCode, Myuser user) async {
    Myuser? targetuser = await getUser(referralCode);
    if (targetuser == null) {
      print("can't find user with referral code referralCode");
      return null;
    }
    user.points += 50;
    targetuser.points += 100;
    await _db
        .collection('user')
        .doc(referralCode)
        .update({'points': targetuser.points});
    await _db.collection('user').doc(user.uid).update({'points': user.points});
    return user;
  }

  // purchase book
  Future<Myuser?> purchaseBook(Myuser user, Book book) async {
    user.purchased.add(book);
    await _db
        .collection('user')
        .doc(user.uid)
        .update({'purchased': user.purchased.map((e) => e.toJson()).toList()});
    return user;
  }
}
