import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app/screens/login_page.dart';
import 'package:news_app/screens/signup_page.dart';
import 'package:page_transition/page_transition.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    Key key,
    @required this.size,
    this.content,
    this.onPressed,
  }) : super(key: key);

  final Size size;
  final String content;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Material(
        shadowColor: Colors.grey[600],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        elevation: 18.0,
        color: Colors.white60,
        child: MaterialButton(
          onPressed: onPressed,
          height: size.height * 0.06,
          minWidth: size.width * 0.5,
          child: Text(
            content,
            style: GoogleFonts.montserrat(
              fontSize: 20,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
