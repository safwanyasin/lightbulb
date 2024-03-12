import 'dart:io' show Platform;

import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lightbulb/routes/edit_profile.dart';
import 'package:lightbulb/ui/post.dart';
import 'package:lightbulb/ui/post_card.dart';
import 'package:lightbulb/util/colors.dart';
import 'package:lightbulb/util/styles.dart';
import 'package:lightbulb/util/screen_sizes.dart';
import 'package:lightbulb/util/button_styling.dart';
import 'package:lightbulb/routes/settings.dart';
import 'package:lightbulb/util/create_material_color.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../analytics.dart';
import '../model/classes.dart';
import '../ui/prof_post.dart';
import '../util/db.dart';
//import '../ui/post_card.dart';

class VisitedProfilePage extends StatefulWidget {
  const VisitedProfilePage(
      {Key? key, required this.analytics, required this.observer})
      : super(key: key);

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  State<VisitedProfilePage> createState() => _VisitedProfilePageState();
  static const String routeName = '/visitedprofilepage';
}

class _VisitedProfilePageState extends State<VisitedProfilePage> {
  @override
  initState() {
    super.initState();
    setCurrentScreen(
        widget.analytics, 'Visited Profile Page', 'visitedprofilePage');
  }

  DBService db = DBService();

  List<Post> posts = [
    Post(
        title: 'Hello World 1',
        hashtag: 'sfsdg',
        image:
            'https://static.birgun.net/resim/haber-detay-resim/2021/02/25/erzurum-oyununun-yapimcisi-oyun-begenilmeyince-hakaretler-yagdirdi-845533-5.jpg'),
    Post(
        title: 'Hello World 2',
        hashtag: 'sfsdg',
        image:
            'https://pixnio.com/free-images/2019/07/24/2019-07-24-05-25-19-550x309.jpg'),
    Post(
        title: 'Hello World 3',
        hashtag: 'sfsdg',
        image:
            'https://pixnio.com/free-images/2018/12/11/2018-12-11-12-39-11-550x365.jpg')
  ];

  List<String?> userTokens = [];
  List<String> postTokens = [];
  int postT = 0;

  Future getPostTokens() async {
    SharedPreferences? prefs = await SharedPreferences.getInstance();
    String? cuID = prefs!.getString('userID');
    //print("idx give: $idx");
    QuerySnapshot querySnapshotPost = await FirebaseFirestore.instance
        .collection('users')
        .doc(cuID)
        .collection('posts')
        .get();
    postT = querySnapshotPost.docs.length - 1;
    userTokens.add(cuID);
    return;
  }

  List<User> visitedUser = [
    //User(Name: 'Name', TempUsername: 'TempUsername', pass: 'pass', bio: 'bio', followReq: ["dummy" , "dummy"], followersList: ["dummy" , "dummy"], followingList: ["dummy" , "dummy"], sentReq: ["dummy" , "dummy"], location: 'location', profilepic: 'https://www.tenforums.com/geek/gars/images/2/types/thumb_15951118880user.png', token: 'token', state: true, Email: 'Email', post1: [Post1(caption: 'caption', topics: ["dummy" , "dummy"], image: 'image', likes: 0, comments: 0, token: 'token')])
  ];
  //List<>User currentUser = User(Name: 'Name', TempUsername: 'TempUsername', pass: 'pass', bio: 'bio', followReq: ["dummy" , "dummy"], followersList: ["dummy" , "dummy"], followingList: ["dummy" , "dummy"], sentReq: ["dummy" , "dummy"], location: 'location', profilepic: 'https://www.tenforums.com/geek/gars/images/2/types/thumb_15951118880user.png', token: 'token', state: true, Email: 'Email', post1: [Post1(caption: 'caption', topics: ["dummy" , "dummy"], image: 'image', likes: 0, comments: 0, token: 'token')]);
  bool state = true;
  String name = '';
  String username = '';
  String profpic = '';
  String pass = '';
  String email = '';
  int postsnum = 0;
  int followers = 0;
  int following = 0;
  String bio = '';
  String location = '';
  List<dynamic> followersList = ["dummy", "dummy"];
  List<dynamic> followingList = ["dummy", "dummy"];
  List<dynamic> followReq = ["dummy", "dummy"];
  List<dynamic> sentReq = ["dummy", "dummy"];
  String token1 = '';

