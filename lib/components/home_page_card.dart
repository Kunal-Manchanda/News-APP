import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app/screens/view_news_page.dart';

class HomePageCard extends StatelessWidget {
  final imageUrl;
  final title;
  final time;
  final subtitle;
  final category;
  final link;

  const HomePageCard(
      {Key key,
      this.imageUrl = 'assets/images/cardImage.jpg',
      this.title =
          "Watch: Gameplay for the first 13 games optimised for Xbox Series X",
      this.time = "07 May 07:19",
      this.subtitle =
          "Microsoft showcased 13 games, with their gameplay trailers, that will come to Xbox Series X with optimisations",
      this.category,
      this.link})
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
                    link: link
                  ))),
      child: Padding(
        padding: EdgeInsets.only(top: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 203,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Color(0xff707070),
                    width: 1,
                  ),
                  image: DecorationImage(
                      image: NetworkImage(imageUrl), fit: BoxFit.fill),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black26,
                        offset: Offset(5, 6),
                        blurRadius: 5,
                        spreadRadius: 5)
                  ]),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(11),
                        color: Colors.black.withOpacity(0.33),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Center(
                        child: Text(
                          subtitle,
                          style: GoogleFonts.montserrat(
                              fontSize: 16, color: Colors.white),
                          maxLines: 3,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              time,
              style: GoogleFonts.montserrat(
                  fontSize: 13, color: Color(0xff8a8989)),
            ),
            SizedBox(height: 7),
            Text(
              title,
              style:
                  GoogleFonts.itim(fontSize: 23, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
