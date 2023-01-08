import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen/history_screen.dart';
import 'package:flutter_application_1/screen/loginsreen.dart';
import 'package:flutter_application_1/screen/profire_screen.dart';

class MakeDashboardItems extends StatefulWidget {
  const MakeDashboardItems({Key? key}) : super(key: key);

  @override
  _MakeDashboardItemsState createState() => _MakeDashboardItemsState();
}

class _MakeDashboardItemsState extends State<MakeDashboardItems> {
  Card makeDashboardItem(String title, String img, int index) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(10),
      child: Container(
        decoration: index == 0 || index == 3 || index == 4
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF004B8D),
                    Color(0xFFffffff),
                  ],
                ),
              )
            : BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                gradient: const LinearGradient(
                  colors: [
                    Colors.red,
                    Colors.orange,
                  ],
                ),
              ),
        child: InkWell(
          onTap: () {
            if (index == 1) {
              Navigator.push(context,
                  MaterialPageRoute(builder: ((context) => Profilescreen())));
            }
            if (index == 2) {
              Navigator.push(context,
                  MaterialPageRoute(builder: ((context) => historysreen())));
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            verticalDirection: VerticalDirection.down,
            children: [
              const SizedBox(height: 60),
              Center(
                child: Image.asset(
                  img,
                  height: 100,
                  width: 100,
                ),
              ),
              const SizedBox(height: 40),
              Center(
                child: Text(
                  title,
                  style: const TextStyle(
                      fontSize: 30,
                      color: Color.fromARGB(255, 16, 3, 3),
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 70,
        title: Text(
          "เมนู",
          style: TextStyle(
            color: Colors.black,
            fontSize: 23,
          ),
          textScaleFactor: 1.75,
        ),
        shadowColor: Colors.orange,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              child: Icon(
                Icons.logout,
                size: 30,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Color.fromARGB(255, 255, 190, 129),
      body: Column(
        children: [
          const SizedBox(height: 1),
          Expanded(
            child: GridView.count(
              crossAxisCount: 1,
              padding: const EdgeInsets.all(40),
              children: [
                makeDashboardItem("โปรไฟล์ผู้ใช้งาน", "assets/p.png", 1),
                makeDashboardItem("ประวัติการเข้าเรียน", "assets/h.png", 2),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
