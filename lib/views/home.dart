import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:note_app/controllers/auth_service.dart';
import 'package:note_app/controllers/crud_services.dart';
import 'package:note_app/views/update_contact_page.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //call
  callUser(String phone) async {
    String url = "tel:$phone";
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw "Could not launch $url ";
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, "/add");
          },
          child: const Icon(Icons.person_add)),
      appBar: AppBar(
        title: const Text(
          "Contacts",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
                child: Column(
              children: [
                CircleAvatar(
                    maxRadius: 32,
                    child: Text(FirebaseAuth.instance.currentUser!.email
                        .toString()[0]
                        .toUpperCase())),
                const SizedBox(
                  height: 10,
                ),
                Text(FirebaseAuth.instance.currentUser!.email.toString()),
              ],
            )),
            ListTile(
              onTap: () {
                AuthService().logout();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Logged Out"),
                ));
                Navigator.pushReplacementNamed(context, "/login");
              },
              leading: const Icon(Icons.logout_outlined),
              title: const Text("Logout"),
            )
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text("Something Went Wrong");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Text("Loading"),
            );
          }
          return ListView(
            children: snapshot.data!.docs
                .map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;
                  return ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UpdateContact(
                                    docId: document.id,
                                    name: data["name"],
                                    phone: data["phone"],
                                    email: data["email"],
                                  )));
                    },
                    leading: CircleAvatar(
                      child: Text(data["name"][0]),
                    ),
                    title: Text(
                      data["name"],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(data["phone"]),
                    trailing: IconButton(
                        onPressed: () {
                          callUser(data["phone"]);
                        },
                        icon: Icon(Icons.call)),
                  );
                })
                .toList()
                .cast(),
          );
        },
        stream: CRUDService().getContacts(),
      ),
    ));
  }
}
