import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_app/constants.dart';
import 'package:news_app/screens/about_page.dart';
import 'database/variables.dart';

class AppDrawer extends StatefulWidget {
  final Function callBack;

  const AppDrawer({Key key, this.callBack}) : super(key: key);
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  Stream myStream;

  getStream() async {
    var firebaseUser = await FirebaseAuth.instance.currentUser;
    setState(() {
      myStream = userCollection.doc(firebaseUser.email).snapshots();
    });
  }

  signOut() {
    print("signOut");
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("Do you really want to logout",
                    style: TextStyle(fontSize: 20, color: Colors.blue[800])),
                SizedBox(height: 10),
                Container(
                  color: Colors.blueGrey[100],
                  height: 2.0,
                  width: double.infinity,
                ),
              ],
            ),
            actions: [
              FlatButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pop(context);
                },
                child: Text(
                  "Yes",
                  style: TextStyle(fontSize: 20, color: Colors.red[300]),
                ),
              ),
              FlatButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "No",
                  style: TextStyle(fontSize: 20, color: Colors.lightBlue[300]),
                ),
              ),
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    getStream();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: StreamBuilder(
          stream: myStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }
            return Container(
              color: kPrimaryLightColor,
              child: Column(
                children: [
                  SizedBox(height: 30),
                  DrawerHeader(
                    child: Container(
                      height: MediaQuery.of(context).size.width * 0.35,
                      width: MediaQuery.of(context).size.width * 0.35,
                      child: ClipOval(
                        child: Image.network(
                          snapshot.data['profilePic'],
                          height: MediaQuery.of(context).size.width * 0.35,
                          width: MediaQuery.of(context).size.width * 0.35,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      widget.callBack(0);
                    },
                    child: Text(
                      'Home',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: kPrimaryColor),
                    ),
                  ),
                  SizedBox(height: 45),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      widget.callBack(3);
                    },
                    child: Text(
                      'Profile',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: kPrimaryColor),
                    ),
                  ),
                  SizedBox(height: 45),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => AboutPage()));
                    },
                    child: Text(
                      'About',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: kPrimaryColor),
                    ),
                  ),
                  SizedBox(height: 45),
                  GestureDetector(
                    onTap: () => signOut(),
                    child: Text(
                      'Logout',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: kPrimaryColor),
                    ),
                  ),
                  SizedBox(height: 45),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: kPrimaryDarkColor,
                      child: Icon(Icons.arrow_back, color: Colors.white),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 65,
                        width: MediaQuery.of(context).size.width,
                        color: kPrimaryDarkColor,
                        child: Center(
                          child: Text(
                            "v1.0.0",
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          }),
    );
  }
}
