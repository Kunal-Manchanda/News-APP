import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app/components/input_field.dart';
import 'package:news_app/components/password_input_field.dart';
import 'package:news_app/database/variables.dart';
import 'package:news_app/loading.dart';
import 'package:news_app/screens/complete_profile_page.dart';
import 'package:news_app/screens/login_page.dart';
import 'package:page_transition/page_transition.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  bool showSpinner = false;

  registerUser() async {
    setState(() {
      showSpinner = true;
    });
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text, password: passwordController.text)
          .then((signedUser) {
        userCollection.doc(emailController.text).set({
          'name': nameController.text,
          'email': emailController.text,
          'password': passwordController.text,
          'profilePic': exampleImage
        });
      });
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CompleteProfile(
                    name: nameController.text.toString(),
                    email: emailController.text.toString(),
                  )));
      setState(() {
        showSpinner = false;
      });
    } catch (e) {
      if (e.code == 'weak-password') {
        SnackBar snackbar =
            SnackBar(content: Text("The password provided is too weak."));
        scaffoldKey.currentState.showSnackBar(snackbar);
        setState(() {
          showSpinner = false;
        });
      } else if (e.code == 'email-already-in-use') {
        SnackBar snackbar = SnackBar(
            content: Text("The account already exists for this username."));
        scaffoldKey.currentState.showSnackBar(snackbar);
        setState(() {
          showSpinner = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return showSpinner
        ? Loading()
        : Scaffold(
            key: scaffoldKey,
            resizeToAvoidBottomInset: false,
            body: GestureDetector(
              onTap: () {
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
              },
              child: SingleChildScrollView(
                child: Container(
                  height: size.height,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: AssetImage('assets/images/newspaper.jpg'),
                    colorFilter:
                        ColorFilter.mode(Colors.blue[800], BlendMode.overlay),
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                  )),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 0.8, sigmaY: 0.8),
                    child: Container(
                      color: Colors.black.withOpacity(.4),
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(height: size.height * 0.05),
                                Image.asset('assets/images/logo.png',
                                    color: Colors.white70),
                                Text(
                                  "News Point",
                                  style: GoogleFonts.merienda(
                                    fontSize: 30,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  "News at your fingertips",
                                  style: GoogleFonts.montserrat(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w200),
                                ),
                                SizedBox(height: size.height * 0.05),
                                Container(
                                  width: size.width * 0.1,
                                  height: 5,
                                  color: Colors.white,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "SignUp",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: size.height * 0.02),
                                InputField(
                                  enabled: true,
                                  controller: nameController,
                                  labelText: "Name",
                                  inputType: TextInputType.text,
                                  onChanged: (value) {},
                                ),
                                SizedBox(height: size.height * 0.03),
                                InputField(
                                  enabled: true,
                                  controller: emailController,
                                  labelText: "Email",
                                  inputType: TextInputType.emailAddress,
                                  onChanged: (value) {},
                                ),
                                SizedBox(height: size.height * 0.03),
                                PasswordInputField(
                                  labelText: "Password",
                                  controller: passwordController,
                                  onChanged: (value) {},
                                ),
                                SizedBox(height: size.height * 0.03),
                                InkWell(
                                  onTap: () {
                                    if (emailController.text.isEmpty) {
                                      SnackBar snackbar = SnackBar(
                                          content:
                                              Text("The email cannot be null"));
                                      scaffoldKey.currentState
                                          .showSnackBar(snackbar);
                                    } else if (passwordController
                                        .text.isEmpty) {
                                      SnackBar snackbar = SnackBar(
                                          content: Text(
                                              "The password cannot be null"));
                                      scaffoldKey.currentState
                                          .showSnackBar(snackbar);
                                    } else if (!RegExp(
                                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(emailController.text)) {
                                      SnackBar snackbar = SnackBar(
                                          content:
                                              Text("Invalid email format"));
                                      scaffoldKey.currentState
                                          .showSnackBar(snackbar);
                                    } else if (passwordController.text.length <
                                        6) {
                                      SnackBar snackbar = SnackBar(
                                          content: Text(
                                              "The password should atleast be of 6 characters"));
                                      scaffoldKey.currentState
                                          .showSnackBar(snackbar);
                                    } else {
                                      registerUser();
                                    }
                                  },
                                  child: CircleAvatar(
                                    radius: 30,
                                    backgroundColor: Colors.white,
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.blue[800],
                                      size: 20,
                                    ),
                                  ),
                                ),
                                SizedBox(height: size.height * 0.15),
                              ],
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: InkWell(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  PageTransition(
                                    type: PageTransitionType.fade,
                                    child: LoginPage(),
                                  ),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.all(20),
                                child: Text(
                                  "Already have an account ?",
                                  style: GoogleFonts.montserrat(
                                      fontSize: 15, color: Colors.white),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
