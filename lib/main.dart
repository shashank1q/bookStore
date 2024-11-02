import 'package:firestore_test/constants/const.dart';
import 'package:firestore_test/models/user.dart';
import 'package:firestore_test/ui/book_details.dart';
import 'package:firestore_test/ui/home.dart';
import 'package:firestore_test/ui/login.dart';
import 'package:firestore_test/ui/profile.dart';
import 'package:firestore_test/ui/signup.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

final GoRouter _router = GoRouter(initialLocation: Myroutes.login, routes: [
  GoRoute(
      path: Myroutes.login,
      pageBuilder: (context, state) => MaterialPage(child: LoginPage())),
  GoRoute(
      path: Myroutes.homepage,
      pageBuilder: (context, state) =>
          MaterialPage(child: HomeScreen(user: state.extra as Myuser))),
  GoRoute(
      path: Myroutes.signup,
      pageBuilder: (context, state) => MaterialPage(child: SignUpPage())),
  GoRoute(
      path: Myroutes.profile,
      pageBuilder: (context, state) =>
          MaterialPage(child: Profile(user: state.extra as Myuser))),
  GoRoute(
      path: Myroutes.bookdetails,
      pageBuilder: (context, state) {
        final data = state.extra as List;
        return MaterialPage(
            child: BookDetailsScreen(book: data[0], user: data[1]));
      }),
]);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
    );
  }
}
