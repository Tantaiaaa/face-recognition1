import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/imageupload/image_upload.dart';
import 'package:flutter_application_1/imageupload/show_image.dart';
import 'package:flutter_application_1/screen/profile.dart';

class Profilescreen extends StatefulWidget {
  const Profilescreen({Key? key}) : super(key: key);

  @override
  _Profilescreen createState() => _Profilescreen();
}

class _Profilescreen extends State<Profilescreen> {
  User? user = FirebaseAuth.instance.currentUser;
  Profile loggedInuser = Profile();
  Profile profile = Profile();

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("profile")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInuser = Profile.fromMap(value.data());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("โปรไฟล์", textScaleFactor: 1.5),
        centerTitle: false,
        leading: BackButton(color: Colors.black),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Text("อีเมล ${loggedInuser.email}",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  )),
              Text("คณะ ${loggedInuser.group}",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  )),
              Text("หรัสประจำตัว ${loggedInuser.id}",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  )),
              Text("ชื่อ-นามสกุล ${loggedInuser.name}",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  )),
              Text("เบอร์โทร ${loggedInuser.phone}",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  )),
              SizedBox(
                height: 80,
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ImageUpload(
                                  userId: loggedInuser.uid,
                                )));
                  },
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.redAccent)),
                  child: Text('อัพโหลดรูปภาพ')),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ImageRetrive()));
                  },
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.redAccent)),
                  child: Text('โชว์รูปภาพที่อัพโหลด'))
            ],
          ),
        ),
      ),
    );
  }
}
