import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app/home.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("About",
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                    color: Colors.black, fontSize: size.width * 0.06)),
                    centerTitle: true,
        leading: GestureDetector(
            onTap: () => Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => Home())),
            child: Icon(Icons.arrow_back_ios, size: 30, color: Colors.black)),
        elevation: 0.0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: size.height * 0.04),
          Image.asset(
            'assets/images/logo.png',
            height: size.height * 0.2,
            width: size.width * 0.5,
          ),
          SizedBox(height: size.height * 0.02),
          Text(
            "News Point",
            style: GoogleFonts.merienda(
              fontSize: 30,
              color: Colors.black,
            ),
          ),
          SizedBox(height: size.height * 0.01),
          Text(
            "News at your fingertips",
            style: GoogleFonts.montserrat(
                fontSize: 20, color: Colors.black, fontWeight: FontWeight.w200),
          ),
          SizedBox(height: size.height * 0.05),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "News Point provides you with the latest news around the world. You can customize your feed based on the categories-Top Stories, India, World, Business, Sports, Tech, etc.",
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                  fontSize: 20, color: Colors.black, fontWeight: FontWeight.w300),
            ),
          ),
          SizedBox(height: size.height * 0.1),
          Text(
            "v1.0.0",
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.w600, color: Colors.black26),
          ),
        ],
      ),
    );
  }
}