  String caption = '';
  int comments = 0;
  String image = '';
  int likes = 0;
  String token = '';
  List<dynamic> topics = [];

  Future getUsers() async {
    //print("hiiii");
    SharedPreferences? prefs = await SharedPreferences.getInstance();
    String? id = await prefs!.getString('VisUser');
    visitedUser.clear();
    List<Post1> UserPosts = [];
    QuerySnapshot querySnapshotPost = await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .collection('posts')
        .get();
    QuerySnapshot querySnapshotUsers =
        await FirebaseFirestore.instance.collection('users').get();
    for (int j = 0; j < querySnapshotPost.docs.length; j++) {
      //print("hi");
      //if(querySnapshotPost.docs[j]["token"] != "post0") {
      if (querySnapshotPost.docs[j]["token"] != "postToken") {
        caption = querySnapshotPost.docs[j]["caption"];
        comments = querySnapshotPost.docs[j]["comments"];
        image = querySnapshotPost.docs[j]["image"];
        likes = querySnapshotPost.docs[j]["likes"];
        location = querySnapshotPost.docs[j]["location"];
        token = querySnapshotPost.docs[j]["token"];
        topics = querySnapshotPost.docs[j]["topics"];

        if (checkPost(UserPosts, token) == false &&
            querySnapshotPost.docs[j]["token"] != "post0") {
          // print("here");
          UserPosts.add(Post1(
              caption: caption,
              topics: topics,
              image: image,
              likes: likes,
              comments: comments,
              token: token));
          //print(UserPosts.length);
        }
      }
      //print(UserPosts.length);
      // }
    }
    for (int k = 0; k < querySnapshotUsers.docs.length; k++) {
      if (querySnapshotUsers.docs[k]["token1"] == id) {
        state = querySnapshotUsers.docs[k]["state"];
        name = querySnapshotUsers.docs[k]["name"];
        username = querySnapshotUsers.docs[k]["username"];
        profpic = querySnapshotUsers.docs[k]["profpic"];
        pass = querySnapshotUsers.docs[k]["password"];
        email = querySnapshotUsers.docs[k]["email"];
        postsnum = querySnapshotUsers.docs[k]["posts"];
        //followers = querySnapshotUser.docs[i]["followersList"].length;
        // following = querySnapshotUser.docs[i]["followingList"].length;
        followersList = querySnapshotUsers.docs[k]["followersList"];
        followingList = querySnapshotUsers.docs[k]["followingList"];
        followReq = querySnapshotUsers.docs[k]["followReq"];
        sentReq = querySnapshotUsers.docs[k]["sentReq"];
        bio = querySnapshotUsers.docs[k]["bio"];
        location = querySnapshotUsers.docs[k]["location"];
        token1 = querySnapshotUsers.docs[k]["token1"];
        if (checkUser(visitedUser, token1) == false) {
          visitedUser.add(User(
              Name: name,
              TempUsername: username,
              pass: pass,
              bio: bio,
              followReq: followReq,
              followersList: followersList,
              followingList: followingList,
              sentReq: sentReq,
              location: location,
              profilepic: profpic,
              token: token1,
              state: state,
              Email: email,
              post1: UserPosts));
          // print(currentUser[0].TempUsername);
        }
      }
    }
    //}
    //UserPosts.clear();
    //}
    //print(tempusers.length);
  }

  bool checkUser(List<User> l, String item) {
    for (int i = 0; i < l.length; i++) {
      if (l[i].token == item) return true;
    }
    return false;
  }

  bool checkPost(List<Post1> l, String item) {
    for (int i = 0; i < l.length; i++) {
      //print(l[i].token);
      if (l[i].token == item) return true;
    }
    return false;
  }

  Future ref() async {
    await getUsers();
    setState(() {});
  }

  Future updateVisUser(BuildContext context) async {
    SharedPreferences? prefs = await SharedPreferences.getInstance();
    await prefs!.setString('VisUser', "");
    Navigator.pop(context);
  }

  void showToast(String message, Toast t) => Fluttertoast.showToast(
        toastLength: t,
        msg: message,
        fontSize: 18.0,
      );

