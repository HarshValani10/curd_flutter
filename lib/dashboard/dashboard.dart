import 'package:flutter/material.dart';
import 'package:pro1/category/category_list.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder( // Use Builder to get correct context
          builder: (context) => IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer(); // Open drawer correctly
            },
          ),
        ),
        title: Text("Dashboar"),),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                "Menu",
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text("Category"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryList()));
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Center(child: Text("Dashboard is under Construction"))
        ],
      ),
    );
  }
}
