import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:note_app/views/add_contact_page.dart';
import 'package:note_app/views/home.dart';
import 'package:note_app/views/login_page.dart';
import 'package:note_app/views/signup_page.dart';
import 'firebase_options.dart';
import 'package:note_app/controllers/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contacts Fire',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orangeAccent),
        useMaterial3: true,
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => const CheckUser(),
        "/login": (context) => const LoginWid(),
        "/home": (context) => const HomePage(),
        "/signup": (context) => const SignWid(),
        "/add": (context) => const AddContact()
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

//check if the use is logged in or not

class CheckUser extends StatefulWidget {
  const CheckUser({super.key});

  @override
  State<CheckUser> createState() => _CheckUserState();
}

class _CheckUserState extends State<CheckUser> {
  @override
  void initState() {
    AuthService().isLoggedIn().then((value) {
      if (value) {
        Navigator.pushReplacementNamed(context, "/home");
      } else {
        Navigator.pushReplacementNamed(context, "/login");
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
