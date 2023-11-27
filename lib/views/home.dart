import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:contacts/controllers/auth_service.dart';
import 'package:contacts/controllers/crud_services.dart';
import 'package:contacts/views/update_contact_page.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

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
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          backgroundColor: const Color.fromRGBO(99, 69, 138, 1),
          onPressed: () {
            Navigator.pushNamed(context, "/add");
          },
          child: const Icon(
            Icons.person_add,
            color: Colors.white,
          )),
      appBar: AppBar(
        toolbarHeight: 70,
        flexibleSpace: Container(
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: const Color.fromRGBO(178, 136, 192, 1)),
        ),
        title: const Text(
          "Contacts",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
          child: Builder(
              builder: (context) => IconButton(
                    onPressed: () => Scaffold.of(context).openDrawer(),
                    icon: CircleAvatar(
                      backgroundColor: const Color.fromRGBO(99, 69, 138, 1),
                      maxRadius: 32,
                      child: Text(
                        FirebaseAuth.instance.currentUser!.email
                            .toString()[0]
                            .toUpperCase(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  )),
        ),
        leadingWidth: 60,
      ),
      drawer: Drawer(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        child: ListView(
          children: [
            DrawerHeader(
                child: Column(
              children: [
                CircleAvatar(
                  backgroundColor: const Color.fromRGBO(99, 69, 138, 1),
                  maxRadius: 32,
                  child: Text(
                    FirebaseAuth.instance.currentUser!.email
                        .toString()[0]
                        .toUpperCase(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
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
            ),
            const SizedBox(
              height: 10,
            ),
            ListTile(
              onTap: () {
                Provider.of<ThemeProvider>(context, listen: false)
                    .toggleTheme();
              },
              leading: const Icon(Icons.dark_mode),
              title: const Text("Switch Theme"),
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
            return Center(
                child: LoadingAnimationWidget.discreteCircle(
                    thirdRingColor: const Color.fromRGBO(178, 136, 192, 1),
                    secondRingColor: const Color.fromRGBO(228, 183, 229, 1),
                    color: const Color.fromRGBO(99, 69, 138, 1),
                    size: 75));
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
                      backgroundColor: const Color.fromRGBO(99, 69, 138, 1),
                      child: Text(
                        data["name"][0],
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(
                      data["name"],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(data["phone"]),
                    trailing: IconButton(
                        color: const Color.fromRGBO(99, 69, 138, 1),
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
    );
  }
}
