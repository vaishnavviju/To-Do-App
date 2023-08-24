import 'package:flutter/material.dart';
import 'package:todolistapp/screens/datewisetaskscreen.dart';
import 'package:todolistapp/screens/tasksscreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomePageState();
}

class _HomePageState extends State<HomeScreen> {
  int _currentIndex = 0;
  void _onIndexChange(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  final List<Widget> _pages = [TasksScreen(), TasksPage()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages.elementAt(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        backgroundColor: Color.fromARGB(255, 26, 23, 74),
        elevation: 1,
        type: BottomNavigationBarType.fixed,
        iconSize: 35,
        selectedItemColor: Color.fromARGB(255, 236, 197, 57),
        unselectedItemColor: Colors.grey.shade400,
        currentIndex: _currentIndex,
        onTap: _onIndexChange,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_rounded), label: "Tasks"),
          // BottomNavigationBarItem(
          //     icon: Icon(Icons.notifications_none_outlined),
          //     label: "Notifcation"),
          // BottomNavigationBarItem(
          //     icon: Icon(Icons.search_rounded), label: "Search"),
        ],
      ),
    );
  }
}
