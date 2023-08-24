import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todolistapp/screens/datewisetaskscreen.dart';
import 'package:todolistapp/widgets/overviewscroll.dart';
import 'package:todolistapp/widgets/taskcard.dart';

final _firebase = FirebaseAuth.instance;

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  @override
  String? name = "";
  String? email;
  String? image;

  void initState() {
    start();
    super.initState();
  }

  void start() async {
    final user = _firebase.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get();
    if (name != null && email != null && image != null) {
      return;
    }
    setState(() {
      name = userData.data()!["username"];
      email = userData.data()!["email"];
      image = userData.data()!["image_url"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      drawer: NavigationDrawer(
          backgroundColor: Colors.white,
          indicatorColor: Colors.white,
          shadowColor: Colors.white,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage((image != null) ? image! : ""),
              radius: 45,
            ),
            Container(
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    (name != null) ? name! : "",
                    style: GoogleFonts.montserrat(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    (email != null) ? email! : "",
                    style: GoogleFonts.montserrat(
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 26, 23, 74)),
                onPressed: () {
                  _firebase.signOut();
                },
                icon: const Icon(
                  Icons.exit_to_app_outlined,
                  color: Colors.white,
                ),
                label: Text("Log Out",
                    style: GoogleFonts.montserrat(
                        fontSize: 15, color: Colors.white)))
          ]),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color.fromARGB(255, 26, 23, 74),
        actions: [
          Container(
            child: Text(
              '${DateFormat.yMMMd().format((DateTime.now()))}',
              style: GoogleFonts.montserrat(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          ClipPath(
              clipper: CustomShape(),
              child: Container(
                alignment: Alignment.center,
                color: Color.fromARGB(255, 26, 23, 74),
                height: 150,
                width: double.infinity,
                child: Text(
                  "To-Do App",
                  style: GoogleFonts.lato(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )),
          Container(
            padding: const EdgeInsets.all(12),
            alignment: Alignment.topLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Hello, ",
                        style: GoogleFonts.roboto(
                          color: Colors.black,
                          fontSize: 30,
                        ),
                      ),
                      TextSpan(
                        text: (name == "") ? "" : "$name!",
                        style: GoogleFonts.roboto(
                          color: Colors.black,
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const Text(
                  "Hope you are having a wonderful day!",
                  style: TextStyle(color: Colors.grey),
                )
              ],
            ),
          ),
          OverView(),
        ],
      ),
    ));
  }
}

class CustomShape extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    double height = size.height;
    double width = size.width;
    var path = Path();
    path.lineTo(0, height - 50);
    path.quadraticBezierTo(width / 2, height, width, height - 50);
    path.lineTo(width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return true;
  }
}
