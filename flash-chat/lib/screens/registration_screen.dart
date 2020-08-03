import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../components/roundedButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = 'registration_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {

  final _auth = FirebaseAuth.instance;

  String email;
  String password;
  String fName;
  String lName;

  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
                SizedBox(
                  height: 48.0,
                ),
                TextField(
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    fName = value;
                  },
                  decoration:
                  kTextFieldDecoration.copyWith(hintText: 'First Name'),
                ),
                SizedBox(
                  height: 8.0,
                ),
                TextField(
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    lName = value;
                  },
                  decoration:
                  kTextFieldDecoration.copyWith(hintText: 'Last Name'),
                ),
                SizedBox(
                  height: 8.0,
                ),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    email = value;
                  },
                  decoration:
                      kTextFieldDecoration.copyWith(hintText: 'Email'),
                ),
                SizedBox(
                  height: 8.0,
                ),
                TextField(
                  obscureText: true,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Password'),
                ),
                SizedBox(
                  height: 24.0,
                ),
                RoundedButton(
                  title: 'Register',
                  colour: Colors.blueAccent,
                  onPressed: () async {
                    setState(() {
                      showSpinner = true;
                    });
                    try {
                      final newUser = await _auth.createUserWithEmailAndPassword(
                          email: email, password: password);
                      FirebaseUser user = await FirebaseAuth.instance.currentUser();
                      UserUpdateInfo userUpdateInfo = new UserUpdateInfo();
                      userUpdateInfo.displayName = fName;
                      user.updateProfile(userUpdateInfo);
                      if (newUser != null) {
                        Navigator.pushNamed(context, LoginScreen.id);
                      }
                      setState(() {
                        showSpinner = false;
                      });
                    }
                    catch (error) {
                      print(error);
                    }
                  },
                ),
                Center(
                  child: Text(
                    'Already Registered ?',
                    style: TextStyle(
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                RoundedButton(
                  title: 'Log In',
                  colour: Colors.lightBlueAccent,
                  onPressed: () {
                    Navigator.pushNamed(context, LoginScreen.id);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
