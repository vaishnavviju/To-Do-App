import 'package:firebase_auth/firebase_auth.dart';
import 'package:todolistapp/screens/authscreen.dart';
import 'package:todolistapp/screens/datewisetaskscreen.dart';
import 'package:todolistapp/screens/homescreen.dart';
import 'package:todolistapp/screens/tasksscreen.dart';
import 'package:todolistapp/screens/splash.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:todolistapp/widgets/taskscroll.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlutterChat',
      theme: ThemeData().copyWith(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 63, 17, 177)),
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen();
          }
          if (snapshot.hasData) {
            return HomeScreen();
          }

          return const AuthScreen();
        },
      ),
    );
  }
}
