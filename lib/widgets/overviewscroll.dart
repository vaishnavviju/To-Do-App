import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:todolistapp/widgets/overviewcard.dart';

class OverView extends StatefulWidget {
  const OverView({Key? key}) : super(key: key);

  @override
  State<OverView> createState() => _OverViewState();
}

class _OverViewState extends State<OverView> with TickerProviderStateMixin {
  late TabController tabController;
  int page = 0;
  @override
  void initState() {
    //start();
    tabController = TabController(length: 6, vsync: this, initialIndex: 0);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TabBar(
            enableFeedback: true,
            controller: tabController,
            labelColor: Colors.blueAccent,
            isScrollable: true,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            padding: EdgeInsets.all(0),
            unselectedLabelColor: Color.fromARGB(255, 8, 4, 68),
            tabs: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 8, 4, 68)),
                onPressed: () {
                  setState(() {
                    page = 0;
                  });
                },
                child: Text(
                  "Tasks",
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 8, 4, 68)),
                onPressed: () {
                  setState(() {
                    page = 1;
                  });
                },
                child: Text(
                  "Pending",
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 8, 4, 68)),
                onPressed: () {
                  setState(() {
                    page = 2;
                  });
                },
                child: Text(
                  "Overdue",
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 8, 4, 68)),
                onPressed: () {
                  setState(() {
                    page = 3;
                  });
                },
                child: Text(
                  "Personal",
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 8, 4, 68)),
                onPressed: () {
                  setState(() {
                    page = 4;
                  });
                },
                child: Text(
                  "Work",
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 8, 4, 68)),
                onPressed: () {
                  setState(() {
                    page = 5;
                  });
                },
                child: Text(
                  "Education",
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 250,
            child: TabBarView(
              physics: AlwaysScrollableScrollPhysics(),
              controller: tabController,
              children: [
                start(page),
                start(page),
                start(page),
                start(page),
                start(page),
                start(page)
              ],
            ),
          )
        ],
      ),
    );
  }
}

Widget start(int a) {
  final authUser = FirebaseAuth.instance.currentUser!;
  return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('tasks')
          .where("userId", isEqualTo: authUser.uid)
          .snapshots(),
      builder: (context, snapshot) {
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

        final messages = snapshot.data!.docs;

        if (a == 0) {
          return ListView.builder(
              itemCount: messages.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return OverviewCard(
                    task: messages[index].data()['text'],
                    description: messages[index].data()['description'],
                    category: messages[index].data()['category'],
                    completeDate: (messages[index].data()['date']).toDate());
              });
        } else if (a == 1) {
          return ListView.builder(
              itemCount: messages.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                if (((DateTime.parse(DateFormat('yyyy-MM-dd').format(
                            messages[index].data()['date'].toDate().toLocal())))
                        .compareTo(DateTime.parse(DateFormat('yyyy-MM-dd')
                            .format(DateTime.now())))) ==
                    1) {
                  return OverviewCard(
                      task: messages[index].data()['text'],
                      description: messages[index].data()['description'],
                      category: messages[index].data()['category'],
                      completeDate: (messages[index].data()['date']).toDate());
                } else {
                  return Container();
                }
              });
        } else if (a == 2) {
          return ListView.builder(
              itemCount: messages.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                if (DateTime.parse(DateFormat('yyyy-MM-dd')
                        .format(messages[index].data()['date'].toDate()))
                    .isBefore(DateTime.parse(
                        DateFormat('yyyy-MM-dd').format(DateTime.now())))) {
                  return OverviewCard(
                      task: messages[index].data()['text'],
                      description: messages[index].data()['description'],
                      category: messages[index].data()['category'],
                      completeDate: (messages[index].data()['date']).toDate());
                } else {
                  return Container();
                }
              });
        } else if (a == 3) {
          return ListView.builder(
              itemCount: messages.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                if (messages[index].data()['category'] == "personal") {
                  return OverviewCard(
                      task: messages[index].data()['text'],
                      description: messages[index].data()['description'],
                      category: messages[index].data()['category'],
                      completeDate: (messages[index].data()['date']).toDate());
                } else {
                  return Container();
                }
              });
        } else if (a == 4) {
          return ListView.builder(
              itemCount: messages.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                if (messages[index].data()['category'] == "work") {
                  return OverviewCard(
                      task: messages[index].data()['text'],
                      description: messages[index].data()['description'],
                      category: messages[index].data()['category'],
                      completeDate: (messages[index].data()['date']).toDate());
                } else {
                  return Container();
                }
              });
        } else if (a == 5) {
          return ListView.builder(
              itemCount: messages.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                if (messages[index].data()['category'] == "education") {
                  return OverviewCard(
                      task: messages[index].data()['text'],
                      description: messages[index].data()['description'],
                      category: messages[index].data()['category'],
                      completeDate: (messages[index].data()['date']).toDate());
                } else {
                  return Container();
                }
              });
        } else {
          return Container();
        }
      });
}
