import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:news_app/components/input_field.dart';
import 'package:flutter/services.dart';
import 'package:news_app/database/variables.dart';
import 'package:news_app/loading.dart';
import 'package:news_app/screens/navigation_page.dart';

class CompleteProfile extends StatefulWidget {
  final name, email;

  const CompleteProfile({Key key, this.name, this.email}) : super(key: key);

  @override
  _CompleteProfileState createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile> {
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  Position _currentPosition;
  String _currentAddress;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var locationController = TextEditingController();
  var professionController = TextEditingController();
  var nameController = TextEditingController();
  var mobileController = TextEditingController();
  var emailController = TextEditingController();
  bool showSpinner = false;

  proceed() async {
    setState(() {
      showSpinner = true;
    });
    try {
      var firebaseUser = FirebaseAuth.instance.currentUser;
      await userCollection.doc(firebaseUser.email).update({
        'location': _currentAddress,
        'profession': professionController.text.toString(),
        'mobile': mobileController.text.toString()
      });
      Navigator.pop(context);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => NavigationPage()));
      setState(() {
        showSpinner = false;
      });
    } catch (e) {
      if (e.code == 'weak-password') {
        SnackBar snackbar =
            SnackBar(content: Text("The password provided is too weak."));
        scaffoldKey.currentState.showSnackBar(snackbar);
        setState(() {
          showSpinner = false;
        });
      } else if (e.code == 'email-already-in-use') {
        SnackBar snackbar = SnackBar(
            content: Text("The account already exists for this username."));
        scaffoldKey.currentState.showSnackBar(snackbar);
        setState(() {
          showSpinner = false;
        });
      }
    }
  }

  _getCurrentLocation() {
    setState(() {
      showSpinner = true;
    });
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });

      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
    setState(() {
      showSpinner = false;
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress = "${place.locality}, ${place.country}";
      });
    } catch (e) {
      print(e);
    }

    print("location=$_currentAddress");
    locationController.text = _currentAddress.toString();
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return showSpinner
        ? Loading()
        : Scaffold(
                key: scaffoldKey,
                resizeToAvoidBottomInset: false,
                body: GestureDetector(
                  onTap: () {
                    FocusScopeNode currentFocus = FocusScope.of(context);
                    if (!currentFocus.hasPrimaryFocus) {
                      currentFocus.unfocus();
                    }
                  },
                  child: SingleChildScrollView(
                    child: Container(
                      height: size.height,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        image: AssetImage('assets/images/newspaper.jpg'),
                        colorFilter: ColorFilter.mode(
                            Colors.blue[800], BlendMode.overlay),
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                      )),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 0.8, sigmaY: 0.8),
                        child: Container(
                          color: Colors.black.withOpacity(.4),
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SizedBox(height: size.height * 0.1),
                                    Container(
                                      width: size.width * 0.1,
                                      height: 5,
                                      color: Colors.white,
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      "Help us to complete your profile",
                                      style: GoogleFonts.montserrat(
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: size.height * 0.15),
                                    InputField(
                                      enabled: true,
                                      controller: nameController
                                        ..text = widget.name.toString(),
                                      labelText: "Name",
                                      inputType: TextInputType.text,
                                      onChanged: (value) {},
                                    ),
                                    SizedBox(height: size.height * 0.03),
                                    InputField(
                                      enabled: true,
                                      controller: emailController
                                        ..text = widget.email.toString(),
                                      labelText: "Email",
                                      inputType: TextInputType.phone,
                                      onChanged: (value) {},
                                    ),
                                    InputField(
                                      enabled: true,
                                      controller: mobileController,
                                      labelText: "Mobile Number",
                                      inputType: TextInputType.phone,
                                      onChanged: (value) {},
                                    ),
                                    InputField(
                                      enabled: true,
                                      controller: locationController,
                                      labelText: "Location",
                                      inputType: TextInputType.text,
                                      onChanged: (value) {},
                                    ),
                                    InputField(
                                      enabled: true,
                                      controller: professionController,
                                      labelText: "Profession",
                                      inputType: TextInputType.text,
                                      onChanged: (value) {},
                                    ),
                                    SizedBox(height: size.height * 0.03),
                                    InkWell(
                                      onTap: () {
                                        if (nameController.text.isEmpty) {
                                          SnackBar snackbar = SnackBar(
                                              content:
                                                  Text("Name cannot be null"));
                                          scaffoldKey.currentState
                                              .showSnackBar(snackbar);
                                        } else if (mobileController
                                            .text.isEmpty) {
                                          SnackBar snackbar = SnackBar(
                                              content: Text(
                                                  "Mobile Number cannot be null"));
                                          scaffoldKey.currentState
                                              .showSnackBar(snackbar);
                                        } else if (mobileController
                                                .text.length >
                                            10) {
                                          SnackBar snackbar = SnackBar(
                                              content: Text(
                                                  "Invalid Mobile Number"));
                                          scaffoldKey.currentState
                                              .showSnackBar(snackbar);
                                        } else if (professionController
                                            .text.isEmpty) {
                                          SnackBar snackbar = SnackBar(
                                              content: Text(
                                                  "Profession cannot be null"));
                                          scaffoldKey.currentState
                                              .showSnackBar(snackbar);
                                        } else {
                                          proceed();
                                        }
                                      },
                                      child: CircleAvatar(
                                        radius: 30,
                                        backgroundColor: Colors.white,
                                        child: Icon(
                                          Icons.arrow_forward_ios,
                                          color: Colors.blue[800],
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: size.height * 0.15),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
  }
}
