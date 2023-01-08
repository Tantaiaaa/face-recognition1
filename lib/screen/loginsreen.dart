import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/screen/home_sreen.dart';
import 'package:flutter_application_1/screen/profile.dart';
import 'package:flutter_application_1/screen/register_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // form key
  final formKey = GlobalKey<FormState>();
  // editing controller
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  Profile profile = Profile();
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
            //email field
            final emailField = TextFormField(
                autofocus: false,
                keyboardType: TextInputType.emailAddress,
                validator: MultiValidator([
                  RequiredValidator(errorText: "กรุณากรอกอีเมล"),
                  EmailValidator(errorText: "รูปแบบอีเมลไม่ถูกต้อง")
                ]),
                onSaved: (var email) {
                  profile.email = email;
                },
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                  labelText: "ชื่อผู้ใช้งาน",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ));

            //password field
            final passwordField = TextFormField(
                autofocus: false,
                obscureText: true,
                validator: MultiValidator(
                    [RequiredValidator(errorText: "กรุณากรอกรหัสผ่าน")]),
                onSaved: (var password) {
                  profile.password = password;
                },
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.vpn_key),
                  contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                  labelText: "รหัสผ่าน",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ));
            final loginButton = Material(
              elevation: 5,
              borderRadius: BorderRadius.circular(50),
              color: Colors.redAccent,
              child: MaterialButton(
                  padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                  minWidth: MediaQuery.of(context).size.width,
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      try {
                        await FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                                email: profile.email,
                                password: profile.password)
                            .then((value) {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return MakeDashboardItems();
                          }));
                        });
                      } on FirebaseAuthException catch (e) {
                        Fluttertoast.showToast(
                            msg: "ไม่พบบํญชีนี้", gravity: ToastGravity.CENTER);
                        formKey.currentState!.reset();
                      }
                    }
                  },
                  child: Text(
                    "เข้าสู่ระบบ",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  )),
            );
            return Scaffold(
              backgroundColor: Color.fromARGB(206, 255, 0, 0),
              body: Center(
                child: SingleChildScrollView(
                  child: Container(
                    color: Color.fromARGB(206, 255, 254, 254),
                    child: Padding(
                      padding: const EdgeInsets.all(36.0),
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              height: 90,
                              padding: EdgeInsets.all(1),
                              child: Column(
                                children: [
                                  Text("สแกนใบหน้าเช็คชื่อเข้าเรียน",
                                      style: TextStyle(
                                        fontSize: 24,
                                        color: Colors.black,
                                      )),
                                ],
                              ),
                            ),
                            SizedBox(
                                height: 200,
                                child: Image.asset(
                                  "assets/1234.png",
                                  fit: BoxFit.contain,
                                )),
                            SizedBox(height: 45),
                            emailField,
                            SizedBox(height: 25),
                            passwordField,
                            SizedBox(height: 35),
                            loginButton,
                            SizedBox(height: 15),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text("คุณมีสมาชิกหรือไม่? "),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  RegisterScreen()));
                                    },
                                    child: Text(
                                      "สมัครสมาชิก",
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                  )
                                ])
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
              // ignore: prefer_const_constructors
              body: Center(
            child: CircularProgressIndicator(),
          ));
        });
  }
}
