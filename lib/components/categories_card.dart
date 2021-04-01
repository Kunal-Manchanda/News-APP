import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoriesCard extends StatelessWidget {
  final imageUrl;
  final category;
  final Function onPressed;

  const CategoriesCard({Key key, this.imageUrl, this.category, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPressed(category);
      },
          child: Container(
        height: 114,
        width: 149,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          image: DecorationImage(
              image: AssetImage(imageUrl),
              colorFilter: ColorFilter.mode(Colors.black38, BlendMode.overlay),
              fit: BoxFit.cover,
              alignment: Alignment.center),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 0.8,
              sigmaY: 0.8
            ),
            child: Container(
              alignment: Alignment.center,
              color: Colors.black.withOpacity(.1),
              child: Padding(
                padding: EdgeInsets.all(8),
                child: FittedBox(
                  child: Text(
                    category,
                    style: GoogleFonts.montserrat(
                      fontSize: 23,
                      color: Colors.white,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
