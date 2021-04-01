import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app/components/categories_card.dart';
import 'package:news_app/components/search_card.dart';
import 'package:news_app/model/category_model.dart';
import 'package:news_app/utils.dart';

class SearchPage extends StatefulWidget {
  final Map<String, List> newsData;

  const SearchPage({Key key, this.newsData}) : super(key: key);
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();
  FocusNode searchNode = FocusNode();
  bool isCategory = false;
  var categorySelected;
  var categoryKey;
  var searchedValue;
  List<Map<String, String>> searchedNewsList = [];

  searchNews(String value) {
    searchedNewsList.clear();
    for (var j = 0; j < categories.length; j++) {
      var key = categories[j]
          .imageUrl
          .toString()
          .split('/')[3]
          .split('.')[0]
          .replaceAll('_', '-');
      for (var k = 0; k < widget.newsData[key].length; k++) {
        var title = widget.newsData[key][k]['title']['__cdata'].toString();
        if (title.toLowerCase().contains(value.toLowerCase())) {
          bool alreadyAdded = false;
          for (var l = 0; l < searchedNewsList.length; l++) {
            if (searchedNewsList[l]['title'].contains(title)) {
              alreadyAdded = true;
            }
          }
          if (!alreadyAdded) {
            String time = widget.newsData[key][k]['pubDate']
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

            searchedNewsList.add({
              'title': title,
              'subtitle': widget.newsData[key][k]['description']['__cdata'],
              'imageUrl': widget.newsData[key][k][r'media$content']['url'],
              'time': timeIst.day.toString() +
                  " " +
                  getMonthNumberInWords(month: timeIst.month) +
                  " " +
                  timeIst.toString().split(" ")[1].substring(0, 5),
              'link': widget.newsData[key][k]['link']['__cdata']
            });
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      children: [
        Container(
          height: 46,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(horizontal: 25),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(.16),
                    offset: Offset(0, 3),
                    blurRadius: 6)
              ]),
          child: Row(
            children: [
              Expanded(
                child: Center(
                  child: TextFormField(
                    onChanged: (value) {
                      setState(() {
                        searchedValue = value;
                      });
                      print("SearchedValue=$searchedValue");
                      searchNews(searchedValue);
                    },
                    controller: _searchController,
                    focusNode: searchNode,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.transparent,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                          color: Colors.transparent,
                        )),
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                        hintText: "Search",
                        hintStyle: GoogleFonts.montserrat(
                          fontSize: 18,
                          color: Colors.black45,
                        ),
                        suffixIconConstraints: BoxConstraints(
                          minWidth: 19,
                          minHeight: 19,
                        )),
                  ),
                ),
              ),
              _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: SvgPicture.asset(
                        'assets/icons/search_cancel.svg',
                        color: Colors.black45,
                      ),
                      onPressed: () {
                        setState(() {
                          _searchController.clear();
                          isCategory = false;
                        });
                      },
                    )
                  : Icon(
                      Icons.search,
                      color: Colors.black45,
                      size: 30,
                    )
            ],
          ),
        ),
        SizedBox(height: 17),
        if (_searchController.text.isEmpty) ...[
          if (isCategory == false) ...[
            Text(
              "Top Categories",
              style: GoogleFonts.montserrat(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 10),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              childAspectRatio: 149 / 114,
              physics: NeverScrollableScrollPhysics(),
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              children: List.generate(4, (index) {
                return CategoriesCard(
                  category: categories[index].name,
                  imageUrl: categories[index].imageUrl,
                  onPressed: (value) {
                    setState(() {
                      categorySelected = value;
                      isCategory = true;
                      categoryKey = categories[index]
                          .imageUrl
                          .toString()
                          .split('/')[3]
                          .split('.')[0]
                          .replaceAll('_', '-');
                    });
                    print("Category key=$categoryKey");
                  },
                );
              }),
            ),
            SizedBox(height: 40),
            Text(
              "Browse All",
              style: GoogleFonts.montserrat(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              childAspectRatio: 149 / 114,
              physics: NeverScrollableScrollPhysics(),
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              children: List.generate(categories.length - 4, (index) {
                return CategoriesCard(
                  category: categories[index + 4].name,
                  imageUrl: categories[index + 4].imageUrl,
                  onPressed: (value) {
                    setState(() {
                      categorySelected = value;
                      isCategory = true;
                      categoryKey = categories[index + 4]
                          .imageUrl
                          .toString()
                          .split('/')[3]
                          .split('.')[0]
                          .replaceAll('_', '-');
                    });
                    print("Category key=$categoryKey");
                  },
                );
              }),
            ),
          ] else ...[
            Expanded(
              child: Column(
                children:
                    List.generate(widget.newsData[categoryKey].length, (index) {
                  String time = widget.newsData[categoryKey][index]['pubDate']
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
                  var link =
                      widget.newsData[categoryKey][index]['link']['__cdata'];
                  return SearchCard(
                    category: categorySelected,
                    title: widget.newsData[categoryKey][index]['title']
                        ['__cdata'],
                    subtitle: widget.newsData[categoryKey][index]['description']
                        ['__cdata'],
                    imageUrl: widget.newsData[categoryKey][index]
                        [r'media$content']['url'],
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
                }),
              ),
            )
          ]
        ] else ...[
          if (searchedNewsList.length != 0) ...[
            RichText(
              text: TextSpan(children: [
                TextSpan(
                    text: "Search Result for ",
                    style: GoogleFonts.montserrat(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.black.withOpacity(.55),
                    )),
                TextSpan(
                    text: _searchController.text,
                    style: GoogleFonts.montserrat(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff1fa2f9),
                    ))
              ]),
            ),
            SizedBox(height: 17),
            Column(
              children: List.generate(searchedNewsList.length, (index) {
                return SearchCard(
                  title: searchedNewsList[index]['title'],
                  subtitle: searchedNewsList[index]['subtitle'],
                  imageUrl: searchedNewsList[index]['imageUrl'],
                  time: searchedNewsList[index]['time'],
                  link: searchedNewsList[index]['link'],
                );
              }),
            )
          ] else ...[
            RichText(
              text: TextSpan(children: [
                TextSpan(
                    text: "No Result Found for ",
                    style: GoogleFonts.montserrat(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.black.withOpacity(.55),
                    )),
                TextSpan(
                    text: _searchController.text,
                    style: GoogleFonts.montserrat(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff1fa2f9),
                    ))
              ]),
            ),
            SizedBox(height: 120),
            SvgPicture.asset('assets/icons/search.svg',
                color: Color(0xff737373).withOpacity(.6),
                height: 159,
                width: 159),
            SizedBox(height: 59),
            Text(
              "No Result Found",
              style: GoogleFonts.montserrat(
                fontSize: 16,
                color: Color(0xffbebebe),
              ),
              textAlign: TextAlign.center,
            )
          ]
        ]
      ],
    );
  }
}
