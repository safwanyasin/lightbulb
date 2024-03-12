import 'dart:io';
import 'dart:io' show Platform;
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lightbulb/util/colors.dart';
import 'package:lightbulb/util/dimensions.dart';
import 'package:lightbulb/util/screen_sizes.dart';
import 'package:lightbulb/util/styles.dart';
import 'package:lightbulb/util/button_styling.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../analytics.dart';
import '../model/classes.dart';
import '../ui/post_card.dart';
//import '..lib//Post.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:flutter/material.dart';
import '../routes/settings.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

import '../util/db.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage(
      {Key? key, required this.analytics, required this.observer})
      : super(key: key);

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
  static const String routeName = '/editprofile';
}

class _EditProfilePageState extends State<EditProfilePage> {
  @override
  initState() {
    super.initState();
    setCurrentScreen(widget.analytics, 'Edit Profile Page', 'editprofilePage');
  }

  DBService db = DBService();
  bool state = true;
  String? name = '';
  String? username = '';
  String? profpic = '';
  String pass = '';
  String email = '';
  int posts = 0;
  int followers = 0;
  int following = 0;
  String? bio = '';
  String? location = '';
  final _formKey = GlobalKey<FormState>();
  // String uName = '';
  // String uUsername = '';
  // String uBio = '';
  // String uLocation = '';
  // String uProfpic = '';
  List<dynamic> followersList = ["dummy", "dummy"];
  List<dynamic> followingList = ["dummy", "dummy"];
  List<dynamic> followReq = ["dummy", "dummy"];
  List<dynamic> sentReq = ["dummy", "dummy"];
  List<dynamic> notifsList = ["dummy", "dummy"];
  String token = '';
  int runs = 0;
  Future getUser() async {
    runs++;
    SharedPreferences? prefs = await SharedPreferences.getInstance();
    String? cuID = prefs!.getString('userID');
    DocumentSnapshot u =
        await FirebaseFirestore.instance.collection('users').doc(cuID).get();
    name = u['name'];
    username = u['username'];
    bio = u['bio'];
    location = u['location'];
    profpic = u['profPic'];
    // for(int i =0; i < u.docs.length; i++) {
    //   if(u.docs[i]["token1"] == cuID) {
    //     name = u.docs[i]["username"];
    //     if(runs == 1) {
    //       await prefs!.setString('username', username!);
    //     }
    //     username = u.docs[i]["name"];
    //     if(runs == 1) {
    //       await prefs!.setString('name', name!);
    //     }
    //     profpic = u.docs[i]["profpic"];
    //     if(runs == 1) {
    //       await prefs!.setString('profilepic', profpic!);
    //     }
    //     pass = u.docs[i]["password"];
    //     email = u.docs[i]["token1"];
    //     posts = u.docs[i]["posts"];
    //     followers = u.docs[i]["followersList"].length;
    //     following = u.docs[i]["followingList"].length;
    //     bio = u.docs[i]["bio"];
    //     if(runs == 1){
    //       await prefs!.setString('bio', bio!);
    //     }
    //     location = u.docs[i]["location"];
    //     //await prefs!.setString('location', location!);
    //     followersList = u.docs[i]["followersList"];
    //     followingList = u.docs[i]["followingList"];
    //     followReq = u.docs[i]["followReq"];
    //     sentReq = u.docs[i]["sentReq"];
    //     notifsList = u.docs[i]["notifsList"];
    //     token = u.docs[i]["token1"];
    //   }
    // }
  }

  //User user = User( Name: 'Fawaz Mirza', TempUsername: '@sillygoose', pass: 'password', Email: 'fawaz@email.com', Location: 'IST, Turkey', post1: Post1(caption: 'caption', topics: ["#topics","#topics","#topics"], image: 'https://i.pinimg.com/736x/63/04/af/6304afcd59fd8b795a6482bcb1181404.jpg', likes: 0, comments:  0));
  //User user = User(Name: Fawaz Mirza, TempUsername: TempUsername, pass: pass, bio: bio, followReq: followReq, followersList: followersList, followingList: followingList, sentReq: sentReq, location: location, profilepic: profilepic, token: token, Email: Email, post1: post1)
// class SettingsUI extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: "Setting UI",
//       home: EditProfilePage(),
//     );
//   }
// }

