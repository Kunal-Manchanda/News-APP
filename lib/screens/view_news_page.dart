import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:news_app/database/variables.dart';
import 'package:share/share.dart';

class ViewNewsPage extends StatefulWidget {
  final imageUrl;
  final title;
  final time;
  final subtitle;
  final category;
  final link;

  const ViewNewsPage(
      {Key key,
      this.imageUrl,
      this.title,
      this.time,
      this.subtitle,
      this.category,
      this.link})
      : super(key: key);

  @override
  _ViewNewsPageState createState() => _ViewNewsPageState();
}

class _ViewNewsPageState extends State<ViewNewsPage> {
  String data;
  bool isLoading = true;
  var isBookmarked = false;
  List<Map<String, String>> bookmarkedNewsList = [];

  _onPressed() {
    setState(() {
      isBookmarked = !isBookmarked;
    });
    storeBookmarkedNews();
  }

  storeBookmarkedNews() async {
    try {
      var firebaseUser = await FirebaseAuth.instance.currentUser;
      if (isBookmarked) {
        final id = userCollection
            .doc(firebaseUser.email)
            .collection('bookmarks')
            .doc()
            .id;
        await userCollection
            .doc(firebaseUser.email)
            .collection('bookmarks')
            .doc(id)
            .set({
          'id': id,
          'title': widget.title,
          'subtitle': widget.subtitle,
          'imageUrl': widget.imageUrl,
          'time': widget.time,
          'category': widget.category,
          'link': widget.link
        });
      } else {
        var id;
        bookmarkedNewsList.forEach((news) {
          if (news.containsValue(widget.title)) {
            id = news['id'];
          }
        });
        await userCollection
            .doc(firebaseUser.email)
            .collection('bookmarks')
            .doc(id)
            .delete();
      }
      checkBookmarkedNews();
    } catch (e) {
      print(e);
    }
  }

  checkBookmarkedNews() async {
    var firebaseUser = await FirebaseAuth.instance.currentUser;
    bookmarkedNewsList.clear();

    final QuerySnapshot result = await userCollection
        .doc(firebaseUser.email)
        .collection('bookmarks')
        .get();

    if (result.docs.length != 0) {
      final List<DocumentSnapshot> documents = result.docs;
      if (this.mounted) {
        setState(() {
          for (var document in documents) {
            // bookmarkedNewsList.add(document.data()['title']);
            bookmarkedNewsList.add({
              'id': document.reference.id,
              'title': document.data()['title']
            });
          }
        });
      }
    }

    bookmarkedNewsList.forEach((news) {
      if (news.containsValue(widget.title)) {
        if (this.mounted) {
          setState(() {
            isBookmarked = true;
          });
        } else {
          if (this.mounted) {
            setState(() {
              isBookmarked = false;
            });
          }
        }
      }
    });
  }

  void getData() async {
    setState(() {
      isLoading = true;
    });

    data = "";

    final response = await http.Client().get(Uri.parse(widget.link));

    if (response.statusCode == 200) {
      var document = parse(response.body);
      var length = document
          .getElementsByClassName("storyDetail")[0]
          .getElementsByTagName("p")
          .length;

      setState(() {
        for (var i = 0; i < length; i++) {
          data = data +
              document
                  .getElementsByClassName("storyDetail")[0]
                  .children[i]
                  .text +
              "\n \n";
        }

        data.trimLeft();
      });
    } else {
      throw Exception();
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
    checkBookmarkedNews();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Material(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: size.height * 0.4,
                width: size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(widget.imageUrl),
                    fit: BoxFit.cover,
                    // colorFilter:
                    //     ColorFilter.mode(Colors.grey[50], BlendMode.overlay),
                  ),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 0.8, sigmaY: 0.8),
                  child: Container(
                    decoration:
                        new BoxDecoration(color: Colors.white.withOpacity(0.1)),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              margin: EdgeInsets.only(top: 50, left: 30),
                              height: size.height * 0.05,
                              width: size.width * 0.1,
                              decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Align(
                        //   alignment: Alignment.bottomCenter,
                        //   child: Container(
                        //     margin: EdgeInsets.only(bottom: size.height * 0.07),
                        //     child: Text(
                        //       widget.title,
                        //       textAlign: TextAlign.center,
                        //       style: GoogleFonts.montserrat(
                        //         color: Colors.white,
                        //         fontSize: size.height * 0.027,
                        //         fontWeight: FontWeight.w800,
                        //         wordSpacing: 2.0,
                        //       ),
                        //     ),
                        //   ),
                        // )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: size.height * 0.65,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    )),
                child: SingleChildScrollView(
                    child: Padding(
                  padding:
                      EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 10),
                  child: Column(
                    children: [
                      Text(
                        widget.title,
                        textAlign: TextAlign.start,
                        style: GoogleFonts.nunito(
                          color: Colors.black,
                          fontSize: size.height * 0.027,
                          fontWeight: FontWeight.w600,
                          wordSpacing: 2.0,
                        ),
                      ),
                      SizedBox(height: size.height * 0.03),
                      Text(
                        data.toString().trimLeft(),
                        textAlign: TextAlign.start,
                        style: GoogleFonts.montserrat(
                          color: Colors.black54,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                )),
              ),
            ),
            Positioned(
              top: size.height - size.height * 0.68,
              width: size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () => _onPressed(),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(0, 4),
                                blurRadius: 10,
                                color: Colors.black12,
                                spreadRadius: 5)
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 32,
                          backgroundColor: Colors.white,
                          child: isBookmarked
                              ? Icon(
                                  Icons.bookmark,
                                  color: Colors.yellow,
                                  size: 30,
                                )
                              : Icon(
                                  Icons.bookmark_border,
                                  color: Colors.black,
                                  size: 30,
                                ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: ()  {
                       Share.share("Hi, checkout this news ${widget.link}");
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(0, 4),
                                blurRadius: 10,
                                color: Colors.black12,
                                spreadRadius: 5)
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 32,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.share_outlined,
                            color: Colors.black,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
