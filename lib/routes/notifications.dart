import 'dart:io' show Platform;
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lightbulb/analytics.dart';
import 'package:lightbulb/routes/welcome.dart';
import 'package:lightbulb/util/colors.dart';
import 'package:lightbulb/util/dimensions.dart';
import 'package:lightbulb/util/screen_sizes.dart';
import 'package:lightbulb/util/styles.dart';
import 'package:lightbulb/util/button_styling.dart';
import 'package:lightbulb/util/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/classes.dart';
import '../ui/post_card.dart';
import '../util/db.dart';
//import '..lib//Post.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage(
      {Key? key, required this.analytics, required this.observer})
      : super(key: key);

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  _NotificationsPageState createState() => _NotificationsPageState();

  static const String routeName = '/notification';
}

class _NotificationsPageState extends State<NotificationsPage> {
  final AuthService _auth = AuthService();
  DBService db = DBService();

  void showToast(String message, Toast t) => Fluttertoast.showToast(
        toastLength: t,
        msg: message,
        fontSize: 18.0,
      );

  bool InVisUser = false;
  Future ifInVis() async {
    SharedPreferences? prefs = await SharedPreferences.getInstance();
    String? vu = await prefs!.getString('VisUser');
    if (vu != "") {
      InVisUser = true;
    }
  }

  Future delFollowersList(bool dontPOP) async {
    SharedPreferences? prefs = await SharedPreferences.getInstance();
    if (InVisUser == false) {
      await prefs!.setStringList('followers', []);
    } else {
      await prefs!.setStringList('Vfollowers', []);
    }
    if (dontPOP == false) {
      Navigator.pop(context);
    }
  }

  List<notifications> notifs = [];
  Future getNotificationsList() async {
    SharedPreferences? prefs = await SharedPreferences.getInstance();
    String? cuID = await prefs!.getString('userID');
    QuerySnapshot n = await FirebaseFirestore.instance
        .collection('users')
        .doc(cuID)
        .collection('notifications')
        .get();
    for (int i = 0; i < n.docs.length; i++) {
      if (n.docs[i]["token"] != 'dummy' &&
          check(notifs, n.docs[i]["token"]) == false) {
        notifs.add(notifications(
            name: n.docs[i]['name'],
            username: n.docs[i]['username'],
            image: n.docs[i]['image'],
            token1: n.docs[i]['token'],
            content: n.docs[i]['content'],
            type: n.docs[i]['type']));
      }
    }
  }

  bool check(List<notifications> l, String item) {
    for (int i = 0; i < l.length; i++) {
      if (l[i].token1 == item) {
        return true;
      }
    }
    return false;
  }

