import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:being_the_parent_assignment/screens/home_screen.dart';
import 'screens/login_screen.dart';

class Authenticate extends StatelessWidget {
  const Authenticate({super.key});

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser != null) {
      return const HomeScreen();
    } else {
      return const LoginScreen();
    }
  }
}
