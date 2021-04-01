import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:news_app/backend/rss_to_json.dart';
import 'package:news_app/constants.dart';
import 'package:news_app/database/variables.dart';
import 'package:news_app/drawer.dart';
import 'package:news_app/screens/about_page.dart';
import 'package:news_app/screens/bookmarks_page.dart';
import 'package:news_app/screens/home_page.dart';
import 'package:news_app/screens/profile_page.dart';
import 'package:news_app/screens/search_page.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Stream myStream;
  int currentIndex = 0;

  getStream() async {
    var firebaseUser = await FirebaseAuth.instance.currentUser;
    setState(() {
      myStream = userCollection.doc(firebaseUser.email).snapshots();
    });
  }

  void changePage(index) {
    setState(() {
      currentIndex = index;
    });
    print("called");
  }

  Map<String, List> newsData = Map<String, List>();
  bool isLoading = true;

  getData() async {
    Future.wait([
      rssToJson('topnews'),
      rssToJson('india'),
      rssToJson('world'),
      rssToJson('business'),
      rssToJson('sports'),
      rssToJson('cricket'),
      rssToJson('tech-features'),
      rssToJson('education'),
      rssToJson('entertainment'),
      rssToJson('music'),
      rssToJson('lifestyle'),
      rssToJson('health-fitness'),
      rssToJson('fashion-trends'),
      rssToJson('art-culture'),
      rssToJson('travel'),
      rssToJson('books'),
      rssToJson('realestate'),
      rssToJson('its-viral'),
    ]).then((value) {
      newsData['topnews'] = value[0];
      newsData['india'] = value[1];
      newsData['world'] = value[2];
      newsData['business'] = value[3];
      newsData['sports'] = value[4];
      newsData['cricket'] = value[5];
      newsData['tech'] = value[6];
      newsData['education'] = value[7];
      newsData['entertainment'] = value[8];
      newsData['music'] = value[9];
      newsData['lifestyle'] = value[10];
      newsData['health-fitness'] = value[11];
      newsData['fashion-trends'] = value[12];
      newsData['art-culture'] = value[13];
      newsData['travel'] = value[14];
      newsData['books'] = value[15];
      newsData['realestate'] = value[16];
      newsData['its-viral'] = value[17];
      if (this.mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }


  @override
  void initState() {
    super.initState();
    getStream();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Builder(
              builder: (context) => IconButton(
                icon: SvgPicture.asset(
                  'assets/icons/menu.svg',
                  color: Colors.black,
                  width: 25,
                  height: 25,
                ),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            )),
        titleSpacing: 0,
      ),
      drawer: AppDrawer(callBack: (index) {
        changePage(index);
      },),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : [
              HomePage(newsData: newsData),
              SearchPage(newsData: newsData),
              BookmarksPage(),
              ProfilePage(),
            ][currentIndex],
      bottomNavigationBar: BubbleBottomBar(
        backgroundColor: Colors.white,
        opacity: .2,
        currentIndex: currentIndex,
        onTap: changePage,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        elevation: 8,
        hasNotch: true, //new
        hasInk: true, //new, gives a cute ink effect
        inkColor: Colors.black12, //optional, uses theme color if not specified
        items: <BubbleBottomBarItem>[
          BubbleBottomBarItem(
              backgroundColor: kPrimaryColor,
              icon: SvgPicture.asset(
                'assets/icons/home.svg',
                width: 21,
                color: Colors.black54,
                height: 21,
              ),
              activeIcon: SvgPicture.asset(
                'assets/icons/home.svg',
                width: 21,
                color: kPrimaryDarkColor,
                height: 21,
              ),
              title: Text("Home")),
          BubbleBottomBarItem(
              backgroundColor: kPrimaryColor,
              icon: SvgPicture.asset(
                'assets/icons/search.svg',
                width: 21,
                color: Colors.black54,
                height: 21,
              ),
              activeIcon: SvgPicture.asset(
                'assets/icons/search.svg',
                width: 21,
                color: kPrimaryDarkColor,
                height: 21,
              ),
              title: Text("Search")),
          BubbleBottomBarItem(
              backgroundColor: kPrimaryColor,
              icon: SvgPicture.asset(
                'assets/icons/bookmark.svg',
                width: 21,
                color: Colors.black54,
                height: 21,
              ),
              activeIcon: SvgPicture.asset(
                'assets/icons/bookmark.svg',
                width: 21,
                color: kPrimaryDarkColor,
                height: 21,
              ),
              title: Text("Bookmarks")),
          BubbleBottomBarItem(
              backgroundColor: kPrimaryColor,
              icon: StreamBuilder(
                  stream: myStream,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return CircularProgressIndicator();
                    }
                    return Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: NetworkImage(snapshot.data['profilePic'])),
                          boxShadow: [
                            BoxShadow(
                              color: kPrimaryDarkColor,
                              offset: Offset(0, 1),
                              blurRadius: 5,
                            )
                          ]),
                    );
                  }),
              title: Text("Profile")),
        ],
      ),
    );
  }
}
