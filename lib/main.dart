import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kollektor/screens/pruebas.dart';
import 'package:kollektor/screens/pruebas2.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Collektor',
      initialRoute: '/',
      routes: {
        '/': (context) => const Pruebas2(),
        //'/add': (context) => const AddAlbumScreen(),
      },
    );
  }
}