  Future onRemoveFromFollower(String id) async {
    SharedPreferences? prefs = await SharedPreferences.getInstance();
    String? cuID = prefs!.getString('userID');
    QuerySnapshot u =
        await FirebaseFirestore.instance.collection('users').get();
    List<dynamic> newFollowingListAgain = [];
    for (int j = 0; j < u.docs.length; j++) {
      if (u.docs[j]["token1"] == id) {
        for (int k = 0; k < u.docs[j]["followingList"].length; k++) {
          if (u.docs[j]["followingList"][k] != cuID) {
            newFollowingListAgain.add(u.docs[j]["followingList"][k]);
          }
        }
        await prefs!
            .setStringList('Vfollowings', newFollowingListAgain.cast<String>());
        await db.addUser(
            u.docs[j]["state"],
            u.docs[j]["email"],
            u.docs[j]["bio"],
            u.docs[j]["posts"],
            u.docs[j]["profpic"],
            u.docs[j]["followReq"],
            newFollowingListAgain,
            u.docs[j]["followersList"],
            u.docs[j]["name"],
            u.docs[j]["username"],
            u.docs[j]["password"],
            u.docs[j]["sentReq"],
            u.docs[j]["token1"],
            'caption',
            [],
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
    List<dynamic> newFollowersListAgain = [];
    for (int j = 0; j < u.docs.length; j++) {
      if (u.docs[j]["token1"] == cuID) {
        for (int k = 0; k < u.docs[j]["followersList"].length; k++) {
          if (u.docs[j]["followersList"][k] != id) {
            newFollowersListAgain.add(u.docs[j]["followersList"][k]);
          }
        }
        await prefs!
            .setStringList('followers', newFollowersListAgain.cast<String>());
        await db.addUser(
            u.docs[j]["state"],
            u.docs[j]["email"],
            u.docs[j]["bio"],
            u.docs[j]["posts"],
            u.docs[j]["profpic"],
            u.docs[j]["followReq"],
            u.docs[j]["followingList"],
            newFollowersListAgain,
            u.docs[j]["name"],
            u.docs[j]["username"],
            u.docs[j]["password"],
            u.docs[j]["sentReq"],
            u.docs[j]["token1"],
            'caption',
            [],
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

  Future onRemoveFromFollowing(String id) async {
    SharedPreferences? prefs = await SharedPreferences.getInstance();
    String? cuID = prefs!.getString('userID');
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
        await prefs!
            .setStringList('followings', newFollowingList.cast<String>());
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
            [],
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
    List<dynamic> newFollowersList = [];
    for (int j = 0; j < u.docs.length; j++) {
      if (u.docs[j]["token1"] == id) {
        for (int k = 0; k < u.docs[j]["followersList"].length; k++) {
          if (u.docs[j]["followersList"][k] != cuID) {
            newFollowersList.add(u.docs[j]["followersList"][k]);
          }
        }
        await prefs!
            .setStringList('Vfollowers', newFollowersList.cast<String>());
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
            [],
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

  Future onAccept1(String id) async {
    SharedPreferences? prefs = await SharedPreferences.getInstance();
    String? cuID = await prefs!.getString('userID');
    QuerySnapshot u =
        await FirebaseFirestore.instance.collection('users').get();
    List<dynamic> newFollowingList = [];
    for (int j = 0; j < u.docs.length; j++) {
      if (u.docs[j]["token1"] == id) {
        for (int k = 0; k < u.docs[j]["followingList"].length; k++) {
          newFollowingList.add(u.docs[j]["followingList"][k]);
        }
        newFollowingList.add(cuID);
        await db.addNoti(
            u.docs[j]["name"],
            u.docs[j]["username"],
            u.docs[j]["profpic"],
            u.docs[j]["token1"],
            "${u.docs[j]["name"]} started following you.",
            "followingYou",
            cuID);
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
            [],
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
        //await prefs!.setString('situation', "F");
      }
    }
    List<dynamic> newFollowersList = [];
    for (int j = 0; j < u.docs.length; j++) {
      if (u.docs[j]["token1"] == cuID) {
        for (int k = 0; k < u.docs[j]["followersList"].length; k++) {
          newFollowersList.add(u.docs[j]["followersList"][k]);
        }
        newFollowersList.add(id);
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
            [],
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

    await onAccept2(id);
  }

  Future onAccept2(String id) async {
    SharedPreferences? prefs = await SharedPreferences.getInstance();
    String? cuID = await prefs!.getString('userID');
    QuerySnapshot u =
        await FirebaseFirestore.instance.collection('users').get();

    List<dynamic> newSentReq = [];
    for (int j = 0; j < u.docs.length; j++) {
      if (u.docs[j]["token1"] == id) {
        for (int k = 0; k < u.docs[j]["sentReq"].length; k++) {
          if (u.docs[j]["sentReq"][k] != cuID) {
            newSentReq.add(u.docs[j]["sentReq"][k]);
          }
        }
        QuerySnapshot n = await FirebaseFirestore.instance
            .collection('users')
            .doc(cuID)
            .collection('notifications')
            .get();
        for (int x = 0; x < n.docs.length; x++) {
          if (n.docs[x]["type"] == "followRequest") {
            await FirebaseFirestore.instance
                .collection('users')
                .doc(id)
                .collection('notifications')
                .doc(u.docs[j]["token1"])
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
            [],
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
        //await prefs!.setString('situation', "NotF");
      }
    }

    List<dynamic> newFollowReq = [];
    for (int j = 0; j < u.docs.length; j++) {
      if (u.docs[j]["token1"] == cuID) {
        for (int k = 0; k < u.docs[j]["followReq"].length; k++) {
          if (u.docs[j]["followReq"][k] != id) {
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
            [],
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

  Future onDeny(String id) async {
    SharedPreferences? prefs = await SharedPreferences.getInstance();
    String? cuID = await prefs!.getString('userID');
    QuerySnapshot u =
        await FirebaseFirestore.instance.collection('users').get();
    List<dynamic> newSentReq = [];
    for (int j = 0; j < u.docs.length; j++) {
      if (u.docs[j]["token1"] == id) {
        for (int k = 0; k < u.docs[j]["sentReq"].length; k++) {
          if (u.docs[j]["sentReq"][k] != cuID) {
            newSentReq.add(u.docs[j]["sentReq"][k]);
          }
        }
        QuerySnapshot n = await FirebaseFirestore.instance
            .collection('users')
            .doc(cuID)
            .collection('notifications')
            .get();
        for (int x = 0; x < n.docs.length; x++) {
          if (n.docs[x]["type"] == "followRequest") {
            await FirebaseFirestore.instance
                .collection('users')
                .doc(cuID)
                .collection('notifications')
                .doc(u.docs[j]["token1"])
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
            [],
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
        //await prefs!.setString('situation', "NotF");
      }
    }
    List<dynamic> newFollowReq = [];
    for (int j = 0; j < u.docs.length; j++) {
      if (u.docs[j]["token1"] == cuID) {
        for (int k = 0; k < u.docs[j]["followReq"].length; k++) {
          if (u.docs[j]["followReq"][k] != id) {
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
            [],
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

  Widget widg(notifications u) {
    if (u.type == "followRequest") {
      return Row(
        children: [
          Container(
            child: OutlinedButton(
                onPressed: () async {
                  await onAccept1(u.token1);
                  logCustomEvent(widget.analytics, 'accept req button tapped');
                  //await delFollowersList(true);
                  showToast('Follow request accepted.', Toast.LENGTH_SHORT);
                  setState(() {});
                },
                child: Icon(
                  Icons.check,
                  color: AppColors.primary,
                ),
                style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                  color: Color(0x00000000),
                ))),
            decoration: ButtonStyling.lsButton,
            height: screenHeight(context) / 21.1,
            width: screenWidth(context) / 2.5,
          ),
          SizedBox(
            width: 5,
          ),
          Container(
            child: OutlinedButton(
                onPressed: () async {
                  await onDeny(u.token1);
                  logCustomEvent(
                      widget.analytics, 'unfollow profile button tapped');
                  showToast('Follow request denied.', Toast.LENGTH_SHORT);
                  setState(() {});
                },
                child: Icon(
                  Icons.close,
                  color: AppColors.primary,
                ),
                style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                  color: Color(0x00000000),
                ))),
            decoration: ButtonStylingAlter.lsButton,
            height: screenHeight(context) / 21.1,
            width: screenWidth(context) / 2.5,
          ),
        ],
      );
    }
    return Container(
      height: screenHeight(context) / 21.1,
      width: screenWidth(context) / 2.5,
    );
  }

  Widget listBuilder({required int number}) =>

      // Container(
      //  height: screenWidth(context)/6,
      //  color: AppColors.grey,
      //  child:
      Container(
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.grey),
          borderRadius: BorderRadius.circular(15.0),
        ),
        //color: AppColors.primary,
        margin: const EdgeInsets.all(2),
        child: Padding(
          padding: const EdgeInsets.all(13.0),
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: screenHeight(context) / 40,
                        backgroundColor: AppColors.secondaryDark,
                        child: ClipOval(
                          child: Image.network(
                            notifs[number].image,
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.end,
                        //crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            notifs[number].name,
                            style: GoogleFonts.nunito(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: AppColors.white,
                            ),
                          ),
                          SizedBox(width: 4),
                          Text(
                            notifs[number].username,
                            style: GoogleFonts.nunito(
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              color: AppColors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 9,
                  ),
                  Container(
                    child: Row(
                      children: [
                        SizedBox(
                          width: 7,
                        ),
                        Text(
                          notifs[number].content,
                          style: GoogleFonts.nunito(
                            fontSize: 17,
                            fontWeight: FontWeight.w900,
                            color: AppColors.primaryLightest,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 9,
                  ),
                ],
              ),
              widg(notifs[number]),
            ],
          ),
        ),
      );
  // );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications",
            style: GoogleFonts.nunito(
              color: AppColors.primary,
              fontWeight: FontWeight.w900,
              fontSize: 30.0,
            )),
        centerTitle: true,
        backgroundColor: AppColors.secondaryDark,
        elevation: 1,
      ),
      backgroundColor: AppColors.primary,
      body: Container(
        padding: const EdgeInsets.only(left: 16, top: 25, right: 16),
        child: ListView(
          children: [
            Row(
              children: [
                const Icon(
                  Icons.notifications,
                  color: AppColors.white,
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  "My notifications",
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondaryDark,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            FutureBuilder(
                future: getNotificationsList(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            //color: AppColors.white,
                            margin: const EdgeInsets.fromLTRB(0, 5, 0, 11),
                            height: screenHeight(context) / 1.4,
                            width: screenWidth(context) / 1,
                            child: ListView.separated(
                              scrollDirection: Axis.vertical,
                              itemCount: notifs.length,
                              separatorBuilder: (context, _) =>
                                  SizedBox(height: 6),
                              itemBuilder: (context, index) =>
                                  listBuilder(number: index),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
