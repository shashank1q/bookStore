// email password sign up page

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firestore_test/constants/const.dart';
// import 'package:firestore_test/main.dart';
import 'package:firestore_test/models/user.dart';
import 'package:firestore_test/services/auth_services.dart';
import 'package:firestore_test/services/db_services.dart';
// import 'package:firestore_test/ui/home.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({super.key});
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController referralController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Sign Up',
              style: TextStyle(fontSize: 24),
            ),
            // email
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                ),
              ),
            ),
            // password
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                controller: passwordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
            ),
            // referral
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: referralController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'referral',
                ),
              ),
            ),
            // button
            ElevatedButton(
              onPressed: () => _signup(context),
              child: const Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }

  _signup(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.black54,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
    Auth auth = Auth();
    User? user =
        await auth.signup(emailController.text, passwordController.text);
    if (!context.mounted) return;
    if (user != null) {
      Myuser? currUser =
          await DataService().createUser(user, referralController.text);
      if (!context.mounted) return;
      if (currUser == null) {
        auth.deleteUser();
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid referral code'),
          ),
        );
        return;
      }
      if (!context.mounted) return;
      Navigator.of(context).pop();
      context.pushReplacement(Myroutes.homepage, extra: currUser);
    } else {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to sign up'),
        ),
      );
    }
  }
}