  String iF = "";
  Future status() async {
    SharedPreferences? prefs = await SharedPreferences.getInstance();
    String? situation = await prefs!.getString('situation');
    if (situation == "NotF") {
      iF = "NotF";
    }
    if (situation == "F") {
      iF = "F";
    }
    if (situation == "ReqSent") {
      iF = "ReqSent";
    }
  }

  Future onCancel() async {
    SharedPreferences? prefs = await SharedPreferences.getInstance();
    String? cuID = await prefs!.getString('userID');
    String? id = await prefs!.getString('VisUser');
    QuerySnapshot u =
        await FirebaseFirestore.instance.collection('users').get();
    List<dynamic> newSentReq = [];
    for (int j = 0; j < u.docs.length; j++) {
      if (u.docs[j]["token1"] == cuID) {
        for (int k = 0; k < u.docs[j]["sentReq"].length; k++) {
          if (u.docs[j]["sentReq"][k] != id) {
            newSentReq.add(u.docs[j]["sentReq"][k]);
          }
        }
        QuerySnapshot n = await FirebaseFirestore.instance
            .collection('users')
            .doc(id)
            .collection('notifications')
            .get();
        for (int x = 0; x < n.docs.length; x++) {
          if (n.docs[x]["type"] == "followRequest") {
            await FirebaseFirestore.instance
                .collection('users')
                .doc(id)
                .collection('notifications')
                .doc(cuID)
                .delete();
          }
        }
        await db.addUser(
            u.docs[j]["state"],
            u.docs[j]["email"],
            u.docs[j]["bio"],
            u.docs[j]["posts"],
            u.docs[j]["profpic"],
            u.docs[j]["followReq"],
            u.docs[j]["followingList"],
            u.docs[j]["followersList"],
            u.docs[j]["name"],
            u.docs[j]["username"],
            u.docs[j]["password"],
            newSentReq,
            u.docs[j]["token1"],
            'caption',
            topics,
            'image',
            0,
            0,
            'location',
            'post0',
            'notiContent',
            'notiSender',
            'notiToken',
            u.docs[j]["notifsList"],
            'notThis');
        await prefs!.setString('situation', "NotF");
      }
    }
    List<dynamic> newFollowReq = [];
    for (int j = 0; j < u.docs.length; j++) {
      if (u.docs[j]["token1"] == id) {
        for (int k = 0; k < u.docs[j]["followReq"].length; k++) {
          if (u.docs[j]["followReq"][k] != cuID) {
            newFollowReq.add(u.docs[j]["followReq"][k]);
          }
        }
        await db.addUser(
            u.docs[j]["state"],
            u.docs[j]["email"],
            u.docs[j]["bio"],
            u.docs[j]["posts"],
            u.docs[j]["profpic"],
            newFollowReq,
            u.docs[j]["followingList"],
            u.docs[j]["followersList"],
            u.docs[j]["name"],
            u.docs[j]["username"],
            u.docs[j]["password"],
            u.docs[j]["sentReq"],
            u.docs[j]["token1"],
            'caption',
            topics,
            'image',
            0,
            0,
            'location',
            'post0',
            'notiContent',
            'notiSender',
            'notiToken',
            u.docs[j]["notifsList"],
            'notThis');
      }
    }
    setState(() {});
  }

