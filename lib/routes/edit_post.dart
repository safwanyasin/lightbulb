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
import '../routes/profile_page.dart';

import '../util/db.dart';

int runs = 0;

class EditPost extends StatefulWidget {
  const EditPost({Key? key, required this.analytics, required this.observer})
      : super(key: key);

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  _EditPostState createState() => _EditPostState();

  static const String routeName = '/editpost';
}

class _EditPostState extends State<EditPost> {
  late Future<ListResult> futureFiles;
  DBService db = DBService();

  @override
  initState() {
    super.initState();
    setCurrentScreen(widget.analytics, 'Edit Post Page', 'editpostPage');
    futureFiles = FirebaseStorage.instance.ref('uploads/').listAll();
  }

  List<String> dummy = ["dummy", "dummy"];
  String caption = "";
  String newCaption = "";
  String originalImage = "";
  String? editPostId = "";
  List<dynamic> topics = [];
  String location = "";

  int topicNum = 0;
  List<String> topicsSel = [];
  Widget topicswidget({required int number}) => ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Container(
          color: AppColors.secondaryDark,
          child: Container(
            margin: const EdgeInsets.all(8),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.secondaryDark)),
              child: Text(
                topicList[number],
                style: GoogleFonts.nunito(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primary,
                ),
              ),
              onPressed: () async {
                topicNum++;
                topicsSel.add(topicList[number]);
                SharedPreferences? prefs =
                    await SharedPreferences.getInstance();
                await prefs!.setStringList('topicsSel', topicsSel);
              },
            ),
          ),
        ),
      );

  Widget Selectedtopicswidget({required int number}) => ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Container(
          color: AppColors.secondaryDark,
          child: Container(
            margin: const EdgeInsets.all(8),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.secondaryDark)),
              child: Text(
                topics[number],
                style: GoogleFonts.nunito(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primary,
                ),
              ),
              onPressed: () {},
            ),
          ),
        ),
      );

  File? image = null;
  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      final imageTemporary = File(image.path);
      //imageTemporary = '';
      setState(() {
        this.image = imageTemporary;
        // uploadImageToFirebase();
        //newProf = image.path;
      });
    } on PlatformException catch (e) {
      print('Failed to pick an image.');
    }
  }
  //List<String> urls = [];

  Future uploadImageToFirestore(String image) async {
    bool uploaded = false;
    QuerySnapshot querySnapshotImage =
        await FirebaseFirestore.instance.collection('image').get();
    for (int i = 0; i < querySnapshotImage.docs.length; i++) {
      if (querySnapshotImage.docs[i]["token"] == editPostId) {
        await db.addImage(image, editPostId);
        uploaded = true;
      }
    }
    if (uploaded == false) {
      SharedPreferences? prefs = await SharedPreferences.getInstance();
      String? cuID = prefs!.getString('userID');
      QuerySnapshot querySnapshotPost = await FirebaseFirestore.instance
          .collection('users')
          .doc(cuID)
          .collection('posts')
          .get();
      String? id = editPostId;
      await db.addImage(image, id);
    }
  }

  Future uploadImageToFirebase() async {
    String fileName = basename(image!.path);
    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('uploads/$fileName');
    try {
      await firebaseStorageRef.putFile(File(image!.path));
      print(image!.path);
      var url = await FirebaseStorage.instance
          .ref()
          .child('uploads/$fileName')
          .getDownloadURL();
      await uploadImageToFirestore(url.toString());
      //return url.toString();
      // sapshot.ref
      print("Upload complete");
      setState(() {
        image = null;
      });
      return url.toString();
    } on FirebaseException catch (e) {
      print('ERROR ${e.code} - ${e.message}');
    } catch (e) {
      print(e.toString());
    }
  }

  List<String> topicList = [
    "#Math",
    "#Lazy",
    "#CS",
    "#Psychy",
    "#Mecha",
    "#Flutter",
    "#Science",
    "#Biology",
    "#Chemistry",
    "#Physics",
    "#Coding",
    "#Arts",
    "#History",
    "#Law",
    "#Ethics",
    "#Calculus",
    "#Algebra",
    "Sabanci",
    "#University",
    "#Education",
    "#Politics",
    "#School",
    "#Degree",
    "#Gradaute",
    "#Fun",
    "#Challenge",
    "#Python",
    "#C++",
    "#Java",
    "#Dart",
    "#CS310",
    "#Help",
    "#Question",
    "#Answer",
    "#Exams",
    "#Tests",
    "#Finals",
    "#Midterms",
    "#Assignments",
    "#Grades",
    "#Debate",
    "#Activity",
    "#Stressed",
    "#Depressed",
    "#Bored",
    "#Holliday",
    "#Vacation",
    "#Hawaii",
    "#Paris",
    "#America",
    "#Europe",
    "#Asia",
    "#Switzerland",
    "#Turkey",
    "#Greece",
    "#Paris",
    "#Movies",
    "#TV",
    "#Shows",
    "#Cartoon",
    "#College",
    "#Pass",
    "#INeedAnA",
    "#TooManyHashtags"
  ];

  Future finalInfo() async {
    SharedPreferences? prefs = await SharedPreferences.getInstance();
    String? cuID = prefs!.getString('userID');
    List<String>? l = await prefs!.getStringList('topicsSel');
    //String myImage= "image";
    if (image != null) {
      await uploadImageToFirebase();
    }
    QuerySnapshot pic =
        await FirebaseFirestore.instance.collection("image").get();
    QuerySnapshot postSize = await FirebaseFirestore.instance
        .collection('users')
        .doc(cuID)
        .collection('posts')
        .get();
    int likes = 0;
    for (int x = 0; x < postSize.docs.length; x++) {
      if (postSize.docs[x]["token"] == editPostId) {
        likes = postSize.docs[x]["likes"];
      }
    }

    //await getPostInfo();
    for (int i = 0; i < pic.docs.length; i++) {
      if (pic.docs[i]["token"] == editPostId) {
        originalImage = pic.docs[i]["image"];
      }
    }
    if (newCaption == "") newCaption = caption;

    if (l!.length == 0) {
      await db.addPost(newCaption, topics, originalImage, likes, 0, location,
          editPostId, cuID);
    } else {
      await db.addPost(
          newCaption, l, originalImage, likes, 0, location, editPostId, cuID);
    }

    await prefs!.setStringList('topicSel', []);
    showToast(
        'Post edited! Please scroll down to refresh.', Toast.LENGTH_SHORT);
  }

  Future delEditPost(BuildContext context) async {
    SharedPreferences? prefs = await SharedPreferences.getInstance();
    String? cuID = await prefs!.getString('userID');
    // await prefs!.setString('epToken', "");
    // await prefs!.setString('epCaption', "");
    // await prefs!.setStringList('epTopics', []);
    // await prefs!.setString('epImage', "");
    await prefs!.setString('postToken', '');
    Navigator.pop(context);
  }

  Future getPostInfo() async {
    SharedPreferences? prefs = await SharedPreferences.getInstance();
    String? cuID = prefs!.getString('userID');
    String? postID = prefs!.getString('postToken');
    DocumentSnapshot postData = await FirebaseFirestore.instance
        .collection('users')
        .doc(cuID)
        .collection('posts')
        .doc(postID)
        .get();
    originalImage = postData['image'];
    caption = postData['caption'];
    topics = postData['topics'];
    //editPostId = await prefs!.getString('epToken');
    // for (int j = 0; j < myPost.docs.length; j++) {
    //   if (myPost.docs[j]["token"] == editPostId) {
    //     caption = myPost.docs[j]["caption"];
    //     myImage = myPost.docs[j]["image"];
    //     editPostId = myPost.docs[j]["token"];
    //     for (int k = 0; k < myPost.docs[j]["topics"].length; k++) {
    //       if (check(topics, myPost.docs[j]["topics"][k]) == false) {
    //         topics.add(myPost.docs[j]["topics"][k]);
    //       }
    //     }
    //   }
    // }
  }

  bool check(List<dynamic> l, item) {
    for (int i = 0; i < l.length; i++) {
      if (l[i] == item) {
        return true;
      }
    }
    return false;
  }

  void showToast(String message, Toast t) => Fluttertoast.showToast(
        toastLength: t,
        msg: message,
        fontSize: 18.0,
      );

  @override
  Widget build(BuildContext context) {
    // runs++;
    // if(runs == 1){
    //   for(int i = 0; i < topicList.length; i++){
    //     db.addTopics(topicList[i], i.toString());
    //   }
    // }
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        title: Text(
          'Edit Post',
          style: navBarHeadingStyle,
        ),
        centerTitle: true,
        backgroundColor: AppColors.secondaryDark,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.primary,
          ),
          onPressed: () async {
            SharedPreferences? prefs = await SharedPreferences.getInstance();
            //await prefs!.setStringList('topicSel', []);

            await delEditPost(context);
          },
        ),
        // actions: [
        // ],
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(15, screenHeight(context) / 30, 15, 15),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        //color: AppColors.secondaryDark,
                        height: 3,
                        width: screenWidth(context) / 2.3,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.fromLTRB(0, 0, 0, 11),
                            //  child: OutlinedButton(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: image != null
                                  ? Image.file(File(image!.path))
                                  : OutlinedButton(
                                      onPressed: () {
                                        pickImage(ImageSource.gallery);
                                      },
                                      child: FutureBuilder(
                                          future: getPostInfo(),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.done) {
                                              if (originalImage != "image") {
                                                return Image.network(
                                                    originalImage,
                                                    fit: BoxFit.cover);
                                              } else {
                                                return Icon(
                                                  Icons.add,
                                                  size: screenHeight(context) /
                                                      13,
                                                  color: AppColors.grey,
                                                );
                                              }
                                            }
                                            return const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          }),
                                      style: OutlinedButton.styleFrom(
                                        primary: Colors.white,
                                        backgroundColor: AppColors.primary,
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        side: const BorderSide(
                                            color: AppColors.white, width: 1),
                                      ),
                                    ),
                            ),
                            //   style: OutlinedButton.styleFrom(
                            //    primary: Colors.white,
                            //    backgroundColor: AppColors.primary,
                            //     shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                            //    side: const BorderSide(color: AppColors.white, width: 1),
                            //   ),
                            //   onPressed: () {

                            //     pickImage(ImageSource.gallery);
                            //   },
                            //  ),
                            decoration: ButtonStylingAlter.lsButton,
                            height: screenHeight(context) / 7.25,
                            width: screenHeight(context) / 7.25,
                          ),
                          Container(
                            //color: AppColors.secondaryDark,
                            // width: 5,
                            // height: 5,
                            child: Text(
                              'Select Image',
                              style: createPostStyleSecondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 20),
                      Column(children: [
                        Container(
                          margin: const EdgeInsets.fromLTRB(0, 0, 0, 11),
                          child: OutlinedButton(
                            child: Icon(
                              Icons.attach_file,
                              size: screenHeight(context) / 13,
                              color: AppColors.grey,
                            ),
                            style: OutlinedButton.styleFrom(
                              primary: Colors.white,
                              backgroundColor: AppColors.primary,
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              side: const BorderSide(
                                  color: AppColors.white, width: 1),
                            ),
                            onPressed: () {
                              print('Pressed');
                            },
                          ),
                          //decoration: ButtonStylingAlter.lsButton,
                          height: screenHeight(context) / 7.25,
                          width: screenHeight(context) / 7.25,
                        ),
                        Container(
                          //color: AppColors.secondaryDark,
                          child: Text(
                            'Attach File',
                            style: createPostStyleSecondary,
                          ),
                        ),
                      ])
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        // padding: EdgeInsets.all(8),
                        margin: const EdgeInsets.fromLTRB(0, 11, 0, 0),
                        height: screenHeight(context) / 12,
                        width: screenWidth(context) / 1.14,
                        child: TextField(
                          onSubmitted: (text) {
                            newCaption = text;
                          },
                          style: lsInputTextStyle,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                  color: AppColors.white,
                                  width: 1,
                                )),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                  color: AppColors.white,
                                  width: 1,
                                )),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(
                                color: AppColors.white,
                                width: 1,
                              ),
                            ),
                            errorStyle: lsErrorTextStyle,
                            label: Container(
                              width: MediaQuery.of(context).size.width / 1.3,
                              child: FutureBuilder(
                                  future: getPostInfo(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      return Text(
                                        caption,
                                        style: TextStyle(color: AppColors.grey),
                                      );
                                    }
                                    return Text('');
                                  }),
                            ),
                            fillColor: AppColors.primary,
                            filled: true,
                            labelStyle: lsInputTextStyle,
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: AppColors.white,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        // padding: EdgeInsets.all(8),
                        // margin: EdgeInsets.fromLTRB(0, 11, 0, 0),
                        height: screenHeight(context) / 12,
                        width: screenWidth(context) / 1.14,
                        child: TextField(
                          onSubmitted: (text) {
                            location = text;
                          },
                          style: lsInputTextStyle,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                  color: AppColors.white,
                                  width: 1,
                                )),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                  color: AppColors.white,
                                  width: 1,
                                )),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(
                                color: AppColors.white,
                                width: 1,
                              ),
                            ),
                            errorStyle: lsErrorTextStyle,
                            label: FutureBuilder(
                                future: getPostInfo(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    return Container(
                                      width: 100,
                                      child: Text(
                                        location,
                                        style: TextStyle(color: AppColors.grey),
                                      ),
                                    );
                                  }
                                  return Container();
                                }),
                            fillColor: AppColors.primary,
                            filled: true,
                            labelStyle: lsInputTextStyle,
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: AppColors.white,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(11, 0, 11, 0),
                        //color: AppColors.secondaryDark,
                        child: Text(
                          'Select new topics',
                          style: createPostStyleSecondary,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 5, 0, 11),
                        height: screenHeight(context) / 24,
                        width: screenWidth(context) / 1.14,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: topicList.length,
                          separatorBuilder: (context, _) => SizedBox(width: 12),
                          itemBuilder: (context, index) =>
                              topicswidget(number: index),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(11, 0, 11, 0),
                        //color: AppColors.secondaryDark,
                        child: Text(
                          'Selected topics',
                          style: createPostStyleSecondary,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 5, 0, 11),
                        height: screenHeight(context) / 24,
                        width: screenWidth(context) / 1.14,
                        child: FutureBuilder(
                            future: getPostInfo(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                return ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: topics.length,
                                  separatorBuilder: (context, _) =>
                                      SizedBox(width: 12),
                                  itemBuilder: (context, index) =>
                                      Selectedtopicswidget(number: index),
                                );
                              }
                              return Text('');
                            }),
                      ),
                    ],
                  ),
                  // Container(
                  //   height: screenHeight(context)/10,
                  //  width: screenWidth(context)/1.14,
                  //  child: FutureBuilder(
                  //   future: uploadImageToFirebase(),
                  //   builder: (context, snapshot) {
                  // if(snapshot.hasData){
                  //final files = snapshot.data!.items;
                  //   return ListView.builder(
                  //     itemCount: 1,
                  //      itemBuilder: (context, index) {
                  //final file = files[index];
                  //      return ListTile(title: Image.network(snapshot.data.toString()),
                  //      );
                  //       },
                  //   );
                  // }
                  // else if(snapshot.hasError){
                  //    return const Center(child: Text('Error'),);
                  //  }
                  // else{
                  //   return const Center(child: CircularProgressIndicator(),);
                  //  }
                  // },),
                  //  FutureBuilder(
                  //    future: getImage(),
                  //    builder: (context, snapshot) {
                  //      return Image.network(upload);
                  //    },),
                  // ),
                ],
              ),

              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Container(
              //       //color: AppColors.secondaryDark,
              //       height: MediaQuery.of(context).size.height/5.5,
              //       width: MediaQuery.of(context).size.height/2.3,
              //     ),
              //   ],
              // ),
              SizedBox(
                height: screenHeight(context) / 4,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 11),
                    child: OutlinedButton(
                        onPressed: () async {
                          showToast('Editing post, please wait...',
                              Toast.LENGTH_SHORT);
                          logCustomEvent(
                              widget.analytics, 'attempted to edit post');
                          await finalInfo();
                          await delEditPost(context);
                          //setState(() {});
                          //Navigator.pushNamed(context, '/profilepage');
                        },
                        child: Text(
                          'Edit',
                          style: GoogleFonts.nunito(
                            fontSize: 25,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                          color: Color(0x00000000),
                        ))),
                    decoration: CreateButtonStyling.lsButton,
                    height: 50,
                    width: screenWidth(context) / 2.5,
                  ),
                ],
              ),
              //  ),
            ],
            //),
          ),
        ),
      ),
    );
  }
}
