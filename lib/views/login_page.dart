import 'package:flutter/material.dart';
import 'package:note_app/controllers/auth_service.dart';

class LoginWid extends StatefulWidget {
  const LoginWid({super.key});

  @override
  State<LoginWid> createState() => _LoginWidState();
}

class _LoginWidState extends State<LoginWid> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _emailCont = TextEditingController();
  final TextEditingController _passCont = TextEditingController();
  bool _isShowPass = true;

  bool isEmailValid(String email) {
    // Basic email validation using a regular expression
    final RegExp emailRegex = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-]+$",
    );
    return emailRegex.hasMatch(email);
  }

  String? validatePassword(String password) {
    // Check if password is at least 12 characters long
    if (password.length < 12) {
      return 'Password must be at least 12 characters long';
    }

    // Check if password contains at least one uppercase letter
    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return 'Password must contain at least one capital letter';
    }

    // Check if password contains at least one symbol
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
      return 'Password must contain at least one special character';
    }

    // Check if password contains at least one number
    if (!RegExp(r'[0-9]').hasMatch(password)) {
      return 'Password must contain at least one number';
    }

    return null; // Password is valid
  }

  @override
  void dispose() {
    _emailCont.dispose();
    _passCont.dispose();
    super.dispose();
  }

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
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Container(
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email cannot be empty';
                      }
                      if (!isEmailValid(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                    controller: _emailCont,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: const Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password cannot be empty';
                      }

                      final passwordError = validatePassword(value);
                      if (passwordError != null) {
                        return passwordError; // Return specific error message
                      }

                      return null;
                    },
                    obscureText: _isShowPass,
                    controller: _passCont,
                    decoration: InputDecoration(
                      errorMaxLines: 2,
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.password),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _isShowPass = !_isShowPass;
                          });
                        },
                        icon: Icon(
                          _isShowPass ? Icons.visibility_off : Icons.visibility,
                        ),
                      ),
                    ),
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
                        backgroundColor: const Color.fromRGBO(99, 69, 138, 1),
                        fixedSize: const Size(200, 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    child: const Text(
                      "Login",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  // const Text("Sign in Using"),
                  // const SizedBox(
                  //   height: 15,
                  // ),
                  // ElevatedButton(
                  //   onPressed: () async {
                  //     await AuthService().continueWithGoogle().then((value) {
                  //       if (value == "Google Login Successful") {
                  //         ScaffoldMessenger.of(context)
                  //             .showSnackBar(const SnackBar(
                  //           content: Text("Google Login Successful"),
                  //         ));
                  //         Navigator.pushReplacementNamed(context, "/home");
                  //       } else {
                  //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  //           content: Text(
                  //             value,
                  //             style: const TextStyle(color: Colors.white),
                  //           ),
                  //           backgroundColor: Colors.red.shade400,
                  //         ));
                  //       }
                  //     });
                  //   },
                  //   style: ElevatedButton.styleFrom(
                  //       backgroundColor: Colors.white,
                  //       fixedSize: const Size(200, 50),
                  //       shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(10))),
                  //   child: const Row(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       children: <Widget>[
                  //         CircleAvatar(
                  //           backgroundImage: AssetImage("image/google-icon.png"),
                  //           backgroundColor: Colors.white,
                  //         ),
                  //         SizedBox(width: 10),
                  //         Center(
                  //           child: Text(
                  //             "Google",
                  //             style: TextStyle(color: Colors.black),
                  //           ),
                  //         )
                  //       ]),
                  // ),
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
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(
                                color: Color.fromRGBO(99, 69, 138, 1),
                                fontWeight: FontWeight.bold),
                          ))
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
