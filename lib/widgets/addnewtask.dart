import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todolistapp/models/Task.dart';
import 'package:intl/intl.dart';

class NewTask extends StatefulWidget {
  NewTask(
      {Key? key,
      required this.id,
      required this.context,
      required this.action});
  final BuildContext context;
  final String action;
  final String id;

  // final void Function(Expense expense) addExpense;
  @override
  State<NewTask> createState() {
    return NewTaskState();
  }
}

class NewTaskState extends State<NewTask> {
  bool _show = true;
  int _radioValue = 0;

  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  String chosenCategory = "personal";
  //final _categoryController = TextEditingController();
  DateTime? selecteddate;

  void datePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final lastDate = DateTime(now.year + 1, now.month, now.day);
    final chosenDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: firstDate,
        lastDate: lastDate);
    setState(() {
      selecteddate = chosenDate;
    });
  }

  void submitData() async {
    if (_titleController.text.trim().isEmpty ||
        selecteddate == null ||
        _descController.text.trim().isEmpty) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Invalid Input"),
          content: const Text("Please make sure entered details are valid."),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: const Text("Okay"))
          ],
        ),
      );
      return;
    }
    final enteredtask = _titleController.text;
    final entereddesc = _descController.text;
    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get();
    if (widget.action == "add") {
      FirebaseFirestore.instance.collection('tasks').add({
        'text': enteredtask,
        'description': entereddesc,
        'category': chosenCategory.toString(),
        'createdAt': Timestamp.now(),
        'date': selecteddate,
        'userId': user.uid,
        'username': userData.data()!['username'],
        'userImage': userData.data()!['image_url'],
        'status': "incomplete"
      });
    } else if (widget.action == "edit") {
      print("Hi");
      FirebaseFirestore.instance.collection('tasks').doc(widget.id).update({
        "text": enteredtask,
      });
      FirebaseFirestore.instance.collection('tasks').doc(widget.id).update({
        "description": entereddesc,
      });
      FirebaseFirestore.instance.collection('tasks').doc(widget.id).update({
        "category": chosenCategory.toString(),
      });
      FirebaseFirestore.instance.collection('tasks').doc(widget.id).update({
        "date": selecteddate,
      });
      FirebaseFirestore.instance.collection('tasks').doc(widget.id).update({
        'createdAt': Timestamp.now(),
      });
    }
    _titleController.clear();
    _descController.clear();
    Navigator.pop(widget.context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    // _categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyspace = MediaQuery.of(context).viewInsets.bottom;
    return LayoutBuilder(builder: (ctx, constraints) {
      final width = constraints.maxWidth;
      return SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, keyspace + 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextField(
                        style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.normal),
                        controller: _titleController,
                        maxLength: 50,
                        decoration: InputDecoration(
                            label: Text(
                          "Task",
                          style: GoogleFonts.montserrat(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        )),
                      ),
                    ),
                    const SizedBox(
                      width: 24,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.normal),
                        controller: _descController,
                        maxLength: 50,
                        decoration: InputDecoration(
                            label: Text(
                          "Description of the task",
                          style: GoogleFonts.montserrat(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        )),
                      ),
                    ),
                    const SizedBox(
                      width: 24,
                    ),
                  ],
                ),
                Text(
                  "Type of task",
                  style: GoogleFonts.montserrat(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Radio(
                      value: 0,
                      groupValue: _radioValue,
                      onChanged: (value) {
                        setState(() {
                          _radioValue = value!;
                          chosenCategory = "personal";
                        });
                        print(chosenCategory);
                      },
                    ),
                    Text('Personal',
                        style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.normal)),
                    const SizedBox(width: 5),
                    Radio(
                      value: 1,
                      groupValue: _radioValue,
                      onChanged: (value) {
                        setState(() {
                          _radioValue = value!;
                          chosenCategory = "work";
                        });
                        print(chosenCategory);
                      },
                    ),
                    Text('Work',
                        style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.normal)),
                    Radio(
                      value: 2,
                      groupValue: _radioValue,
                      onChanged: (value) {
                        setState(() {
                          _radioValue = value!;
                          chosenCategory = "education";
                        });
                        print(chosenCategory);
                      },
                    ),
                    Text(
                      'Education',
                      style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.normal),
                    )
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  selecteddate == null
                      ? 'No date selected'
                      : DateFormat.MMMMEEEEd().format(selecteddate!),
                  style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.normal),
                ),
                IconButton(
                  onPressed: datePicker,
                  icon: const Icon(Icons.calendar_month),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 10, 4, 99)),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Cancel",
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 10, 4, 99)),
                      onPressed: submitData,
                      // Navigator.pop(context);
                      //},
                      child: Text(
                        "Save Task",
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
