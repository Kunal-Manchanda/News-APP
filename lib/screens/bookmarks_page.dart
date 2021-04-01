import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:news_app/components/search_card.dart';
import 'package:news_app/database/variables.dart';

class BookmarksPage extends StatefulWidget {
  @override
  _BookmarksPageState createState() => _BookmarksPageState();
}

class _BookmarksPageState extends State<BookmarksPage> {
  Stream newsBookmarksStream;

  getStream() async {
    var firebaseUser = await FirebaseAuth.instance.currentUser;
    setState(() {
      newsBookmarksStream = userCollection
          .doc(firebaseUser.email)
          .collection('bookmarks')
          .snapshots();
    });
  }

  @override
  void initState() {
    super.initState();
    getStream();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      color: Colors.white,
      child: StreamBuilder(
          stream: newsBookmarksStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            return snapshot.data.documents.length == 0
                ? Center(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            height: size.height * 0.4,
                            width: size.width * 0.8,
                            child: Lottie.asset('assets/animations/bookmark.json'),
                          ),
                          Text(
                            "No BookMarks",
                            style: GoogleFonts.nunito(
                              fontSize: 40,
                              color: Colors.black
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (BuildContext context, int index) {
                      DocumentSnapshot news = snapshot.data.documents[index];
                      return SearchCard(
                          title: news.data()['title'],
                          subtitle: news.data()['subtitle'],
                          imageUrl: news.data()['imageUrl'],
                          time: news.data()['time'],
                          link: news.data()['link']);
                    },
                  );
          }),
    );
  }
}
