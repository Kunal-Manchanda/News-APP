import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app/components/home_page_card.dart';
import 'package:news_app/model/category_model.dart';
import 'package:news_app/utils.dart';

class HomePage extends StatefulWidget {
  final Map<String, List> newsData;

  const HomePage({Key key, this.newsData}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  ScrollController _scrollController;
  TabController _tabController;
  int currentIndex = 0;

  _smoothScrollToTop() {
    _scrollController.animateTo(0,
        duration: Duration(microseconds: 300), curve: Curves.ease);
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _tabController = TabController(length: categories.length, vsync: this);
    _tabController.addListener(_smoothScrollToTop);
  }

  void changePage(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      controller: _scrollController,
      headerSliverBuilder: (context, value) {
        return [
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.fromLTRB(25, 10, 25, 25),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Top News Updates",
                    style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w400)),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
                color: Colors.white,
                padding: EdgeInsets.only(left: 25),
                alignment: Alignment.centerLeft,
                child: TabBar(
                  labelPadding: EdgeInsets.only(right: 15),
                  indicatorSize: TabBarIndicatorSize.label,
                  controller: _tabController,
                  isScrollable: true,
                  indicator: UnderlineTabIndicator(),
                  labelColor: Colors.black,
                  labelStyle: GoogleFonts.montserrat(
                      textStyle:
                          TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
                  unselectedLabelColor: Colors.black45,
                  unselectedLabelStyle: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.normal)),
                  tabs: List.generate(categories.length,
                      (index) => Text(categories[index].name)),
                )),
          )
        ];
      },
      body: Container(
        color: Colors.white,
        child: TabBarView(
          controller: _tabController,
          children: List.generate(categories.length, (index) {
            var key = categories[index]
                .imageUrl
                .toString()
                .split('/')[3]
                .split('.')[0]
                .replaceAll('_', '-');
            return ListView.builder(
              itemCount: widget.newsData[key].length,
              itemBuilder: (context, i) {
                String time = widget.newsData[key][i]['pubDate']
                    ['__cdata']; // example: Wed, 12 Aug 2020 02:25:42 GMT
                DateTime timeIst = DateTime.parse(time.split(' ')[3] +
                    "-" +
                    getMonthNumberFromName(month: time.split(' ')[2]) +
                    "-" +
                    time.split(' ')[1] +
                    " " +
                    time.split(' ')[4]);
                timeIst = timeIst
                    .add(Duration(hours: 5))
                    .add(Duration(minutes: 30)); // converted GMT to IST

                print("Category=${categories[index].name.toString()}");
                var link = widget.newsData[key][i]['link']['__cdata'];
                return HomePageCard(
                  category: categories[index].name.toString(),
                  title: widget.newsData[key][i]['title']['__cdata'],
                  subtitle: widget.newsData[key][i]['description']['__cdata'],
                  imageUrl: widget.newsData[key][i][r'media$content']['url'],
                  time: timeIst.day.toString() +
                      " " +
                      getMonthNumberInWords(month: timeIst.month) +
                      " " +
                      timeIst
                          .toString()
                          .split(" ")[1]
                          .substring(0, 5), // example 12 Aug 07:55
                  link: link,
                );
              },
              padding: EdgeInsets.symmetric(horizontal: 25),
            );
          }),
        ),
      ),
    );
  }
}
