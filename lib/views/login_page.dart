import 'package:flutter/material.dart';
import 'package:note_app/controllers/auth_service.dart';

class LoginWid extends StatefulWidget {
  const LoginWid({super.key});

  @override
  State<LoginWid> createState() => _LoginWidState();
}

class _LoginWidState extends State<LoginWid> {
  final formKey = GlobalKey<FormState>();
  TextEditingController _emailCont = TextEditingController();
  TextEditingController _passCont = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: const Text(
              "Welcome To Contacts",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
          body: Container(
            margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  const SizedBox(
                    height: 15,
                  ),
                  const Center(
                    child: Text("Login",
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    validator: (value) =>
                        value!.isEmpty ? "Email Cannot Be Empty" : null,
                    controller: _emailCont,
                    decoration: InputDecoration(
                        label: const Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.email),
                            Text("Email"),
                          ],
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    validator: (value) => value!.length < 8
                        ? "Password Must Atleast 8 Characters"
                        : null,
                    obscureText: true,
                    controller: _passCont,
                    decoration: InputDecoration(
                        label: const Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.password),
                            Text("Password"),
                          ],
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        AuthService()
                            .loginWithEmail(_emailCont.text, _passCont.text)
                            .then((value) {
                          if (value == "Login Successful") {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("Login Successful"),
                            ));
                            Navigator.pushReplacementNamed(context, "/home");
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                value,
                                style: const TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Colors.red.shade400,
                            ));
                          }
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange[200],
                        fixedSize: const Size(200, 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    child: const Text(
                      "Login",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Text("Sign in Using"),
                  const SizedBox(
                    height: 15,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      AuthService().continueWithGoogle().then((value) {
                        if (value == "Google Login Successful") {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("Google Login Successful"),
                          ));
                          Navigator.pushReplacementNamed(context, "/home");
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                              value,
                              style: const TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.red.shade400,
                          ));
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        fixedSize: const Size(200, 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CircleAvatar(
                            backgroundImage:
                                AssetImage("image/google-icon.png"),
                            backgroundColor: Colors.white,
                          ),
                          Center(
                            child: Text(
                              "Google",
                              style: TextStyle(color: Colors.black),
                            ),
                          )
                        ]),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text("Don't have a account?"),
                      TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, "/signup");
                          },
                          child: Text(
                            "Sign Up",
                            style: TextStyle(color: Colors.deepOrange[400]),
                          ))
                    ],
                  )
                ],
              ),
            ),
          )),
    );
  }
}
