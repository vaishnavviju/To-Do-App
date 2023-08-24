import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todolistapp/widgets/addnewtask.dart';
import 'package:todolistapp/widgets/overviewscroll.dart';
//import 'package:task_mangement/AddNewTask/AddNewTask.dart';
import 'package:todolistapp/widgets/taskcard.dart';
import 'package:todolistapp/widgets/taskscroll.dart';

import '../widgets/taskcard.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({
    Key? key,
  }) : super(key: key);
  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  DateTime _selectedDate = DateTime.now();
  void _onDateChange(DateTime date) {
    setState(() {
      this._selectedDate = date;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: const Color.fromRGBO(242, 244, 255, 1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(25),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                  )),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${DateFormat('MMM, d').format(this._selectedDate)}',
                        style: GoogleFonts.montserrat(
                          color: Colors.black,
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
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
                                      id: "",
                                      context: context,
                                      action: "add",
                                    ));
                              });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 10, 4, 99),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 20,
                              ),
                              Text(
                                "Add task",
                                style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 25),
                  DatePicker(
                    DateTime.now(),
                    initialSelectedDate: _selectedDate,
                    selectionColor: const Color.fromARGB(255, 10, 4, 99),
                    onDateChange: _onDateChange,
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Task Options",
                    style: GoogleFonts.montserrat(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: Size(150, 60),
                    backgroundColor: Color.fromARGB(255, 10, 4, 99)),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      return TaskScroll(
                        action: "view",
                      );
                    },
                  ));
                },
                child: Text(
                  "View Tasks",
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                )),
            const SizedBox(
              height: 50,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: Size(150, 60),
                    backgroundColor: Color.fromARGB(255, 10, 4, 99)),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      return TaskScroll(
                        action: "delete",
                      );
                    },
                  ));
                },
                child: Text(
                  "Delete Tasks",
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                )),
            const SizedBox(
              height: 50,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shadowColor: Colors.black,
                  elevation: 10,
                  minimumSize: Size(150, 60),
                  backgroundColor: Color.fromARGB(255, 10, 4, 99),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0)),
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      return TaskScroll(
                        action: "edit",
                      );
                    },
                  ));
                },
                child: Text(
                  "Edit Tasks",
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
