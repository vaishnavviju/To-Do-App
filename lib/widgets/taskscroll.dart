import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todolistapp/widgets/addnewtask.dart';

class TaskScroll extends StatefulWidget {
  TaskScroll({Key? key, required this.action}) : super(key: key);
  final String action;
  final GlobalKey scrollKey = GlobalKey();
  @override
  State<TaskScroll> createState() => _TaskScrollState();
}

class _TaskScrollState extends State<TaskScroll> {
  bool _isdelete = false;
  ScrollController scroll = ScrollController();
  Map<String, bool> delete = {};
  @override
  Widget build(BuildContext context) {
    final authUser = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 10, 4, 99),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 10, 4, 99),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
      ),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        controller: scroll,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(17),
              alignment: Alignment.topCenter,
              child: Text(
                "\nTasks",
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            if (widget.action == "delete")
              ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () {
                    delete.forEach((key, value) {
                      if (value == true) {
                        FirebaseFirestore.instance
                            .collection("tasks")
                            .doc(key)
                            .delete();
                      }
                    });
                    setState(() {});
                  },
                  child: Text(
                    "Delete",
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
            const SizedBox(
              height: 20,
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("tasks")
                  .where("userId", isEqualTo: authUser.uid)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text('No tasks available.'),
                  );
                }
                if (snapshot.hasError) {
                  return const Center(
                    child: Text('An error has occurred.'),
                  );
                }

                if (snapshot.hasData) {
                  final snap = snapshot.data!.docs;
                  return ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    itemCount: snap.length,
                    itemBuilder: (context, index) {
                      return Container(
                        //  height: 120,
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Color.fromARGB(255, 236, 197, 57),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              offset: Offset(2, 2),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            if (widget.action == "view" ||
                                widget.action == "delete")
                              Checkbox(
                                  //tristate: true,
                                  activeColor: Color.fromARGB(255, 10, 4, 99),
                                  value: (widget.action == "view")
                                      ? ((snap[index]['status'] == "incomplete")
                                          ? false
                                          : true)
                                      : ((delete.isEmpty ||
                                              !delete
                                                  .containsKey(snap[index].id))
                                          ? false
                                          : delete[snap[index].id]),
                                  onChanged: (value) {
                                    if (value == true &&
                                        widget.action == "view") {
                                      FirebaseFirestore.instance
                                          .collection("tasks")
                                          .doc(snap[index].id)
                                          .update({"status": "complete"});
                                    }
                                    if (value == false &&
                                        widget.action == "view") {
                                      FirebaseFirestore.instance
                                          .collection("tasks")
                                          .doc(snap[index].id)
                                          .update({"status": "incomplete"});
                                    } else if (widget.action == "delete" &&
                                        delete.containsKey(snap[index].id)) {
                                      setState(() {
                                        delete[snap[index].id] =
                                            !delete[snap[index].id]!;
                                      });
                                    } else {
                                      delete[snap[index].id] = true;
                                    }
                                  }),
                            if (widget.action == "edit")
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green),
                                  onPressed: () {
                                    showModalBottomSheet(
                                        backgroundColor:
                                            Color.fromARGB(255, 236, 197, 57),
                                        isScrollControlled: true,
                                        isDismissible: true,
                                        useSafeArea: true,
                                        context: context,
                                        builder: (context) {
                                          return FractionallySizedBox(
                                            heightFactor: 0.9,
                                            child: NewTask(
                                              id: snap[index].id,
                                              context: context,
                                              action: "edit",
                                            ),
                                          );
                                        });
                                    setState(() {});
                                  },
                                  child: Text(
                                    "Edit",
                                    style: GoogleFonts.montserrat(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )),
                            Container(
                              padding: EdgeInsets.all(15),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                snap[index]['text'],
                                style: GoogleFonts.montserrat(
                                  decoration:
                                      (snap[index]['status'] == "complete")
                                          ? TextDecoration.lineThrough
                                          : TextDecoration.none,
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Divider(
                              color: Colors.white,
                            ),
                            Container(
                              padding: EdgeInsets.all(15),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "${snap[index]['description']}",
                                style: GoogleFonts.montserrat(
                                  decoration:
                                      (snap[index]['status'] == "complete")
                                          ? TextDecoration.lineThrough
                                          : TextDecoration.none,
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                            Divider(
                              color: Colors.white,
                            ),
                            Container(
                              padding: EdgeInsets.all(15),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "${(DateFormat.MMMMEEEEd().format(snap[index]['date'].toDate()))}",
                                style: GoogleFonts.montserrat(
                                  decoration:
                                      (snap[index]['status'] == "complete")
                                          ? TextDecoration.lineThrough
                                          : TextDecoration.none,
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } else {
                  return const SizedBox();
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
