import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:note_app/controllers/crud_services.dart';

class UpdateContact extends StatefulWidget {
  const UpdateContact({
    super.key,
    required this.docId,
    required this.name,
    required this.phone,
    required this.email,
    required this.code,
  });
  final String docId, name, phone, code, email;

  @override
  State<UpdateContact> createState() => _UpdateContactState();
}

class _UpdateContactState extends State<UpdateContact> {
  final TextEditingController _nameCont = TextEditingController();
  final TextEditingController _emailCont = TextEditingController();
  final TextEditingController _phoneCont = TextEditingController();
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
  void initState() {
    _nameCont.text = widget.name;
    _emailCont.text = widget.email;
    _phoneCont.text = widget.phone;
    _countryCode = widget.code;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Column(
          children: [
            const CircleAvatar(
              radius: 30,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person,
                color: Color.fromRGBO(99, 69, 138, 1),
                size: 40,
              ),
            ),
            Text(
              widget.name,
              style: const TextStyle(color: Colors.white),
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
        padding: const EdgeInsets.all(8),
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
                    label: const Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.person),
                        Text("Full Name"),
                      ],
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
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
              // TextFormField(
              //   validator: (value) => value!.length < 10
              //       ? "Provide PH Phone # and must be 10"
              //       : null,
              //   controller: _phoneCont,
              //   decoration: InputDecoration(
              //       label: const Row(
              //         mainAxisSize: MainAxisSize.min,
              //         mainAxisAlignment: MainAxisAlignment.start,
              //         children: [
              //           Icon(Icons.call),
              //           Text("Phone Number"),
              //         ],
              //       ),
              //       border: OutlineInputBorder(
              //           borderRadius: BorderRadius.circular(10))),
              // ),
              IntlPhoneField(
                validator: (phone) {
                  // Validate using the _validatePhoneNumber method
                  return _validatePhoneNumber(phone?.number);
                },
                controller: _phoneCont,
                initialCountryCode: _countryCode,
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
                    CRUDService().updateContact(_nameCont.text, _phoneCont.text,
                        _countryCode!, _emailCont.text, widget.docId);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Update Contact Successfully!"),
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
                      Icons.check,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Update",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              ElevatedButton(
                onPressed: () {
                  CRUDService().deleteContact(widget.docId);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Delete Contact Successfully!"),
                  ));
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(178, 136, 192, 1),
                    fixedSize: const Size(200, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.delete,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Delete",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w600),
                    )
                  ],
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
