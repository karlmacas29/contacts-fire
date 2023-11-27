import 'package:flutter/material.dart';
import 'package:contacts/controllers/auth_service.dart';

class SignWid extends StatefulWidget {
  const SignWid({super.key});

  @override
  State<SignWid> createState() => _SignWidState();
}

class _SignWidState extends State<SignWid> {
  final formKey = GlobalKey<FormState>();
  TextEditingController _emailCont = TextEditingController();
  TextEditingController _passCont = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: Image.asset(
              'image/phone.png',
              width: 100,
              height: 100,
            ),
            toolbarHeight: 150,
            backgroundColor: const Color.fromRGBO(99, 69, 138, 1),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(30),
              ),
            )),
        body: Container(
          margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 15,
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Create New Account",
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
                          .createAccountWithEmail(
                              _emailCont.text, _passCont.text)
                          .then((value) {
                        if (value == "Account Created") {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("Account Created"),
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
                      backgroundColor: const Color.fromRGBO(99, 69, 138, 1),
                      fixedSize: const Size(200, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600),
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
                          backgroundImage: AssetImage("image/google-icon.png"),
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
                    const Text("Already Have Account?"),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Login",
                          style: TextStyle(
                              color: Color.fromRGBO(99, 69, 138, 1),
                              fontWeight: FontWeight.bold),
                        ))
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