  Future onUnFollow() async {
    SharedPreferences? prefs = await SharedPreferences.getInstance();
    String? cuID = await prefs!.getString('userID');
    String? id = await prefs!.getString('VisUser');
    QuerySnapshot u =
        await FirebaseFirestore.instance.collection('users').get();
    List<dynamic> newFollowingList = [];
    for (int j = 0; j < u.docs.length; j++) {
      if (u.docs[j]["token1"] == cuID) {
        for (int k = 0; k < u.docs[j]["followingList"].length; k++) {
          if (u.docs[j]["followingList"][k] != id) {
            newFollowingList.add(u.docs[j]["followingList"][k]);
          }
        }
        QuerySnapshot n = await FirebaseFirestore.instance
            .collection('users')
            .doc(id)
            .collection('notifications')
            .get();
        for (int x = 0; x < n.docs.length; x++) {
          if (n.docs[x]["type"] == "followingYou") {
            await FirebaseFirestore.instance
                .collection('users')
                .doc(id)
                .collection('notifications')
                .doc(id)
                .delete();
          }
        }
        await db.addUser(
            u.docs[j]["state"],
            u.docs[j]["email"],
            u.docs[j]["bio"],
            u.docs[j]["posts"],
            u.docs[j]["profpic"],
            u.docs[j]["followReq"],
            newFollowingList,
            u.docs[j]["followersList"],
            u.docs[j]["name"],
            u.docs[j]["username"],
            u.docs[j]["password"],
            u.docs[j]["sentReq"],
            u.docs[j]["token1"],
            'caption',
            topics,
            'image',
            0,
            0,
            'location',
            'post0',
            'notiContent',
            'notiSender',
            'notiToken',
            u.docs[j]["notifsList"],
            'notThis');
        await prefs!.setString('situation', "NotF");
      }
    }
    List<dynamic> newFollowersList = [];
    for (int j = 0; j < u.docs.length; j++) {
      if (u.docs[j]["token1"] == id) {
        for (int k = 0; k < u.docs[j]["followersList"].length; k++) {
          if (u.docs[j]["followersList"][k] != cuID) {
            newFollowersList.add(u.docs[j]["followersList"][k]);
          }
        }
        await db.addUser(
            u.docs[j]["state"],
            u.docs[j]["email"],
            u.docs[j]["bio"],
            u.docs[j]["posts"],
            u.docs[j]["profpic"],
            u.docs[j]["followReq"],
            u.docs[j]["followingList"],
            newFollowersList,
            u.docs[j]["name"],
            u.docs[j]["username"],
            u.docs[j]["password"],
            u.docs[j]["sentReq"],
            u.docs[j]["token1"],
            'caption',
            topics,
            'image',
            0,
            0,
            'location',
            'post0',
            'notiContent',
            'notiSender',
            'notiToken',
            u.docs[j]["notifsList"],
            'notThis');
      }
    }
    setState(() {});
  }

