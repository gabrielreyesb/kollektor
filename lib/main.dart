import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kollektor/screens/pruebas_menu_lateral.dart';

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
      /* theme: ThemeData(
        primaryColor: Colors.white,
        hintColor: Colors.yellow,
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ), */
      debugShowCheckedModeBanner: false,
      title: 'Kollektor',
      initialRoute: '/',
      routes: {
        '/': (context) => const Pruebas2(),
        '/': (context) => const PruebasMenuLateral(),
        //'/add': (context) => const AddAlbumScreen(),
      },
    );
  }
}
