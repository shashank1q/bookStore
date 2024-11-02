// login page using email password
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firestore_test/constants/const.dart';
import 'package:firestore_test/models/user.dart';
import 'package:firestore_test/services/auth_services.dart';
import 'package:firestore_test/services/db_services.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Login',
              style: TextStyle(fontSize: 24),
            ),
            // email
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
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
                controller: passwordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
            ),
            // button
            ElevatedButton(
              onPressed: () => login(context),
              child: const Text('Login'),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                context.push(Myroutes.signup);
                // Navigator.of(context).push(
                //     MaterialPageRoute(builder: (context) => SignUpPage()));
              },
              child: const Text('Create an account'),
            ),
          ],
        ),
      ),
    );
  }

  void login(BuildContext context) async {
    showDialog(
        barrierColor: Colors.black54,
        barrierDismissible: false,
        context: context,
        builder: (context) => const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ));
    User? newuser =
        await Auth().login(emailController.text, passwordController.text);
    if (newuser != null) {
      Myuser? user = await DataService().getUser(newuser.uid);
      if (user == null) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to get user data, try again'),
          ),
        );
        return;
      }
      Navigator.of(context).pop();
      if (!context.mounted) return;
      context.pushReplacement(Myroutes.homepage, extra: user);
    } else {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid email or password, try again'),
        ),
      );
    }
  }
}
