import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app/components/rounded_button.dart';
import 'package:news_app/constants.dart';
import 'package:news_app/screens/login_page.dart';
import 'package:news_app/screens/signup_page.dart';
import 'package:page_transition/page_transition.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Container(
          height: size.height,
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage('assets/images/newspaper.jpg'),
            colorFilter: ColorFilter.mode(kPrimaryDarkColor, BlendMode.overlay),
            fit: BoxFit.cover,
            alignment: Alignment.center,
          )),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 0.8, sigmaY: 0.8),
            child: Container(
              color: Colors.black.withOpacity(.4),
              child: Stack(children: [
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Image.asset('assets/images/logo.png', color: Colors.white70),
                          Text(
                            "News Point",
                            style: GoogleFonts.merienda(
                              fontSize: 30,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: size.height * 0.01),
                          Text(
                            "News at your fingertips",
                            style: GoogleFonts.montserrat(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w200),
                          ),
                        ],
                      ),
                      SizedBox(height: size.height * 0.15),
                      Column(
                        children: [
                          RoundedButton(
                            size: size,
                            content: "Login",
                            onPressed: () => Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.fade,
                                child: LoginPage(),
                              ),
                            ),
                          ),
                          RoundedButton(
                            size: size,
                            content: "Signup",
                            onPressed: () => Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.fade,
                                child: SignUpPage(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
