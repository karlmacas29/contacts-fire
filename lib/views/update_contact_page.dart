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
        iconTheme: IconThemeData(color: Colors.white),
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
    );
  }
}
