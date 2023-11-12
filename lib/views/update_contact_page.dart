import 'package:flutter/material.dart';
import 'package:note_app/controllers/crud_services.dart';

class UpdateContact extends StatefulWidget {
  const UpdateContact(
      {super.key,
      required this.docId,
      required this.name,
      required this.phone,
      required this.email});
  final String docId, name, phone, email;

  @override
  State<UpdateContact> createState() => _UpdateContactState();
}

class _UpdateContactState extends State<UpdateContact> {
  TextEditingController _nameCont = TextEditingController();
  TextEditingController _emailCont = TextEditingController();
  TextEditingController _phoneCont = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _nameCont.text = widget.name;
    _emailCont.text = widget.email;
    _phoneCont.text = widget.phone;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Edit Contact",
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
                  CRUDService().updateContact(_nameCont.text, _phoneCont.text,
                      _emailCont.text, widget.docId);
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange[200],
                  fixedSize: const Size(200, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              child: const Text(
                "Update Contact",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(
              onPressed: () {
                CRUDService().deleteContact(widget.docId);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent[200],
                  fixedSize: const Size(200, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              child: const Text(
                "Delete Contact",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
