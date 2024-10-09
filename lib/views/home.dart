import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:note_app/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:note_app/controllers/auth_service.dart';
import 'package:note_app/controllers/crud_services.dart';
import 'package:note_app/views/update_contact_page.dart';
import 'package:flutter_switch/flutter_switch.dart';
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

  //darkMode is either true or false
  bool isOn = false;

  @override
  Widget build(BuildContext context) {
    //profile pic Google
    final User? user = FirebaseAuth.instance.currentUser;

    // Default values if user is null
    String photoUrl = 'image/account_c.png';

    if (user != null) {
      // Update values if user is not null
      photoUrl = user.photoURL ?? photoUrl;
    }

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
        backgroundColor: const Color.fromRGBO(99, 69, 138, 1),
        title: const Text(
          "Contacts",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
          child: Builder(
              builder: (context) => IconButton(
                    onPressed: () => Scaffold.of(context).openDrawer(),
                    icon: CircleAvatar(
                      backgroundImage: user != null
                          ? (photoUrl.startsWith('http') ||
                                  photoUrl.startsWith('https'))
                              ? NetworkImage(photoUrl)
                              : AssetImage(photoUrl) as ImageProvider<Object>?
                          : AssetImage(photoUrl),
                      backgroundColor: Colors.white,
                      radius: 20,
                    ),
                  )),
        ),
        leadingWidth: 70,
      ),
      drawer: Drawer(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        child: ListView(
          children: [
            DrawerHeader(
                child: Column(
              children: [
                CircleAvatar(
                  backgroundImage: user != null
                      ? (photoUrl.startsWith('http') ||
                              photoUrl.startsWith('https'))
                          ? NetworkImage(photoUrl)
                          : AssetImage(photoUrl) as ImageProvider<Object>?
                      : AssetImage(photoUrl),
                  backgroundColor: Colors.white,
                  maxRadius: 42,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(FirebaseAuth.instance.currentUser!.email.toString()),
              ],
            )),
            ListTile(
              leading: const Icon(Icons.dark_mode),
              title: Row(children: [
                const Text("Dark Mode"),
                const SizedBox(
                  width: 60,
                ),
                FlutterSwitch(
                  activeColor: const Color.fromRGBO(178, 136, 192, 1),
                  width: 60,
                  height: 30,
                  padding: 6,
                  valueFontSize: 30,
                  showOnOff: false,
                  value: isOn,
                  borderRadius: 30,
                  toggleSize: 20,
                  onToggle: (val) {
                    setState(() {
                      Provider.of<ThemeProvider>(context, listen: false)
                          .toggleTheme();
                      isOn = val;
                    });
                  },
                )
              ]),
            ),
            const SizedBox(height: 10),
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
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(
                child: Text("Something Went Wrong or No Data Connection"));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: LoadingAnimationWidget.discreteCircle(
                thirdRingColor: const Color.fromRGBO(178, 136, 192, 1),
                secondRingColor: const Color.fromRGBO(228, 183, 229, 1),
                color: const Color.fromRGBO(99, 69, 138, 1),
                size: 75,
              ),
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
                            code: data["countryCode"],
                          ),
                        ),
                      );
                    },
                    leading: CircleAvatar(
                      backgroundColor: const Color.fromRGBO(99, 69, 138, 1),
                      child: Text(
                        data["name"][0],
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(
                      "${data["name"]}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text("${data["countryCode"]}  ${data["phone"]}"),
                    trailing: IconButton(
                      color: const Color.fromRGBO(99, 69, 138, 1),
                      onPressed: () {
                        callUser(data["phone"]);
                      },
                      icon: const Icon(Icons.call),
                    ),
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