  Future followClicked() async {
    SharedPreferences? prefs = await SharedPreferences.getInstance();
    String? cuID = await prefs!.getString('userID');
    String? id = await prefs!.getString('VisUser');
    QuerySnapshot u =
        await FirebaseFirestore.instance.collection('users').get();
    for (int i = 0; i < u.docs.length; i++) {
      if (u.docs[i]["token1"] == id) {
        if (u.docs[i]['state'] == false) {
          List<dynamic> newSentReq = [];
          for (int j = 0; j < u.docs.length; j++) {
            if (u.docs[j]["token1"] == cuID) {
              for (int k = 0; k < u.docs[j]["sentReq"].length; k++) {
                newSentReq.add(u.docs[j]["sentReq"][k]);
              }
              // for(int l = 0; l <  u.docs[i]["notifsList"].length; l++){
              //  newSRNotif.add(u.docs[i]["notifsList"][l]);
              //}
              //newSRNotif.add(notifications(name: u.docs[j]["name"], username:  u.docs[j]["username"], image: u.docs[j]["profpic"], token1: u.docs[j]["token1"], content: "${u.docs[j]["name"]} sent you a follow request.", type: 'followRequest'));
              newSentReq.add(id);
              await db.addNoti(
                  u.docs[j]["name"],
                  u.docs[j]["username"],
                  u.docs[j]["profpic"],
                  u.docs[j]["token1"],
                  "${u.docs[j]["name"]} sent you a follow request.",
                  "followRequest",
                  u.docs[i]["token1"]);
              await db.addUser(
                  u.docs[j]["state"],
                  u.docs[j]["email"],
                  u.docs[j]["bio"],
                  u.docs[j]["posts"],
                  u.docs[j]["profpic"],
                  u.docs[j]["followReq"],
                  u.docs[j]["followingList"],
                  u.docs[j]["followersList"],
                  u.docs[j]["name"],
                  u.docs[j]["username"],
                  u.docs[j]["password"],
                  newSentReq,
                  u.docs[j]["token1"],
                  'caption',
                  topics,
                  'image',
                  0,
                  0,
                  'location',
                  'post0',
                  'notiContent',
                  'notiSender',
                  'notiToken',
                  u.docs[j]["notifsList"],
                  'notThis');
              await prefs!.setString('situation', "ReqSent");
            }
          }
          List<dynamic> newFollowReq = [];
          for (int j = 0; j < u.docs.length; j++) {
            if (u.docs[j]["token1"] == id) {
              for (int k = 0; k < u.docs[j]["followReq"].length; k++) {
                newFollowReq.add(u.docs[j]["followReq"][k]);
              }
              newFollowReq.add(cuID);
              await db.addUser(
                  u.docs[j]["state"],
                  u.docs[j]["email"],
                  u.docs[j]["bio"],
                  u.docs[j]["posts"],
                  u.docs[j]["profpic"],
                  newFollowReq,
                  u.docs[j]["followingList"],
                  u.docs[j]["followersList"],
                  u.docs[j]["name"],
                  u.docs[j]["username"],
                  u.docs[j]["password"],
                  u.docs[j]["sentReq"],
                  u.docs[j]["token1"],
                  'caption',
                  topics,
                  'image',
                  0,
                  0,
                  'location',
                  'post0',
                  'notiContent',
                  'notiSender',
                  'notiToken',
                  u.docs[j]["notifsList"],
                  'notThis');
            }
          }
        }
        if (u.docs[i]['state'] == true) {
          List<dynamic> newFollowingList = [];
          for (int j = 0; j < u.docs.length; j++) {
            if (u.docs[j]["token1"] == cuID) {
              for (int k = 0; k < u.docs[j]["followingList"].length; k++) {
                newFollowingList.add(u.docs[j]["followingList"][k]);
              }
              newFollowingList.add(id);
              await db.addNoti(
                  u.docs[j]["name"],
                  u.docs[j]["username"],
                  u.docs[j]["profpic"],
                  u.docs[j]["token1"],
                  "${u.docs[j]["name"]} started following you.",
                  "followingYou",
                  u.docs[i]["token1"]);
              await db.addUser(
                  u.docs[j]["state"],
                  u.docs[j]["email"],
                  u.docs[j]["bio"],
                  u.docs[j]["posts"],
                  u.docs[j]["profpic"],
                  u.docs[j]["followReq"],
                  newFollowingList,
                  u.docs[j]["followersList"],
                  u.docs[j]["name"],
                  u.docs[j]["username"],
                  u.docs[j]["password"],
                  u.docs[j]["sentReq"],
                  u.docs[j]["token1"],
                  'caption',
                  topics,
                  'image',
                  0,
                  0,
                  'location',
                  'post0',
                  'notiContent',
                  'notiSender',
                  'notiToken',
                  u.docs[j]["notifsList"],
                  'notThis');
              await prefs!.setString('situation', "F");
            }
          }
          List<dynamic> newFollowersList = [];
          for (int j = 0; j < u.docs.length; j++) {
            if (u.docs[j]["token1"] == id) {
              for (int k = 0; k < u.docs[j]["followersList"].length; k++) {
                newFollowersList.add(u.docs[j]["followersList"][k]);
              }
              newFollowersList.add(cuID);
              await db.addUser(
                  u.docs[j]["state"],
                  u.docs[j]["email"],
                  u.docs[j]["bio"],
                  u.docs[j]["posts"],
                  u.docs[j]["profpic"],
                  u.docs[j]["followReq"],
                  u.docs[j]["followingList"],
                  newFollowersList,
                  u.docs[j]["name"],
                  u.docs[j]["username"],
                  u.docs[j]["password"],
                  u.docs[j]["sentReq"],
                  u.docs[j]["token1"],
                  'caption',
                  topics,
                  'image',
                  0,
                  0,
                  'location',
                  'post0',
                  'notiContent',
                  'notiSender',
                  'notiToken',
                  u.docs[j]["notifsList"],
                  'notThis');
            }
          }
        }
      }
    }
    setState(() {});
  }

  bool keepPrinting = true;
  int run = 0;

