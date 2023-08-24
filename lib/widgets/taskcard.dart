import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TaskCard extends StatefulWidget {
  TaskCard({Key? key, required this.task, required this.completeDate})
      : super(key: key);
  late String task;
  late DateTime completeDate;

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  bool _ischecked = false;
  void strikeCheck(_ischecked) {}

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 3.0,
            margin: const EdgeInsets.only(top: 10),
            height: 49 * 0.01 * 30,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 10, 4, 99),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Container(
            height: 70,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(children: [
              Checkbox(
                  value: _ischecked,
                  onChanged: (value) {
                    setState(() {
                      _ischecked = !_ischecked;
                    });
                    strikeCheck(_ischecked);
                  }),
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 10, 4, 99),
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                child: const Icon(Icons.assignment, color: Colors.white),
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(widget.task,
                      style: GoogleFonts.montserrat(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        decoration: _ischecked
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      )),
                  Text(
                    widget.completeDate.toString(),
                    style: GoogleFonts.montserrat(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      decoration: _ischecked
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  // Text(
                  //   "2 days ago",
                  //   style: GoogleFonts.montserrat(
                  //     color: Colors.grey,
                  //     fontSize: 10,
                  //     fontWeight: FontWeight.w600,
                  //   ),
                  // )
                ],
              ),
              Expanded(child: Container()),
            ]),
          ),
        ],
      ),
    );
  }
}
