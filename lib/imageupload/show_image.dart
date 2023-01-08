import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ImageRetrive extends StatefulWidget {
  final String? userId;
  const ImageRetrive({Key? key, this.userId}) : super(key: key);

  @override
  State<ImageRetrive> createState() => _ImageRetriveState();
}

class _ImageRetriveState extends State<ImageRetrive> {
  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: const Text("รูปภาพที่อัพโหลด", textScaleFactor: 1.5)),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("profile")
            .doc(user!.uid)
            .collection("images")
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.docs.length != 0) {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  String url = snapshot.data!.docs[index]['downloadURL'];
                  return Image.network(
                    url,
                    height: 500,
                    fit: BoxFit.fitWidth,
                  );
                },
              );
            } else {
              return Center(
                child: Text("ไม่มีรูปที่อัพโหลด"),
              );
            }
          } else {
            return (const Center(
              child: CircularProgressIndicator(),
            ));
          }
        },
      ),
    );
  }
}