  Widget btn(String isF) {
    if (isF == "F") {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            child: OutlinedButton(
                onPressed: () {
                  logCustomEvent(
                      widget.analytics, 'following profile button tapped');
                },
                child: const Text(
                  'Following',
                  style: lsButtonTextStyle,
                ),
                style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                  color: Color(0x00000000),
                ))),
            decoration: ButtonStyling.lsButton,
            height: screenHeight(context) / 21.1,
            width: screenWidth(context) / 1.5,
          ),
          Container(
            child: OutlinedButton(
                onPressed: () async {
                  await onUnFollow();
                  logCustomEvent(
                      widget.analytics, 'unfollow profile button tapped');
                },
                child: Icon(
                  Icons.person_remove,
                  color: AppColors.primary,
                ),
                style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                  color: Color(0x00000000),
                ))),
            decoration: ButtonStyling.lsButton,
            height: screenHeight(context) / 21.1,
          ),
        ],
      );
    }
    if (iF == "ReqSent") {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            child: OutlinedButton(
                onPressed: () {
                  logCustomEvent(
                      widget.analytics, 'request sent profile button tapped');
                },
                child: const Text(
                  'Request sent',
                  style: lsButtonTextStyle,
                ),
                style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                  color: Color(0x00000000),
                ))),
            decoration: ButtonStyling.lsButton,
            height: screenHeight(context) / 21.1,
            width: screenWidth(context) / 1.5,
          ),
          Container(
            child: OutlinedButton(
                onPressed: () async {
                  await onCancel();
                  logCustomEvent(
                      widget.analytics, 'cancel profile button tapped');
                },
                child: Icon(
                  Icons.cancel,
                  color: AppColors.primary,
                ),
                style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                  color: Color(0x00000000),
                ))),
            decoration: ButtonStyling.lsButton,
            height: screenHeight(context) / 21.1,
          ),
        ],
      );
    }
    return Container(
      child: OutlinedButton(
          onPressed: () async {
            await followClicked();
            logCustomEvent(widget.analytics, 'follow profile button tapped');
          },
          child: const Text(
            'Follow',
            style: lsButtonTextStyle,
          ),
          style: OutlinedButton.styleFrom(
              side: const BorderSide(
            color: Color(0x00000000),
          ))),
      decoration: ButtonStyling.lsButton,
      height: screenHeight(context) / 21.1,
    );
  }

  Future onFollowersClick() async {
    // id = currentUser[0].token;
    SharedPreferences? prefs = await SharedPreferences.getInstance();
    //QuerySnapshot u = await FirebaseFirestore.instance.collection('users').get();
    //for(int h = 0; h < visitedUser[0].followersList.length; h++) {
    // for (int i = 0; i < u.docs.length; i++) {
    // if (u.docs[i]["token1"] == visitedUser[0].followersList[h]) {
    //List<String> l = visitedUser[0].followersList.cast<String>();
    await prefs!.setStringList(
        'Vfollowers', visitedUser[0].followersList.cast<String>());
    // }
    // }
    // }
    Navigator.pushNamed(context, '/followers');
  }

  Future onFollowingClick() async {
    // id = currentUser[0].token;
    SharedPreferences? prefs = await SharedPreferences.getInstance();
    // QuerySnapshot u = await FirebaseFirestore.instance.collection('users').get();
    // for(int h = 0; h < visitedUser[0].followingList.length; h++) {
    // for (int i = 0; i < u.docs.length; i++) {
    //if (u.docs[i]["token1"] == visitedUser[0].followingList[h]) {
    // List<String> l = visitedUser[0].followingList.cast<String>();
    await prefs!.setStringList(
        'Vfollowings', visitedUser[0].followingList.cast<String>());
    //}
    //}
    // }
    Navigator.pushNamed(context, '/following');
  }

  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    // theme: ThemeData(
    //   primarySwatch: createMaterialColor(AppColors.secondaryDark)
    // ),
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        backgroundColor: AppColors.secondaryDark,
        title: FutureBuilder(
            future: getUsers(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                String s = visitedUser[0].Name + "\'s Profile";
                return Text(
                  s,
                  style: navBarHeadingStyle,
                );
              }
              return Text("");
            }),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.primary,
          ),
          onPressed: () async {
            await updateVisUser(context);
          },
        ),
      ),
      body: Stack(children: [
        Padding(
          padding: const EdgeInsets.all(8),
          // child:
          //SingleChildScrollView(
          //child: //SafeArea(
          // child: Padding(
          //  padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // SingleChildScrollView(
                // child:
                Column(
                  children: [
                    // SizedBox(
                    //   height: screenHeight(context)/2
                    // ),
                    RefreshIndicator(
                      onRefresh: ref,
                      backgroundColor: AppColors.secondaryDark,
                      color: AppColors.primary,
                      strokeWidth: 3,
                      child: Container(
                        //color: AppColors.primaryLightest,
                        padding: EdgeInsets.fromLTRB(
                            0, screenHeight(context) / 2.5, 0, 0),
                        height: MediaQuery.of(context).size.height / 1.15,
                        width: MediaQuery.of(context).size.width,

                        child: FutureBuilder(
                          future: getUsers(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return Center(
                                child: ListView.builder(
                                  primary: false,
                                  //physics: ScrollPhysics(),
                                  itemCount: visitedUser.length,
                                  itemBuilder: (context, index) {
                                    if (keepPrinting == true) {
                                      return ListView.builder(
                                        shrinkWrap: true,
                                        primary: false,
                                        //physics: ScrollPhysics(),
                                        itemCount:
                                            visitedUser[index].post1.length,
                                        itemBuilder: (context, idx) {
                                          if (visitedUser[index].state ==
                                                  true ||
                                              iF == "F") {
                                            return ListTile(
                                              title: PostCard(
                                                tempuser: visitedUser[index],
                                                index: idx,
                                                notInVis: false,
                                                isPublic:
                                                    visitedUser[index].state,

                                                // postDocID: "user${idx.toString()}post${index}",
                                                //postDocID: "user${idx.toString()}post${postTokens[index][postTokens[index].length-1]}",
                                                // ),
                                              ),
                                            );
                                          } else {
                                            if (run == 0) {
                                              keepPrinting = false;
                                              run = 1;
                                              return Container(
                                                //color: AppColors.secondaryDark,

                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    3,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: Center(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            16.0),
                                                    child: Text(
                                                      'This user\'s profile is private.',
                                                      style:
                                                          navBarHeadingStyleAlter,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            } else {
                                              return Text('');
                                            }
                                          }
                                        },
                                      );
                                    }
                                    return Container(
                                      // color: AppColors.secondaryDark,
                                      height:
                                          MediaQuery.of(context).size.height /
                                              3,
                                      width: MediaQuery.of(context).size.width,
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Text(
                                            'This user\'s profile is private.',
                                            style: navBarHeadingStyleAlter,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            }
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        ),
                      ),
                    )
                    // Column(
                    //height: screenHeight(context)/1,
                    // width: screenWidth(context)/1,
                    // children:
                    // FutureBuilder(
                    // future: getUserTokens(-1),
                    //builder: (context, snapshot) {
                    //print("hereeeeeeeeeeeeeeeee: ${userTokens.length}");
                    //for(int i = 0; i <= userTokens.length; i++){
                    //return
                    // ListView.builder(
                    // shrinkWrap: true,
                    //itemCount: userTokens.length,
                    // itemBuilder: (context, idx) {
                    // return
                    // Container(
                    // height: MediaQuery.of(context).size.height,
                    // width: MediaQuery.of(context).size.width,
                    // child: ListView.builder(
                    // itemCount: 1,
                    //  itemBuilder: (context, index){
                    //return

                    // },),
                    // ),

                    //}
                    //);
                    //}
                    //return Container();
                    // },)
                    // ),
                  ],
                ),
                // ),
              ],
            ),
          ),

          //Column(
          //children: [
          // Container(
          //height: screenHeight(context)/1.75,
          //width: screenWidth(context)/1.75,
          // child: StreamBuilder<QuerySnapshot>(stream: users, builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          // if(snapshot.hasError){
          //  print('Something went wrong');
          //  return Text('Something went wrong');

          //}

          // if(snapshot.connectionState == ConnectionState.waiting){
          //  print('Loading');
          //  return Text('Loading');

          //  }

          //  final data = snapshot.requireData;

          // return ListView.builder(
          //   itemCount: data.size,
          //    itemBuilder: (context, index){
          //      return Text('username: ${data.docs[index]['username']}');
          //    }
          //  );

          // },),
          //),
          // Column(

          // children: tempusers.map((tempuser) => PostCard(
          //  tempuser: tempuser,
          // delete: (){
          //   deletePost(tempuser);
          // },
          // inclikes: (){
          //  incrementlikes(tempuser);
          // },
          //)).toList(),//posts.map((post) => Postcard(
          //  post: post,
          //  delete: (){
          //    deletePost(post);
          //  },
          // inclikes: (){
          //   incrementlikes(post);
          // },
          //)).toList(),

          //),
          // ],
          //),
          //),
          // ),
          //),
        ),
        Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [
                      AppColors.primary,
                      AppColors.primary,
                      AppColors.primary,
                      AppColors.primary,
                      AppColors.primaryLight,
                      AppColors.primaryLight,
                      AppColors.primaryLight,
                      AppColors.primaryLighter,
                    ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 30.0),
                    child: Column(
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              CircleAvatar(
                                radius: screenHeight(context) / 20,
                                backgroundColor: AppColors.secondaryDark,
                                child: ClipOval(
                                  child: FutureBuilder(
                                      future: getUsers(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.done) {
                                          return Image.network(
                                            visitedUser[0].profilepic,
                                            fit: BoxFit.fitHeight,
                                          );
                                        }
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }),
                                ),
                              )
                            ]),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                              child: FutureBuilder(
                                  future: getUsers(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      return Text(
                                        visitedUser[0].Name,
                                        style: pfpNameStyle,
                                      );
                                    }
                                    return Text("");
                                  }),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: FutureBuilder(
                                  future: getUsers(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      return Text(
                                        visitedUser[0].TempUsername,
                                        style: pfpUserNameStyle,
                                      );
                                    }
                                    return Text("");
                                  }),
                            )
                          ],
                        ),
                        SizedBox(
                          height: screenHeight(context) / 42.2,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: screenWidth(context) / 4.9,
                              decoration: FollowerFollowingStyle.lsButton,
                              child: TextButton(
                                onPressed: () {},
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    FutureBuilder(
                                        future: getUsers(),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.done) {
                                            return Text(
                                              visitedUser[0]
                                                  .post1
                                                  .length
                                                  .toString(),
                                              style: pfpStatsStyle,
                                            );
                                          }
                                          return Text("");
                                        }),
                                    Text(
                                      'Posts',
                                      style: pfpStatsCaptionStyle,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: screenWidth(context) / 4.9,
                              decoration: FollowerFollowingStyle.lsButton,
                              child: TextButton(
                                onPressed: () async {
                                  if (visitedUser[0].state == true ||
                                      iF == "F") {
                                    await onFollowersClick();
                                  } else {
                                    showToast('This user is private.',
                                        Toast.LENGTH_SHORT);
                                  }
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    FutureBuilder(
                                        future: getUsers(),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.done) {
                                            return Text(
                                              visitedUser[0]
                                                  .followersList
                                                  .length
                                                  .toString(),
                                              style: pfpStatsStyle,
                                            );
                                          }
                                          return Text("");
                                        }),
                                    Text(
                                      'Followers',
                                      style: pfpStatsCaptionStyle,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: screenWidth(context) / 4.9,
                              decoration: FollowerFollowingStyle.lsButton,
                              child: TextButton(
                                onPressed: () async {
                                  if (visitedUser[0].state == true ||
                                      iF == "F") {
                                    await onFollowingClick();
                                  } else {
                                    showToast('This user is private.',
                                        Toast.LENGTH_SHORT);
                                  }
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    FutureBuilder(
                                        future: getUsers(),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.done) {
                                            return Text(
                                              visitedUser[0]
                                                  .followingList
                                                  .length
                                                  .toString(),
                                              style: pfpStatsStyle,
                                            );
                                          }
                                          return Text("");
                                        }),
                                    Text(
                                      'Following',
                                      style: pfpStatsCaptionStyle,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            /*const SizedBox(
                          width: 8,
                        ),*/
                          ],
                        ), //345, Posts
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
                              child: FutureBuilder(
                                  future: getUsers(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      return Text(
                                        visitedUser[0].bio,
                                        style: pfpStatsCaptionStyle,
                                      );
                                    }
                                    return Text("");
                                  }),
                            ),
                          ],
                        ), // 'Hopefully CS310 grade boundaries are nice and low.'
                        SizedBox(
                          height: screenHeight(context) / 42.2,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            FutureBuilder(
                                future: status(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    return btn(iF);
                                  }
                                  return Text("");
                                }),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )),
      ]),
      // )
    );
  }
}
