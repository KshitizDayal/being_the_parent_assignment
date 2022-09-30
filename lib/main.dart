import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:being_the_parent_assignment/authenticate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Being the parent assignment',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      home: const Authenticate(),
    );
  }
}
