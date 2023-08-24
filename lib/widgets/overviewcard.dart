import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

enum category { personal, work, education }

class OverviewCard extends StatefulWidget {
  const OverviewCard({
    Key? key,
    required this.task,
    required this.description,
    required this.completeDate,
    required this.category,
  }) : super(key: key);
  final String task;
  final String category;
  final String description;
  final DateTime completeDate;

  @override
  State<OverviewCard> createState() => _OverviewCardState();
}

class _OverviewCardState extends State<OverviewCard> {
  bool _ischecked = false;

  @override
  Widget build(BuildContext context) {
    IconData icon = Icons.note;
    if (widget.category == "personal") {
      icon = Icons.person;
    } else if (widget.category == "work") {
      icon = Icons.work;
    } else if (widget.category == "education") {
      icon = Icons.menu_book;
    }
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(left: 0, right: 20, top: 5, bottom: 5),
      width: 180,
      height: 250,
      decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(blurRadius: 5.0, blurStyle: BlurStyle.outer),
          ],
          borderRadius: BorderRadius.circular(20.0),
          color: Color.fromARGB(255, 236, 197, 57)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Checkbox(
          //     value: _ischecked,
          //     onChanged: (value) {
          //       setState(() {
          //         _ischecked = !_ischecked;
          //       });
          //     }),
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                margin: const EdgeInsets.only(right: 10),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 238, 221, 172),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Icon(icon, color: Colors.white),
              ),
            ],
          ),
          Text(
            widget.task,
            style: GoogleFonts.montserrat(
                color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const Divider(
            color: Colors.white,
          ),
          Text(
            "${widget.description}",
            style: GoogleFonts.montserrat(color: Colors.white, fontSize: 15),
          ),
          const Divider(
            color: Colors.white,
          ),
          Text(
            '${DateFormat.MMMd().format((widget.completeDate))}',
            style: GoogleFonts.montserrat(
                color: ((((DateTime.parse(DateFormat('yyyy-MM-dd')
                            .format(widget.completeDate.toLocal())))
                        .isBefore(DateTime.parse(
                            DateFormat('yyyy-MM-dd').format(DateTime.now()))))))
                    ? Colors.red
                    : Colors.green,
                fontSize: 15,
                fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
