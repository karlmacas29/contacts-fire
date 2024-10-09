import 'package:flutter/material.dart';
import 'package:note_app/controllers/crud_services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class AddContact extends StatefulWidget {
  const AddContact({super.key});

  @override
  State<AddContact> createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {
  final TextEditingController _nameCont = TextEditingController();
  final TextEditingController _emailCont = TextEditingController();
  String? _phoneNumber;
  String? _countryCode;
  final formKey = GlobalKey<FormState>();

  String? _validatePhoneNumber(String? value) {
    // Validate the phone number
    if (value == null || value.isEmpty) {
      return 'Phone number cannot be empty';
    }

    // Additional validation logic (for example, check if the number is valid)
    // Here we can also check for length or specific patterns
    if (value.length < 10) {
      return 'Please enter a valid phone number';
    }

    return null; // If valid, return null
  }

  bool isEmailValid(String email) {
    // Basic email validation using a regular expression
    final RegExp emailRegex = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-]+$",
    );
    return emailRegex.hasMatch(email);
  }

  @override
  void dispose() {
    _emailCont.dispose();
    _nameCont.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Column(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person_add,
                color: Color.fromRGBO(99, 69, 138, 1),
                size: 40,
              ),
            ),
            Text(
              "Create New Contact",
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
        toolbarHeight: 150,
        backgroundColor: const Color.fromRGBO(99, 69, 138, 1),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Form(
            key: formKey,
            child: Column(children: [
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                validator: (value) =>
                    value!.isEmpty ? "Provide FullName" : null,
                controller: _nameCont,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: const Icon(Icons.person),
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
                    return 'Email cannot be empty';
                  }
                  if (!isEmailValid(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
                controller: _emailCont,
                decoration: InputDecoration(
                    labelText: 'User Email',
                    prefixIcon: const Icon(Icons.email),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
              const SizedBox(
                height: 15,
              ),
              // TextFormField(
              //   validator: (value) => value!.length < 10
              //       ? "Provide PH Phone # and must be 10"
              //       : null,
              //   controller: _phoneCont,
              //   decoration: InputDecoration(
              //     labelText: 'Phone Number',
              //     prefixIcon: const Icon(Icons.call),
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(10),
              //     ),
              //   ),
              // ),
              IntlPhoneField(
                validator: (phone) {
                  // Validate using the _validatePhoneNumber method
                  return _validatePhoneNumber(phone?.number);
                },
                onChanged: (phone) {
                  // This is where you can get the country code and phone number
                  String countryCode =
                      phone.countryISOCode; // Get the country code
                  String phoneNumber = phone.number; // Get the phone number

                  setState(() {
                    _countryCode = countryCode;
                    _phoneNumber = phoneNumber;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    CRUDService().addNewContact(_nameCont.text, _phoneNumber!,
                        _countryCode!, _emailCont.text);

                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Contacts Added!"),
                    ));
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(99, 69, 138, 1),
                    fixedSize: const Size(200, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.person_add,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Add Contact",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600),
                    )
                  ],
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
