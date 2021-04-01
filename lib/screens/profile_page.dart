import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:news_app/constants.dart';
import 'package:news_app/database/variables.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var userData = [];
  Stream myStream;
  bool isLoading = true;
  File imagePath;

  getStream() async {
    var firebaseUser = await FirebaseAuth.instance.currentUser;
    setState(() {
      myStream = userCollection.doc(firebaseUser.email).snapshots();
    });
  }

  setData() async {
    setState(() {
      isLoading = true;
    });
    var firebaseUser = await FirebaseAuth.instance.currentUser;
    DocumentSnapshot documentSnapshot =
        await userCollection.doc(firebaseUser.email).get();
    var email = firebaseUser.email;
    var mobile = documentSnapshot.data()["mobile"];
    var location = documentSnapshot.data()["location"];
    var profession = documentSnapshot.data()["profession"];
    setState(() {
      userData = [
        ["Email", email.toString()],
        ["Mobile Number", mobile.toString()],
        ["Location", location.toString()],
        ["Profession", profession.toString()]
      ];
    });
    setState(() {
      isLoading = false;
    });
  }

  storeProfilePic() async {
    setState(() {
      isLoading = true;
    });
    var firebaseUser = await FirebaseAuth.instance.currentUser;

    String downloadPic = imagePath == null
        ? "https://thumbs.dreamstime.com/b/default-avatar-profile-icon-vector-social-media-user-photo-183042379.jpg"
        : await uploadImage();
    userCollection
        .doc(firebaseUser.email)
        .set({'profilePic': downloadPic}, SetOptions(merge: true));
    setState(() {
      isLoading = false;
    });
  }

  _imgFromGallery() async {
    final image = await ImagePicker()
        .getImage(source: ImageSource.gallery, maxHeight: 670, maxWidth: 800);
    if (image != null) {
      setState(() {
        imagePath = File(image.path);
      });
    }
    storeProfilePic();
  }

  _imgFromCamera() async {
    final image = await ImagePicker()
        .getImage(source: ImageSource.camera, maxHeight: 670, maxWidth: 800);
    if (image != null) {
      setState(() {
        imagePath = File(image.path);
      });
    }
    storeProfilePic();
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "Choose Profile Pic",
                      style: GoogleFonts.nunito(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Gallery'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  // pickImage(ImageSource imageSource) async{
  //   final image = await ImagePicker().getImage(
  //       source: imageSource,
  //       maxHeight: 670,
  //       maxWidth: 800
  //   );
  //   setState(() {
  //     imagePath = File(image.path);
  //   });
  //   storeProfilePic();
  //   Navigator.pop(context);
  // }

  // pickImageDialog(){
  //   return showDialog(
  //       context: context,
  //       builder: (context){
  //         return SimpleDialog(
  //           children: [
  //             SimpleDialogOption(
  //               onPressed: () => pickImage(ImageSource.gallery),
  //               child: Text("From Galley", style: TextStyle(fontSize: 20, color: kPrimaryColor),),
  //             ),
  //             SimpleDialogOption(
  //               onPressed: () => pickImage(ImageSource.camera),
  //               child: Text("From Camera", style: TextStyle(fontSize: 20, color: kPrimaryColor),),
  //             ),
  //             SimpleDialogOption(
  //               onPressed: () => Navigator.pop(context),
  //               child: Text("Cancel", style: TextStyle(fontSize: 20, color: kPrimaryColor),),
  //             ),
  //           ],
  //         );
  //       }
  //   );
  // }

  uploadImage() async {
    var firebaseUser = await FirebaseAuth.instance.currentUser;
    //store image
    StorageUploadTask storage =
        profilePics.child(firebaseUser.email).putFile(imagePath);

    //complete image
    StorageTaskSnapshot storageTaskSnapshot = await storage.onComplete;

    //download pic
    String downloadPic = await storageTaskSnapshot.ref.getDownloadURL();

    return downloadPic;
  }

  @override
  void initState() {
    super.initState();
    getStream();
    setData();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      color: Colors.white,
      height: size.height,
      width: size.width,
      child: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: SingleChildScrollView(
          child: StreamBuilder(
              stream: myStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 10),
                    Text(
                      snapshot.data['name'],
                      style: GoogleFonts.montserrat(
                        color: Colors.black,
                        fontSize: 25,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      snapshot.data['profession'],
                      style: GoogleFonts.montserrat(
                        color: Colors.black45,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      height: MediaQuery.of(context).size.width * 0.35,
                      width: MediaQuery.of(context).size.width * 0.35,
                      child: Stack(
                        children: [
                          ClipOval(
                            child: Image.network(
                              snapshot.data['profilePic'],
                              height: MediaQuery.of(context).size.width * 0.35,
                              width: MediaQuery.of(context).size.width * 0.35,
                              fit: BoxFit.cover,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _showPicker(context),
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: CircleAvatar(
                                backgroundColor: kPrimaryColor,
                                radius:
                                    MediaQuery.of(context).size.width * 0.05,
                                child: Icon(
                                  CupertinoIcons.pen,
                                  color: Colors.white,
                                  size:
                                      MediaQuery.of(context).size.width * 0.05,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    Container(height: 1, color: Colors.grey[300]),
                    SizedBox(height: 30),
                    GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: 1.6,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 20.0,
                      shrinkWrap: true,
                      padding: EdgeInsets.all(20),
                      physics: NeverScrollableScrollPhysics(),
                      children: List.generate(
                        4,
                        (index) => ProfileCard(
                          title: userData[index][0],
                          content: userData[index][1],
                          size: size,
                        ),
                      ),
                    ),
                  ],
                );
              }),
        ),
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  final title, content, size;

  const ProfileCard({
    Key key,
    this.title,
    this.content,
    this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title,
            style: GoogleFonts.montserrat(
                fontSize: size.width * 0.05,
                color: kPrimaryColor,
                fontWeight: FontWeight.w600)),
        Text(content,
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              fontSize: size.width * 0.05,
              color: Colors.black45,
            )),
      ],
    );
  }
}
