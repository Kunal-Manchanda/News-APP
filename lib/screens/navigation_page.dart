import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:news_app/screens/welcome_page.dart';

import '../home.dart';

class NavigationPage extends StatefulWidget {
  @override
  _NavigationPageState createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  bool isSigned = false;
  @override
  void initState() {
    super.initState();
    auth.FirebaseAuth.instance.authStateChanges().listen((auth.User user) {
      if (user != null) {
        if (this.mounted) {
          setState(() {
            isSigned = true;
            print(user.uid);
          });
        }
      } else {
        if (this.mounted) {
          setState(() {
            isSigned = false;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print(isSigned);
    return Scaffold(
      body: isSigned ? Home() : WelcomePage(),
    );
  }
}
