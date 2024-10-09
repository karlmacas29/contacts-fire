import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CRUDService {
  User? user = FirebaseAuth.instance.currentUser;

  //add new contact on firestore aka INSERT
  Future addNewContact(
      String name, String phone, String countryCode, String email) async {
    Map<String, dynamic> data = {
      "name": name,
      "phone": phone,
      "countryCode": countryCode,
      "email": email
    };
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .collection("contacts-fire")
          .add(data);

      // ignore: avoid_print
      print("Document Added");
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }

  //read as SELECT
  Stream<QuerySnapshot> getContacts() async* {
    var contacts = FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .collection("contacts-fire")
        .orderBy("name")
        .snapshots();

    yield* contacts;
  }

  //Update
  Future updateContact(String name, String phone, String countryCode,
      String email, String docId) async {
    Map<String, dynamic> data = {
      "name": name,
      "phone": phone,
      "countryCode": countryCode,
      "email": email
    };
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .collection("contacts-fire")
          .doc(docId)
          .update(data);

      // ignore: avoid_print
      print("Document Updated");
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }

  //Delete
  Future deleteContact(String docId) async {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .collection("contacts-fire")
          .doc(docId)
          .delete();
      // ignore: avoid_print
      print("Contact Deleted");
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }
}
