import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app/components/input_field.dart';
import 'package:news_app/components/password_input_field.dart';
import 'package:news_app/loading.dart';
import 'package:news_app/screens/signup_page.dart';
import 'package:page_transition/page_transition.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  bool showSpinner = false;

  signIn() async {
    setState(() {
      showSpinner = true;
    });
    dynamic result = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim());

    print("result=$result");

    if (result != null) {
      Navigator.pop(context);
      setState(() {
        showSpinner = false;
      });
    } else {
      Fluttertoast.showToast(
        msg: "could not sign in with these credentials",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red.withOpacity(0.9),
        textColor: Colors.white,
        fontSize: 20,
      );
      setState(() {
        showSpinner = false;
      });
    }
  }

  // on FirebaseAuthException catch (e) {
  //   setState(() {
  //     showSpinner = false;
  //   });
  //   Fluttertoast.showToast(
  //     msg: e.toString(),
  //     toastLength: Toast.LENGTH_SHORT,
  //     gravity: ToastGravity.BOTTOM,
  //     timeInSecForIosWeb: 1,
  //     backgroundColor: Colors.red.withOpacity(0.9),
  //     textColor: Colors.white,
  //     fontSize: 20,
  //   );
  // SnackBar snackbar = SnackBar(content: Text(e.code.toString()));
  // scaffoldKey.currentState.showSnackBar(snackbar);
  // if (e.code == 'user-not-found') {
  //   SnackBar snackbar =
  //       SnackBar(content: Text('No user found for that email.'));
  //   scaffoldKey.currentState.showSnackBar(snackbar);
  // } else if (e.code == 'wrong-password') {
  //   SnackBar snackbar = SnackBar(content: Text('Incorrect password'));
  //   scaffoldKey.currentState.showSnackBar(snackbar);
  // } else if (e.code == 'invalid-email') {
  //   SnackBar snackbar = SnackBar(content: Text('Incorrect password'));
  //   scaffoldKey.currentState.showSnackBar(snackbar);
  // } else {
  //   SnackBar snackbar = SnackBar(content: Text(e.toString()));
  //   scaffoldKey.currentState.showSnackBar(snackbar);
  // }
  // }
  // }

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
                                SizedBox(height: size.height * 0.1),
                                Container(
                                  width: size.width * 0.1,
                                  height: 5,
                                  color: Colors.white,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "Login",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: size.height * 0.05),
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
                                    } else {
                                      signIn();
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
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    type: PageTransitionType.fade,
                                    child: SignUpPage(),
                                  ),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.all(20),
                                child: Text(
                                  "Don't have an account? Sign up",
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