  bool showPassword = false; //String newUsername = user.TempUsername;
  //String newEmail= user.Email; String newLoc = user.Location; String newPass = user.pass;
  //String newProf = user.profilepic;
  XFile? imageFile;
  File? convImageFile;
  String imageUrl = '';
  //File? image;

  Future takeImage(ImageSource source) async {
    ImagePicker imagePicker = ImagePicker();
    imageFile = await imagePicker.pickImage(source: source);
    setState(() {
      this.convImageFile = File(imageFile!.path);
    });
  }

  Future uploadImage() async {
    SharedPreferences? prefs = await SharedPreferences.getInstance();
    String? cuID = prefs!.getString('userID');
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('profilePictures');
    Reference referenceImageToUpload = referenceDirImages.child('${cuID}');

    try {
      await referenceImageToUpload.putFile(File(imageFile!.path));
      imageUrl = await referenceImageToUpload.getDownloadURL();
      // final data = {'profPic': imageUrl.toString()};
      // await FirebaseFirestore.instance
      //     .collection('users')
      //     .doc(cuID)
      //     .set(data, SetOptions(merge: true));
      profpic = imageUrl.toString();
    } catch (e) {}
  }

  // Future pickImage(ImageSource source) async {
  //   try {
  //     final image2 = await ImagePicker().pickImage(source: source);
  //     if (image2 == null) return;
  //     final imageTemporary = File(image2.path);
  //     //imageTemporary = '';
  //     setState(() {
  //       this.image = imageTemporary;
  //       uploadImageToFirebase();
  //       //newProf = image.path;
  //     });
  //   } on PlatformException catch (e) {
  //     print('Failed to pick an image.');
  //   }
  // }

  // Future uploadImageToFirebase() async {
  //   SharedPreferences? prefs = await SharedPreferences.getInstance();
  //   String fileName = basename(image!.path);
  //   Reference firebaseStorageRef =
  //       FirebaseStorage.instance.ref().child('uploads/$fileName');
  //   try {
  //     await firebaseStorageRef.putFile(File(image!.path));
  //     print(image!.path);
  //     var url = await FirebaseStorage.instance
  //         .ref()
  //         .child('uploads/$fileName')
  //         .getDownloadURL();
  //     //await prefs!.setString('profilepic', url.toString());
  //     profpic = url.toString();
  //     showToast('Upload complete!', Toast.LENGTH_SHORT);
  //     //return url.toString();
  //     // sapshot.ref
  //     //print("Upload complete");
  //     setState(() {
  //       image = null;
  //     });
  //     return url.toString();
  //   } on FirebaseException catch (e) {
  //     print('ERROR ${e.code} - ${e.message}');
  //   } catch (e) {
  //     print(e.toString());
  //   }
  //   //showToast('Upload complete!', Toast.LENGTH_SHORT);
  // }

  void showToast(String message, Toast t) => Fluttertoast.showToast(
        toastLength: t,
        msg: message,
        fontSize: 18.0,
      );

  Future updateUserInfo(String item) async {
    //SharedPreferences? prefs = await SharedPreferences.getInstance();
    // profpic = await prefs!.getString('profilepic');
    // username = await prefs!.getString('username');
    // name = await prefs!.getString('name');
    // bio = await prefs!.getString('bio');
    // await db.addUser(
    //     state,
    //     email,
    //     bio,
    //     posts,
    //     profpic,
    //     followReq,
    //     followingList,
    //     followersList,
    //     username,
    //     name,
    //     pass,
    //     sentReq,
    //     token,
    //     'caption',
    //     followingList,
    //     'image',
    //     0,
    //     0,
    //     location,
    //     'postToken',
    //     'notiContent',
    //     'notiSender',
    //     'notiToken',
    //     notifsList,
    //     'notThis');
    await uploadImage();
    final data = {
      'name': name,
      'username': username,
      'bio': bio,
      'location': location,
      'profPic': profpic
    };
    SharedPreferences? prefs = await SharedPreferences.getInstance();
    String? cuID = prefs!.getString('userID');
    await FirebaseFirestore.instance
        .collection('users')
        .doc(cuID)
        .set(data, SetOptions(merge: true));
  }

