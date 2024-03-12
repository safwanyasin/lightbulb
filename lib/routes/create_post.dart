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
import 'package:uuid/uuid.dart';

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

class CreatePost extends StatefulWidget {
  const  CreatePost({Key? key, required this.analytics, required this.observer}) : super(key: key);

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  _CreatePostState createState() => _CreatePostState();

  static const String routeName = '/createpost';
}
class _CreatePostState extends State<CreatePost>{
  late Future<ListResult> futureFiles;
  DBService db = DBService();


  @override
  initState() {
    super.initState();
    setCurrentScreen(widget.analytics, 'Create Post Page', 'createpostPage');
    futureFiles = FirebaseStorage.instance.ref('uploads/').listAll();
  }


  List<String> dummy = ["dummy","dummy"];
  String caption = "";
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
              side: BorderSide(color: AppColors.secondaryDark)
            ),
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
              SharedPreferences? prefs = await SharedPreferences.getInstance();
              await prefs!.setStringList('topicsSel', topicsSel);
            },
          ),
        ),
      ),
  );

  File? image = null;
  Future pickImage(ImageSource source) async{
    try {
      final image = await ImagePicker().pickImage(source: source);
      if(image == null) return;
      final imageTemporary = File(image.path);
      //imageTemporary = '';
      setState((){
        this.image = imageTemporary;
       // uploadImageToFirebase();
        //newProf = image.path;
      });
    } on PlatformException catch (e) {
      print('Failed to pick an image.');
    }
  }
  //List<String> urls = [];

  Future uploadImageToFirestore(String image, String id) async{
    SharedPreferences? prefs = await SharedPreferences.getInstance();
    String? cuID =  prefs!.getString('userID');
    QuerySnapshot querySnapshotPost = await FirebaseFirestore.instance.collection('users').doc(cuID).collection('posts').get();
    int num = querySnapshotPost.docs.length;
    //String id = cu.docs[0]["token"] + "post" + num.toString();
    await db.addImage(image, id);
  }

  Future uploadImageToFirebase(String id) async {
    String fileName = basename(image!.path);
    Reference firebaseStorageRef = FirebaseStorage.instance.ref().child('uploads/$fileName');
    try {
      await firebaseStorageRef.putFile(File(image!.path));
      print(image!.path);
      var url = await FirebaseStorage.instance.ref().child('uploads/$fileName').getDownloadURL();
      await uploadImageToFirestore(url.toString(), id);
      //return url.toString();
      // sapshot.ref
      print("Upload complete");
      setState((){
        image = null;
      });
      return url.toString();
    } on FirebaseException catch(e) {
      print('ERROR ${e.code} - ${e.message}');
    } catch(e) {
      print(e.toString());
    }
  }


  List<String> topicList = [
    "#Math","#Lazy","#CS","#Psychy","#Mecha","#Flutter","#Science","#Biology","#Chemistry","#Physics","#Coding","#Arts","#History",
    "#Law","#Ethics","#Calculus","#Algebra","Sabanci","#University","#Education","#Politics","#School","#Degree","#Gradaute","#Fun",
    "#Challenge","#Python","#C++","#Java","#Dart","#CS310","#Help","#Question","#Answer","#Exams","#Tests","#Finals","#Midterms",
    "#Assignments","#Grades","#Debate","#Activity","#Stressed","#Depressed","#Bored","#Holliday","#Vacation","#Hawaii","#Paris",
    "#America","#Europe","#Asia","#Switzerland","#Turkey","#Greece","#Paris","#Movies","#TV","#Shows","#Cartoon","#College",
    "#Pass","#INeedAnA","#TooManyHashtags"
  ];

  void showToast(String message) => Fluttertoast.showToast(
    msg: message,
    fontSize: 18.0,
  );


  Future finalInfo() async{
    SharedPreferences? prefs = await SharedPreferences.getInstance();
    List<String>? l = await prefs!.getStringList('topicsSel');
    const uuid = Uuid();
    String tok = uuid.v4();
    String? id =  prefs!.getString('userID');
    String myImage= "image";
    QuerySnapshot picSize = await FirebaseFirestore.instance.collection("image").get();
    int initSize = picSize.docs.length;
    if(image != null) {
      await uploadImageToFirebase(tok);
    }

    QuerySnapshot pic = await FirebaseFirestore.instance.collection("image").get();
    int newSize = pic.docs.length;
    QuerySnapshot postSize = await FirebaseFirestore.instance.collection('users').doc(id).collection('posts').get();
    int num = postSize.docs.length;



    if(initSize != newSize) {
      for(int i = 0; i < pic.docs.length; i++) {
        if(pic.docs[i]["token"] == tok) {
          myImage = pic.docs[i]["image"];
          await db.addPost(caption, l, myImage, 0, 0, location, tok, id);
        }
      }

    }else{
       await db.addPost(caption, l, myImage, 0, 0, location, tok, id);
    }
    await prefs!.setStringList('topicSel', []);
    showToast('Post created! Check your profile page.');
  }




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
          'Create Post',
          style: navBarHeadingStyle,
        ),
        centerTitle: true,
        backgroundColor: AppColors.secondaryDark,
        elevation: 0,
        // leading: IconButton(
        //   icon: Icon(
        //     Icons.arrow_back,
        //     color: AppColors.primary,
        //   ),
        //   onPressed: () {
        //     Navigator.of(context).pop();
        //   },
        // ),
        // actions: [
        // ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: SafeArea(
            // child: Padding(
            //  padding: const EdgeInsets.all(8.0),
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
                          height: screenHeight(context)/13,
                          width: screenWidth(context)/2.3,
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
                                  child: image != null ? Image.file(File(image!.path)) : OutlinedButton(
                                      onPressed: (){
                                        pickImage(ImageSource.gallery);

                                      },
                                      child: Icon(
                                        Icons.add,
                                        size: screenHeight(context)/13,
                                        color: AppColors.grey,
                                      ),
                                    style: OutlinedButton.styleFrom(
                                          primary: Colors.white,
                                         backgroundColor: AppColors.primary,
                                           shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                                          side: const BorderSide(color: AppColors.white, width: 1),
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
                              height: screenHeight(context)/7.25,
                              width: screenHeight(context)/7.25,
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
                        Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.fromLTRB(0, 0, 0, 11),
                                child: OutlinedButton(
                                  child: Icon(
                                    Icons.attach_file,
                                    size: screenHeight(context)/13,
                                    color: AppColors.grey,
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    primary: Colors.white,
                                    backgroundColor: AppColors.primary,
                                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                                    side: const BorderSide(color: AppColors.white, width: 1),
                                  ),
                                  onPressed: () {
                                    print('Pressed');
                                  },
                                ),
                                //decoration: ButtonStylingAlter.lsButton,
                                height: screenHeight(context)/7.25,
                                width: screenHeight(context)/7.25,
                              ),
                              Container(
                                //color: AppColors.secondaryDark,
                                child: Text(
                                  'Attach File',
                                  style: createPostStyleSecondary,
                                ),
                              ),
                            ]
                        )

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
                          height: screenHeight(context)/12,
                          width: screenWidth(context)/1.14,
                          child: TextFormField(
                            onChanged: (text){
                              caption = text;
                            },
                            style: lsInputTextStyle,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: const BorderSide(
                                    color: AppColors.white,
                                    width: 1,
                                  )
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: const BorderSide(
                                    color: AppColors.white,
                                    width: 1,
                                  )
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                  color: AppColors.white,
                                  width: 1,
                                ),
                              ),
                              errorStyle: lsErrorTextStyle,
                              label: Container(
                                width: 100,
                                child: const Text('Write a caption...', style: TextStyle(color: AppColors.grey),),
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
                            onSaved: (value) {

                            },
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
                          height: screenHeight(context)/12,
                          width: screenWidth(context)/1.14,
                          child: TextFormField(
                            onChanged: (text){
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
                                  )
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: const BorderSide(
                                    color: AppColors.white,
                                    width: 1,
                                  )
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                  color: AppColors.white,
                                  width: 1,
                                ),
                              ),
                              errorStyle: lsErrorTextStyle,
                              label: Container(
                                width: 100,
                                child: const Text('Add Location', style: TextStyle(color: AppColors.grey),),
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
                            onSaved: (value) {

                            },
                          ),
                        )

                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.fromLTRB(11,0,11,0),
                          //color: AppColors.secondaryDark,
                          child: Text(
                            'Select a topic',
                            style: createPostStyleSecondary,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.fromLTRB(0,5,0,11),
                          height: screenHeight(context)/24,
                          width: screenWidth(context)/1.14,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: topicList.length,
                            separatorBuilder: (context, _) => SizedBox(width: 12),
                            itemBuilder: (context, index) => topicswidget(number: index),
                          ),
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
                  height: screenHeight(context)/4,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 11),
                      child: OutlinedButton(
                          onPressed: () async {
                            logCustomEvent(
                                widget.analytics, 'attempted to create post');
                            showToast('Creating post, please wait...');
                            await finalInfo();
                            //.pushNamed(context, '/profilepage');

                            //setState(() {});
                            //Navigator.pushNamed(context, '/profilepage');
                          },
                          child: Text(
                            'Create',
                            style: GoogleFonts.nunito(
                              fontSize: 25,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                color: Color(0x00000000),
                              )
                          )
                      ),
                      decoration: CreateButtonStyling.lsButton,
                      height: 50,
                      width: screenWidth(context)/2.5,
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 11),
                      child: OutlinedButton(
                          onPressed: () async{
                            logCustomEvent(
                                widget.analytics, 'attempted to cancel post');
                            //Navigator.pushNamed(context, '/profilepage');
                            //setState(() {});
                            //Navigator.pushNamed(context, '/profilepage');
                            SharedPreferences? prefs = await SharedPreferences.getInstance();
                            prefs!.setStringList('topicsSel', []);
                          },
                          child: Text(
                            'Cancel',
                            style: GoogleFonts.nunito(
                              fontSize: 25,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                color: Color(0x00000000),
                              )
                          )
                      ),
                      decoration: CancelButtonStyling.lsButton,
                      height: 50,
                      width: screenWidth(context)/2.5,
                    ),

                  ],
                ),
                //  ),
              ],
              //),
            ),
          ),
        ),
      ),
    );
  }
}
