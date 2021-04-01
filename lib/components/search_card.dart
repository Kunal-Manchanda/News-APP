import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app/screens/view_news_page.dart';

class SearchCard extends StatelessWidget {
  final imageUrl;
  final title;
  final time;
  final subtitle;
  final category;
  final link;

  const SearchCard(
      {Key key,
      this.imageUrl = 'https://ichef.bbci.co.uk/news/1024/cpsprodpb/151AB/production/_111434468_gettyimages-1143489763.jpg',
      this.title = 'meow',
      this.time = '19 nov',
      this.subtitle = 'haha',
      this.category = 'jaj',
      this.link = 'whwhwh'})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ViewNewsPage(
                  imageUrl: imageUrl,
                  title: title,
                  time: time,
                  subtitle: subtitle,
                  category: category,
                  link: link))),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 29),
        child: Container(
          height: 106,
          child: Row(
            children: [
              Container(
                height: 105,
                width: 155,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    image: DecorationImage(
                        image: NetworkImage(imageUrl), fit: BoxFit.fill)),
              ),
              SizedBox(width: 6),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.itim(
                        fontSize: 14,
                      ),
                      maxLines: 4,
                    ),
                    Text(
                      time,
                      style: GoogleFonts.montserrat(
                        fontSize: 13,
                        color: Color(0xff8a8989),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