  int builds = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile", style: navBarHeadingStyle),
        centerTitle: true,
        backgroundColor: AppColors.secondaryDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.primary,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      backgroundColor: AppColors.primary,
      body: FutureBuilder(
          future: getUser(),
          builder: (context, snapshot) {
            return Container(
              padding: const EdgeInsets.only(left: 16, top: 25, right: 16),
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      SizedBox(
                        height: screenHeight(context) / 56.3,
                      ),
                      Center(
                        child: Stack(
                          children: [
                            Container(
                                // color: AppColors.secondaryDark,
                                width: screenWidth(context) / 3,
                                height: screenWidth(context) / 3,
                                child: convImageFile != null
                                    ? ClipOval(
                                        child: Image.file(
                                        convImageFile!,
                                        width: screenWidth(context) / 2.5,
                                        height: screenWidth(context) / 2.5,
                                        fit: BoxFit.cover,
                                      ))
                                    : ClipOval(
                                        child: Align(
                                          child:
                                              //if(snapshot.connectionState == ConnectionState.done){
                                              // Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
                                              Image.network(
                                            profpic!,
                                          ),
                                          alignment: Alignment.center,
                                          //child: Text(
                                          // tempuser.post1.caption,
                                          // style: captionStyle,
                                          //textAlign: TextAlign.start,
                                        ),
                                        // Image.network(
                                        // 'https://www.tenforums.com/geek/gars/images/2/types/thumb_15951118880user.png',
                                        // ),
                                      )
                                //child: ,
                                // decoration: BoxDecoration(
                                //    border: Border.all(
                                //        width: 4,
                                //       color: AppColors.secondaryDark,
                                //   ),
                                // boxShadow: [
                                //   BoxShadow(
                                //       spreadRadius: 2,
                                //       blurRadius: 10,
                                //       color: Colors.black.withOpacity(0.1),
                                //      offset: Offset(0, 10))
                                //  ],
                                //  shape: BoxShape.circle,
                                // image: DecorationImage(
                                //     fit: BoxFit.cover,
                                //  image: NetworkImage(
                                //    "https://www.tenforums.com/geek/gars/images/2/types/thumb_15951118880user.png",
                                //)
                                // )
                                // ),

                                ),
                            Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  // color: AppColors.white,
                                  height: screenWidth(context) / 9.75,
                                  width: screenWidth(context) / 9.75,

                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      width: 4,
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                    ),
                                    color: AppColors.secondaryDark,
                                  ),
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        //top: 0,
                                        right: -9,
                                        //left: 0,
                                        bottom: -9,
                                        child: IconButton(
                                          icon: const Icon(
                                            Icons.edit,
                                            color: AppColors.white,
                                          ),
                                          onPressed: () async {
                                            // await pickImage(ImageSource.camera);
                                            await takeImage(ImageSource.camera);
                                            showToast(
                                                'Uploading image, please wait...',
                                                Toast.LENGTH_SHORT);
                                            //await uploadImage();
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: screenHeight(context) / 24.1,
                      ),
                      // buildTextField(context, "Full Name", "", false),
                      // buildTextField(context, "Username", "", false),
                      // buildTextField(context, "Bio", "", false),
                      // buildTextField(context, "Location", "IST, Turkey", false),

                      Container(
                        // padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 11),
                        // padding: EdgeInsets.all(0),
                        width: screenWidth(context, dividedBy: 1.1),
                        height: screenHeight(context, dividedBy: 21),
                        child: TextFormField(
                          // keyboardType: TextInputType.emailAddress,
                          initialValue: username,
                          style: lsInputTextStyle,
                          decoration: InputDecoration(
                            hintText: username,
                            hintStyle: GoogleFonts.nunito(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.grey,
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: AppColors.white,
                                )),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: AppColors.white,
                                )),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: AppColors.white,
                              ),
                            ),
                            errorStyle: lsErrorTextStyle,
                            label: Container(
                              width: 60,
                              child: const Text('Username'),
                            ),
                            fillColor: AppColors.primary,
                            filled: true,
                            labelStyle: lsInputTextStyle,
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.white,
                                width: 3,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          validator: (value) {
                            if (value != null) {
                              // if (value.isEmpty) {
                              //   return 'Cannot leave username empty';
                              // }
                              // if(!EmailValidator.validate(value)) {
                              //   return 'Please enter a valid e-mail address';
                              // }
                            }
                          },
                          onSaved: (value) {
                            if (value!.isEmpty == false) {
                              username = value;
                            }
                          },
                        ),
                        // decoration: lsInputBoxStyle,
                      ),

                      Container(
                        // padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 11),
                        // padding: EdgeInsets.all(0),
                        width: screenWidth(context, dividedBy: 1.1),
                        height: screenHeight(context, dividedBy: 21),
                        child: TextFormField(
                          // keyboardType: TextInputType.emailAddress,
                          initialValue: name,
                          style: lsInputTextStyle,
                          decoration: InputDecoration(
                            hintText: name,
                            hintStyle: GoogleFonts.nunito(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.grey,
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: AppColors.white,
                                )),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: AppColors.white,
                                )),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: AppColors.white,
                              ),
                            ),
                            errorStyle: lsErrorTextStyle,
                            label: Container(
                              width: 60,
                              child: const Text('Full Name'),
                            ),
                            fillColor: AppColors.primary,
                            filled: true,
                            labelStyle: lsInputTextStyle,
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.white,
                                width: 3,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          validator: (value) {
                            if (value != null) {
                              // if (value.isEmpty) {
                              //   return 'Cannot leave username empty';
                              // }
                              // if(!EmailValidator.validate(value)) {
                              //   return 'Please enter a valid e-mail address';
                              // }
                            }
                          },
                          onSaved: (value) {
                            if (value!.isEmpty == false) {
                              name = value;
                            }
                          },
                        ),
                        // decoration: lsInputBoxStyle,
                      ),

                      Container(
                        // padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 11),
                        // padding: EdgeInsets.all(0),
                        width: screenWidth(context, dividedBy: 1.1),
                        height: screenHeight(context, dividedBy: 21),
                        child: TextFormField(
                          // keyboardType: TextInputType.emailAddress,
                          initialValue: bio,
                          style: lsInputTextStyle,
                          decoration: InputDecoration(
                            hintText: bio,
                            hintStyle: GoogleFonts.nunito(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.grey,
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: AppColors.white,
                                )),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: AppColors.white,
                                )),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: AppColors.white,
                              ),
                            ),
                            errorStyle: lsErrorTextStyle,
                            label: Container(
                              width: 60,
                              child: const Text('Bio'),
                            ),
                            fillColor: AppColors.primary,
                            filled: true,
                            labelStyle: lsInputTextStyle,
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.white,
                                width: 3,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          validator: (value) {
                            if (value != null) {
                              // if (value.isEmpty) {
                              //   return 'Cannot leave username empty';
                              // }
                              // if(!EmailValidator.validate(value)) {
                              //   return 'Please enter a valid e-mail address';
                              // }
                            }
                          },
                          onSaved: (value) {
                            if (value!.isEmpty == false) {
                              bio = value;
                            }
                          },
                        ),
                        // decoration: lsInputBoxStyle,
                      ),

                      Container(
                        // padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 11),
                        // padding: EdgeInsets.all(0),
                        width: screenWidth(context, dividedBy: 1.1),
                        height: screenHeight(context, dividedBy: 21),
                        child: TextFormField(
                          // keyboardType: TextInputType.emailAddress,
                          initialValue: location,
                          style: lsInputTextStyle,
                          decoration: InputDecoration(
                            hintText: location,
                            hintStyle: GoogleFonts.nunito(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.grey,
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: AppColors.white,
                                )),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: AppColors.white,
                                )),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: AppColors.white,
                              ),
                            ),
                            errorStyle: lsErrorTextStyle,
                            label: Container(
                              width: 60,
                              child: const Text('Location'),
                            ),
                            fillColor: AppColors.primary,
                            filled: true,
                            labelStyle: lsInputTextStyle,
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.white,
                                width: 3,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          validator: (value) {
                            if (value != null) {
                              // if (value.isEmpty) {
                              //   return 'Cannot leave location  empty';
                              // }
                              // if(!EmailValidator.validate(value)) {
                              //   return 'Please enter a valid e-mail address';
                              // }
                            }
                          },
                          onSaved: (value) {
                            if (value!.isEmpty == false) {
                              location = value;
                            }
                          },
                        ),
                        // decoration: lsInputBoxStyle,
                      ),

                      SizedBox(
                        height: screenHeight(context) / 24.1,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: const EdgeInsets.fromLTRB(0, 0, 0, 11),
                            width: screenWidth(context) / 2.3,
                            child: OutlinedButton(
                                onPressed: () async {
                                  // setState(() {
                                  //if(newUsername.contains(new RegExp(r'[A-Z]'))){
                                  //  user.TempUsername = newUsername;
                                  // }

                                  //user.Email = newEmail;
                                  // user.Location = newLoc;
                                  // user.pass = newPass;
                                  //  user.profilepic = newProf;
                                  // print(newProf);
                                  // }

                                  //  );
                                  if (_formKey.currentState!.validate()) {
                                    //print('Email: $email');
                                    _formKey.currentState!.save();
                                    logCustomEvent(
                                        widget.analytics, 'edited profile');
                                    Navigator.of(context).pop();
                                    await updateUserInfo("");
                                    showToast(
                                        'User Information Updated. Please scroll down to refresh.',
                                        Toast.LENGTH_SHORT);
                                  }
                                },
                                child: const Text(
                                  'SAVE',
                                  style: lsButtonTextStyle,
                                ),
                                style: OutlinedButton.styleFrom(
                                    side: const BorderSide(
                                  color: Color(0x00000000),
                                ))),
                            decoration: ButtonStyling.lsButton,
                            height: screenHeight(context) / 21.1,
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 11),
                            width: screenWidth(context) / 2.3,
                            child: OutlinedButton(
                              child: const Text(
                                'CANCEL',
                                style: lsButtonTextStyleAlter,
                              ),
                              style: OutlinedButton.styleFrom(
                                primary: Colors.white,
                                backgroundColor: AppColors.primary,
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                side: const BorderSide(
                                    color: AppColors.grey, width: 3),
                              ),
                              onPressed: () {
                                print('Pressed');
                                Navigator.of(context).pop();
                              },
                            ),
                            //decoration: ButtonStylingAlter.lsButton,
                            height: screenHeight(context) / 21.1,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }

  // Widget buildTextField(BuildContext context, String labelText,
  //     String placeholder, bool isPasswordTextField) {
  //   builds++;
  //   if (builds == 1) {
  //     //showD(context);
  //     //buildAccountOptionRow(context, title);
  //     //showToast('Please click Ok/Enter key after updating information');
  //   }
  //   return Padding(
  //     padding: const EdgeInsets.only(bottom: 35.0),
  //     child: Align(
  //       child: FutureBuilder(
  //           future: getUser(),
  //           builder: ((context, snapshot) {
  //             if (labelText == "Username") {
  //               placeholder = username!;
  //             }
  //             if (labelText == "Full Name") {
  //               placeholder = name!;
  //             }
  //             if (labelText == "Bio") {
  //               placeholder = bio!;
  //             }
  //             if (labelText == "Location") {
  //               placeholder = location!;
  //             }
  //             //if(snapshot.connectionState == ConnectionState.done){
  //             // Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
  //             return Column(
  //               children: [
  //                 TextField(
  //                   obscureText: isPasswordTextField ? showPassword : false,
  //                   style: GoogleFonts.nunito(
  //                     fontSize: 16,
  //                     fontWeight: FontWeight.bold,
  //                     color: AppColors.grey,
  //                   ),
  //                   onSubmitted: (text) async {
  //                     SharedPreferences? prefs =
  //                         await SharedPreferences.getInstance();
  //                     if (labelText == "Full Name") {
  //                       if (text.contains(new RegExp(r'[a-z]')) ||
  //                           text.contains(new RegExp(r'[A-Z]'))) {
  //                         //name = text;
  //                         //await prefs!.setString('username', text);
  //                         print("///////////////");
  //                         print(text);
  //                         name = text;
  //                       } else {
  //                         showToast('Full Name can not be empty.',
  //                             Toast.LENGTH_SHORT);
  //                       }
  //                     }
  //                     if (labelText == "Username") {
  //                       if (text.contains(new RegExp(r'[a-z]')) ||
  //                           text.contains(new RegExp(r'[A-Z]'))) {
  //                         //username = text;
  //                         //await prefs!.setString('name', text);
  //                         username = text;
  //                       } else {
  //                         showToast(
  //                             'Username can not be empty.', Toast.LENGTH_SHORT);
  //                       }
  //                     }
  //                     if (labelText == "Bio") {
  //                       if (text.contains(new RegExp(r'[a-z]')) ||
  //                           text.contains(new RegExp(r'[A-Z]'))) {
  //                         //newUserinfo(name, username, text, pass, location, "email");
  //                         //await prefs!.setString('bio', text);
  //                         bio = text;
  //                       } else {
  //                         showToast(
  //                             'Email can not be empty.', Toast.LENGTH_SHORT);
  //                       }
  //                     }
  //                     if (labelText == "Location") {
  //                       if (text.contains(new RegExp(r'[a-z]')) ||
  //                           text.contains(new RegExp(r'[A-Z]'))) {
  //                         //(name, username, email, pass, text, "location");
  //                         location = text;
  //                       } else {
  //                         showToast(
  //                             'Location can not be empty.', Toast.LENGTH_SHORT);
  //                       }
  //                     }
  //                   },
  //                   decoration: InputDecoration(
  //                       suffixIcon: isPasswordTextField
  //                           ? IconButton(
  //                               onPressed: () {
  //                                 setState(() {
  //                                   showPassword = !showPassword;
  //                                 });
  //                               },
  //                               icon: const Icon(
  //                                 Icons.remove_red_eye,
  //                                 color: AppColors.grey,
  //                               ),
  //                             )
  //                           : null,
  //                       contentPadding: const EdgeInsets.only(bottom: 3),
  //                       labelText: labelText,
  //                       labelStyle: GoogleFonts.nunito(
  //                         fontSize: 16,
  //                         fontWeight: FontWeight.bold,
  //                         color: AppColors.secondaryDark,
  //                       ),
  //                       floatingLabelBehavior: FloatingLabelBehavior.always,
  //                       hintText: placeholder,
  //                       hintStyle: GoogleFonts.nunito(
  //                         fontSize: 16,
  //                         fontWeight: FontWeight.bold,
  //                         color: AppColors.grey,
  //                       )),
  //                 ),
  //                 //Text('username: ${data['username']}', style: TextStyle(color: AppColors.white),),
  //               ],
  //             );
  //             //
  //             return Text('');
  //           })),
  //       alignment: Alignment.center,
  //       //child: Text(
  //       // tempuser.post1.caption,
  //       // style: captionStyle,
  //       //textAlign: TextAlign.start,
  //     ),
  //   );
  // }
}
