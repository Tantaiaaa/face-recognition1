import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen/loginsreen.dart';
import 'package:flutter_application_1/screen/profile.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();
  String? errorMessage;
  Profile profile = Profile();
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  CollectionReference profileCollection =
      FirebaseFirestore.instance.collection("profile");
  final _auth = FirebaseAuth.instance;
  final maskFormatter = MaskTextInputFormatter(mask: '###-###-####');
  final maskFormatter1 = MaskTextInputFormatter(mask: '############-#');

  String? get uid => _uid;
  String? _uid;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: firebase,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
                appBar: AppBar(
                  title: Text("Error"),
                ),
                body: Center(
                  child: Text("${snapshot.error}"),
                ));
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return FutureBuilder(
                future: firebase,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Scaffold(
                        appBar: AppBar(
                          title: Text("Error"),
                        ),
                        body: Center(
                          child: Text("${snapshot.error}"),
                        ));
                  }
                  if (snapshot.connectionState == ConnectionState.done) {
                    final signUpButton = Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.blue,
                      child: MaterialButton(
                        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                        child: Text(
                          "ยืนยันการสมัครสมาชิก",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            formKey.currentState?.save();
                            try {
                              FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                      email: profile.email,
                                      password: profile.password)
                                  .then((value) async {
                                User? user = _auth.currentUser;
                                await value.user!
                                    .updateProfile(displayName: profile.email)
                                    .then((value2) async {
                                  String uid = value.user!.uid;
                                  Profile model = Profile(
                                    password: profile.password,
                                    name: profile.name,
                                    id: profile.id,
                                    phone: profile.phone,
                                    group: profile.group,
                                  );

                                  profile.email = user!.email;
                                  profile.uid = user.uid;

                                  Map<String, dynamic> data = model.toMap();
                                  await FirebaseFirestore.instance
                                      .collection('profile')
                                      .doc(user.uid)
                                      .set(profile.toMap());
                                  formKey.currentState?.reset();
                                  Fluttertoast.showToast(
                                      msg: "สมัครสมาชิกสำเร็จ",
                                      gravity: ToastGravity.CENTER);
                                  Navigator.pushReplacement(context,
                                      MaterialPageRoute(builder: (context) {
                                    return LoginScreen();
                                  }));
                                });
                              });
                            } on FirebaseAuthException catch (e) {
                              var message;
                              if (e.code == 'email-already-in-use') {
                                message =
                                    "มีอีเมลนี้ในระบบแล้วครับ โปรดใช้อีเมลอื่นแทน";
                              }
                              Fluttertoast.showToast(
                                  msg: message,
                                  gravity: ToastGravity.TOP_RIGHT);
                            }
                          }
                        },
                      ),
                    );
                    final email = TextFormField(
                        validator: MultiValidator([
                          RequiredValidator(errorText: "กรุณากรอกอีเมล"),
                          EmailValidator(errorText: "รูปแบบอีเมลไม่ถูกต้อง")
                        ]),
                        autocorrect: false,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        onSaved: (var email) {
                          profile.email = email;
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email),
                          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                          hintText: "email ",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ));

                    final password = TextFormField(
                        autocorrect: false,
                        obscureText: true,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          RegExp regex = new RegExp(r'^.{6,}$');
                          if (value!.isEmpty) {
                            return ("กรุณากรอกรหัสผ่าน");
                          }
                          if (!regex.hasMatch(value)) {
                            return ("รหัสผ่านต้องมีความยาว 6 ตัวอักษรขึ้นไป");
                          }
                        },
                        onSaved: (var password) {
                          profile.password = password;
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.key),
                          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                          hintText: "รหัสผ่าน",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ));

                    final firstNameFielf = TextFormField(
                        autocorrect: false,
                        keyboardType: TextInputType.text,
                        validator: RequiredValidator(
                            errorText: "กรุณากรอกชื่อนามสกุล"),
                        onSaved: (String? name) {
                          profile.name = name;
                        },
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                          hintText: "ชื่อ-นามสกุล",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ));

                    final idEditingFielf = TextFormField(
                        inputFormatters: [maskFormatter1],
                        autocorrect: false,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          RegExp regex = new RegExp(r'^.{14,}$');
                          if (value!.isEmpty) {
                            return ("กรุณากรอกรหัสประจำตัวนักศึกษา");
                          }
                          if (!regex.hasMatch(value)) {
                            return ("รหัสประจำตัวต้องมี 13 หลัก");
                          }
                        },
                        onSaved: (var id) {
                          profile.id = id;
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.drive_file_rename_outline),
                          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                          hintText: "รหัสประจำตัว",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ));

                    final subjectEditingFielf = TextFormField(
                        autocorrect: false,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        validator: RequiredValidator(errorText: "กรุณากรอกคณะ"),
                        onSaved: (var group) {
                          profile.group = group;
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.book),
                          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                          hintText: "คณะ",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ));

                    final phoneFielf = TextFormField(
                        inputFormatters: [maskFormatter],
                        autocorrect: false,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          RegExp regex = new RegExp(r'^.{12,}$');
                          if (value!.isEmpty) {
                            return ("กรุณากรอกเบอร์โทรศัพท์");
                          }
                          if (!regex.hasMatch(value)) {
                            return ("รูปแบบเบอร์โทรไม่ถูกต้อง");
                          }
                        },
                        onSaved: (var phone) {
                          profile.phone = phone;
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.phone),
                          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                          hintText: "เบอร์โทรศัพท์",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ));

                    return Scaffold(
                      appBar: AppBar(
                        title: Text(
                          "สมัครสมาชิก",
                          textScaleFactor: 1.5,
                          style: TextStyle(
                            fontSize: 23,
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                        centerTitle: false,
                        backgroundColor: Color.fromARGB(255, 68, 111, 253),
                        elevation: 0,
                        leading: IconButton(
                          icon: Icon(Icons.arrow_back, color: Colors.black),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      backgroundColor: Color.fromARGB(255, 237, 10, 10),
                      body: Center(
                        child: SingleChildScrollView(
                          child: Container(
                            color: Color.fromARGB(255, 253, 253, 253),
                            child: Padding(
                              padding: const EdgeInsets.all(36.0),
                              child: Form(
                                key: formKey,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    email,
                                    SizedBox(height: 20),
                                    password,
                                    SizedBox(height: 20),
                                    firstNameFielf,
                                    SizedBox(height: 20),
                                    idEditingFielf,
                                    SizedBox(height: 20),
                                    subjectEditingFielf,
                                    SizedBox(height: 20),
                                    phoneFielf,
                                    SizedBox(height: 20),
                                    signUpButton,
                                    SizedBox(height: 20),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  return Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                });
          }
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }
}
