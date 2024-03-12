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
class Followers {
  String name;
  String username;
  String image;
  String token1;
  Followers({
    required this.name,
    required this.username,
    required this.image,
    required this.token1,
  });
}

class FollowersPage extends StatefulWidget {
  const FollowersPage(
      {Key? key, required this.analytics, required this.observer})
      : super(key: key);

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  _FollowersPageState createState() => _FollowersPageState();

  static const String routeName = '/followers';
}

class _FollowersPageState extends State<FollowersPage> {
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

  List<Followers> FollowersL = [];
  Future getFollowersList() async {
    List<String>? followersss = [];
    SharedPreferences? prefs = await SharedPreferences.getInstance();
    QuerySnapshot u =
        await FirebaseFirestore.instance.collection('users').get();
    if (InVisUser == false) {
      followersss = await prefs!.getStringList('followers');
    } else {
      followersss = await prefs!.getStringList('Vfollowers');
    }
    for (int i = 0; i < followersss!.length; i++) {
      for (int j = 0; j < u.docs.length; j++) {
        if (u.docs[j]["token1"] == followersss[i]) {
          FollowersL.add(Followers(
              name: u.docs[j]["name"],
              username: u.docs[j]["username"],
              image: u.docs[j]["profpic"],
              token1: u.docs[j]["token1"]));
        }
      }
    }
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
        QuerySnapshot n = await FirebaseFirestore.instance
            .collection('users')
            .doc(cuID)
            .collection('notifications')
            .get();
        for (int x = 0; x < n.docs.length; x++) {
          if (n.docs[x]["type"] == "followingYou") {
            await FirebaseFirestore.instance
                .collection('users')
                .doc(cuID)
                .collection('notifications')
                .doc(id)
                .delete();
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
    //setState(() {
    //});
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
                .doc(cuID)
                .delete();
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

  Widget widg(Followers u) {
    return FutureBuilder(
        future: ifInVis(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (InVisUser == false) {
              return Container(
                child: OutlinedButton(
                    onPressed: () async {
                      showToast('Removing follower, please wait...',
                          Toast.LENGTH_SHORT);
                      await onRemoveFromFollower(u.token1);
                      await onRemoveFromFollowing(u.token1);
                      logCustomEvent(
                          widget.analytics, 'unfollow profile button tapped');
                      await delFollowersList(true);
                      showToast(
                          'Follower removed! Please scroll down to refresh.',
                          Toast.LENGTH_SHORT);
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.remove,
                      color: AppColors.primary,
                    ),
                    style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                      color: Color(0x00000000),
                    ))),
                decoration: ButtonStyling.lsButton,
                height: screenHeight(context) / 21.1,
              );
            } else {
              return Text("");
            }
          }
          return Text("");
        });
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: screenHeight(context) / 40,
                      backgroundColor: AppColors.secondaryDark,
                      child: ClipOval(
                        child: Image.network(
                          FollowersL[number].image,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Column(
                      // mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          FollowersL[number].name,
                          style: GoogleFonts.nunito(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: AppColors.white,
                          ),
                        ),
                        Text(
                          FollowersL[number].username,
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
              ),
              widg(FollowersL[number]),
            ],
          ),
        ),
      );
  // );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Followers",
            style: GoogleFonts.nunito(
              color: AppColors.primary,
              fontWeight: FontWeight.w900,
              fontSize: 30.0,
            )),
        centerTitle: true,
        backgroundColor: AppColors.secondaryDark,
        elevation: 1,
        leading: IconButton(
          onPressed: () async {
            await delFollowersList(false);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.primary,
          ),
        ),
      ),
      backgroundColor: AppColors.primary,
      body: Container(
        padding: const EdgeInsets.only(left: 16, top: 25, right: 16),
        child: ListView(
          children: [
            Row(
              children: [
                const Icon(
                  Icons.face,
                  color: AppColors.white,
                ),
                const SizedBox(
                  width: 8,
                ),
                FutureBuilder(
                    future: ifInVis(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (InVisUser == false) {
                          return Text(
                            "Users following me",
                            style: GoogleFonts.nunito(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.secondaryDark,
                            ),
                          );
                        }
                        if (InVisUser == true) {
                          return Text(
                            "Users following them",
                            style: GoogleFonts.nunito(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.secondaryDark,
                            ),
                          );
                        }
                      }
                      return Text("");
                    }),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            FutureBuilder(
                future: getFollowersList(),
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
                              itemCount: FollowersL.length,
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
