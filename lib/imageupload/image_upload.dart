import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/screen/profire_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ImageUpload extends StatefulWidget {
  final String? userId;
  const ImageUpload({Key? key, this.userId}) : super(key: key);

  @override
  State<ImageUpload> createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  // initializing some values
  File? _image;
  final imagePicker = ImagePicker();
  String? downloadURL;

  // picking the image

  Future imagePickerMethod() async {
    final pick = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pick != null) {
        _image = File(pick.path);
      } else {
        showSnackBar("ไม่มีไฟล์ที่เลือก", Duration(milliseconds: 400));
      }
    });
  }

  // uploading the image to firebase cloudstore
  Future uploadImage(File _image) async {
    final imgId = DateTime.now().millisecondsSinceEpoch.toString();
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    Reference reference = FirebaseStorage.instance
        .ref()
        .child('${widget.userId}/images')
        .child("post_$imgId");

    await reference.putFile(_image);
    downloadURL = await reference.getDownloadURL();

    // cloud firestore
    await firebaseFirestore
        .collection("profile")
        .doc(widget.userId)
        .collection("images")
        .add({'downloadURL': downloadURL}).whenComplete(
            () => showSnackBar("อัพโหลดรูปภาพสำเร็จ", Duration(seconds: 1)));
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return Profilescreen();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("อัพโหลดรูปภาพ"),
      ),
      body: Center(
        child: Padding(
            padding: const EdgeInsets.all(8),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: SizedBox(
                    height: 500,
                    width: double.infinity,
                    child: Column(children: [
                      const Text("อัพโหลดรูปภาพ"),
                      const SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        flex: 4,
                        child: Container(
                          width: 300,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.red),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // the image that we wanted to upload
                                Expanded(
                                    child: _image == null
                                        ? const Center(
                                            child: Text("ไม่มีรูปภาพที่เลือก"))
                                        : Image.file(_image!)),
                                ElevatedButton(
                                    onPressed: () {
                                      imagePickerMethod();
                                    },
                                    child: const Text("เลือกรูปภาพ")),
                                ElevatedButton(
                                    onPressed: () {
                                      if (_image != null) {
                                        uploadImage(_image!);
                                      } else {
                                        showSnackBar("กรุณาเลือกรูปภาพ",
                                            Duration(milliseconds: 400));
                                      }
                                    },
                                    child: const Text("อัพโหลดรูปภาพ")),
                              ],
                            ),
                          ),
                        ),
                      )
                    ])))),
      ),
    );
  }

  // show snack bar

  showSnackBar(String snackText, Duration d) {
    final snackBar = SnackBar(content: Text(snackText), duration: d);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
