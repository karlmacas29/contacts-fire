import 'package:flutter/material.dart';
import 'package:note_app/controllers/crud_services.dart';

class AddContact extends StatefulWidget {
  const AddContact({super.key});

  @override
  State<AddContact> createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {
  TextEditingController _nameCont = TextEditingController();
  TextEditingController _emailCont = TextEditingController();
  TextEditingController _phoneCont = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add Contact",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Form(
          key: formKey,
          child: Column(children: [
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              validator: (value) => value!.isEmpty ? "Provide FullName" : null,
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
              validator: (value) => value!.isEmpty ? "Provide Email" : null,
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
              validator: (value) => value!.length < 10
                  ? "Provide PH Phone # and must be 10"
                  : null,
              controller: _phoneCont,
              decoration: InputDecoration(
                  label: const Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.call),
                      Text("Phone Number"),
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
                  CRUDService().addNewContact(
                      _nameCont.text, _phoneCont.text, _emailCont.text);
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange[200],
                  fixedSize: const Size(200, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              child: const Text(
                "Add To Contact",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
