import 'dart:io' show Platform;
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:like_button/like_button.dart';
import 'package:lightbulb/routes/edit_profile.dart';
import 'package:lightbulb/util/colors.dart';
import 'package:lightbulb/util/dimensions.dart';
import 'package:lightbulb/util/screen_sizes.dart';
import 'package:lightbulb/util/styles.dart';
import 'package:lightbulb/util/button_styling.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/classes.dart';
import '../ui/post_card.dart';
//import '..lib//Post.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:flutter/material.dart';
import '../routes/settings.dart';
import '../routes/profile_page.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../util/db.dart';
import '../routes/search_and_explore.dart';
import '../main.dart';

class PostCard extends StatelessWidget {
  //final User user;
  final User tempuser;
  int index;
  bool notInVis;
  bool isPublic;
  //final VoidCallback delete;
  //final VoidCallback inclikes;
  PostCard({
    required this.tempuser,
    required this.index,
    required this.notInVis,
    required this.isPublic,
    //required this.delete,
    //required this.inclikes
  });
  //final FirebaseAnalytics analytics;
  //final FirebaseAnalyticsObserver observer;
  Color _iconcolor = AppColors.white;
  DBService db = DBService();
  Widget top(BuildContext context) {
    if (tempuser.post1[index].image == "image") {
      return Text("");
    }
    return Container(
      //color: AppColors.secondaryDark,
      constraints: const BoxConstraints(maxWidth: 200),
      width: MediaQuery.of(context).size.width,
      //child: Align(
      // alignment: Alignment.centerRight,
      child: Row(
          // Text(
          //   tempuser.post1.topics[0],
          //   style: topicStyle,
          //   //textAlign: TextAlign.start,
          // ),
          children: tempuser.post1[index].topics
              .map((topic) => Text(
                    topic + ' ',
                    style: topicStyle,
                    textAlign: TextAlign.start,
                  ))
              .toList()),
      // ),
    );
  }

  Widget imgORcaption() {
    //print(tempuser.post1[index].image);
    if (tempuser.post1[index].image == "image") {
      return Container(
        child: Center(
          child: Text(
            tempuser.post1[index].caption,
            style: captionStyleNoImage,
            //textAlign: TextAlign.start,
          ),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Image.network(
          tempuser.post1[index].image,
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }

  Widget captORtop(BuildContext context) {
    if (tempuser.post1[index].image == "image") {
      return Container(
        //color: AppColors.secondaryDark,
        constraints: const BoxConstraints(maxWidth: 200),
        width: MediaQuery.of(context).size.width,
        //child: Align(
        // alignment: Alignment.centerRight,
        child: Row(
            // Text(
            //   tempuser.post1.topics[0],
            //   style: topicStyle,
            //   //textAlign: TextAlign.start,
            // ),
            children: tempuser.post1[index].topics
                .map((topic) => Text(
                      topic + ' ',
                      style: topicStyle,
                      textAlign: TextAlign.start,
                    ))
                .toList()),
        // ),
      );
    }
    return Container(
      //color: AppColors.secondaryDark,
      constraints: const BoxConstraints(maxWidth: 200),
      width: MediaQuery.of(context).size.width,
      //child: Align(
      // alignment: Alignment.centerRight,
      child: Text(
        tempuser.post1[index].caption,
        style: captionStyle,
        //textAlign: TextAlign.start,
      ),
      // ),
    );
  }

  Future updateLikes(bool liked, int likes) async {
    SharedPreferences? prefs = await SharedPreferences.getInstance();
    String? cuID = prefs!.getString('userID');
    QuerySnapshot likedP = await FirebaseFirestore.instance
        .collection('users')
        .doc(cuID)
        .collection('likedPosts')
        .get();
    QuerySnapshot userILiked =
        await FirebaseFirestore.instance.collection('users').get();
    //print(tempuser.TempUsername);
    if (liked == true) {
      db.addlikedPosts(tempuser.post1[index].token, true, cuID, tempuser.token);
      for (int h = 0; h < userILiked.docs.length; h++) {
        //print(userILiked.docs[h]["token1"]);
        //print(tempuser.token);
        if (userILiked.docs[h]["token1"] == tempuser.token) {
          int newLikes = likes;
          //QuerySnapshot userPostILiked = await FirebaseFirestore.instance.collection('users').doc(userILiked.docs[h]["token1"]).collection('posts').get();
          db.addUser(
              userILiked.docs[h]["state"],
              userILiked.docs[h]["email"],
              userILiked.docs[h]["bio"],
              userILiked.docs[h]["posts"],
              userILiked.docs[h]["profpic"],
              userILiked.docs[h]["followReq"],
              userILiked.docs[h]["followingList"],
              userILiked.docs[h]["followersList"],
              userILiked.docs[h]["name"],
              userILiked.docs[h]["username"],
              userILiked.docs[h]["password"],
              userILiked.docs[h]["sentReq"],
              userILiked.docs[h]["token1"],
              tempuser.post1[index].caption,
              tempuser.post1[index].topics,
              tempuser.post1[index].image,
              newLikes,
              0,
              tempuser.location,
              tempuser.post1[index].token,
              'notiContent',
              'notiSender',
              'notiToken',
              userILiked.docs[h]["notifsList"],
              '');
        }
      }
    } else {
      for (int i = 0; i < likedP.docs.length; i++) {
        if (likedP.docs[i]["postName"] == tempuser.post1[index].token) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(cuID)
              .collection('likedPosts')
              .doc(likedP.docs[i]["postName"])
              .delete();
          for (int h = 0; h < userILiked.docs.length; h++) {
            // print(userILiked.docs[h]["token1"]);
            //print(tempuser.token);
            if (userILiked.docs[h]["token1"] == tempuser.token) {
              int newLikes = likes;
              //QuerySnapshot userPostILiked = await FirebaseFirestore.instance.collection('users').doc(userILiked.docs[h]["token1"]).collection('posts').get();
              db.addUser(
                  userILiked.docs[h]["state"],
                  userILiked.docs[h]["email"],
                  userILiked.docs[h]["bio"],
                  userILiked.docs[h]["posts"],
                  userILiked.docs[h]["profpic"],
                  userILiked.docs[h]["followReq"],
                  userILiked.docs[h]["followingList"],
                  userILiked.docs[h]["followersList"],
                  userILiked.docs[h]["name"],
                  userILiked.docs[h]["username"],
                  userILiked.docs[h]["password"],
                  userILiked.docs[h]["sentReq"],
                  userILiked.docs[h]["token1"],
                  tempuser.post1[index].caption,
                  tempuser.post1[index].topics,
                  tempuser.post1[index].image,
                  newLikes,
                  0,
                  tempuser.location,
                  tempuser.post1[index].token,
                  'notiContent',
                  'notiSender',
                  'notiToken',
                  userILiked.docs[h]["notifsList"],
                  '');
            }
          }
        }
      }
    }
    //print(tempuser.);
  }

  Future updateMarks(bool marked) async {
    SharedPreferences? prefs = await SharedPreferences.getInstance();
    String? cuID = prefs!.getString('userID');
    QuerySnapshot markedP = await FirebaseFirestore.instance
        .collection('users')
        .doc(cuID)
        .collection('bookmarkedPosts')
        .get();
    if (marked == true) {
      db.addmarkedPosts(
          tempuser.post1[index].token, true, cuID, tempuser.token);
    } else {
      for (int i = 0; i < markedP.docs.length; i++) {
        if (markedP.docs[i]["postName"] == tempuser.post1[index].token) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(cuID)
              .collection('bookmarkedPosts')
              .doc(markedP.docs[i]["postName"])
              .delete();
        }
      }
    }
  }

  bool isLiked = false;
  bool isMarked = false;

  Future getLikeStatus() async {
    SharedPreferences? prefs = await SharedPreferences.getInstance();
    String? cuID = prefs!.getString('userID');
    QuerySnapshot likedP = await FirebaseFirestore.instance
        .collection('users')
        .doc(cuID)
        .collection('likedPosts')
        .get();
    for (int i = 0; i < likedP.docs.length; i++) {
      if (likedP.docs[i]["postName"] == tempuser.post1[index].token) {
        this.isLiked = true;
      }
    }
  }

  Future getMarkStatus() async {
    SharedPreferences? prefs = await SharedPreferences.getInstance();
    String? cuID = prefs!.getString('userID');
    QuerySnapshot markedP = await FirebaseFirestore.instance
        .collection('users')
        .doc(cuID)
        .collection('bookmarkedPosts')
        .get();
    for (int i = 0; i < markedP.docs.length; i++) {
      if (markedP.docs[i]["postName"] == tempuser.post1[index].token) {
        this.isMarked = true;
      }
    }
  }

  Future goToVisUser(BuildContext context) async {
    SharedPreferences? prefs = await SharedPreferences.getInstance();
    String? cuID = prefs!.getString('userID');
    bool present = false;
    QuerySnapshot userInfo =
        await FirebaseFirestore.instance.collection('users').get();
    for (int i = 0; i < userInfo.docs.length; i++) {
      if (userInfo.docs[i]["token1"] == cuID) {
        for (int j = 0; j < userInfo.docs[i]["followingList"].length; j++) {
          if (userInfo.docs[i]["followingList"][j] == tempuser.token) {
            present = true;
            await prefs!.setString('situation', "F");
          }
        }
        for (int k = 0; k < userInfo.docs[i]["sentReq"].length; k++) {
          if (userInfo.docs[i]["sentReq"][k] == tempuser.token) {
            present = true;
            await prefs!.setString('situation', "ReqSent");
          }
        }
      }
    }
    if (present == false) {
      await prefs!.setString('situation', "NotF");
    }
    await prefs!.setString('VisUser', tempuser.token);
    Navigator.pushNamed(context, '/visitedprofilepage');
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: status(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // if(keepPrinting == true) {
            //  if ((notInVis == true) || (notInVis == false && isPublic == true) ||
            //  (notInVis == false && isPublic == false && iF == "F")) {
            return Column(
              children: [
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    color: AppColors.greyDarker,
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 8),
                          //Image.network(tempuser.image),

                          imgORcaption(),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Material(
                                      shape: CircleBorder(),
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      child: InkWell(
                                        splashColor: AppColors.secondaryDark,
                                        onTap: () async {
                                          if (notInVis == true) {
                                            await goToVisUser(context);
                                          } else {
                                            String s = 'Already in ' +
                                                tempuser.Name +
                                                '\'s profile.';
                                            showToast(s, Toast.LENGTH_SHORT);
                                          }
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            //color: AppColors.secondaryLight,
                                            border: Border.all(
                                                color: AppColors.greyDarker,
                                                width: 3),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Ink.image(
                                            image: NetworkImage(
                                                tempuser.profilepic),
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                20,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                10,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 16, 0, 5),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        // const SizedBox(width: 8),

                                        Container(
                                          //color: AppColors.secondaryDark,
                                          constraints: const BoxConstraints(
                                              maxWidth: 200),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          //child: Align(
                                          // alignment: Alignment.centerRight,
                                          child: Text(
                                            tempuser.TempUsername,
                                            style: usernameStyle,
                                            //textAlign: TextAlign.start,
                                          ),
                                          // ),
                                        ),
                                        // const SizedBox(width: 8),
                                        captORtop(context),
                                        // const SizedBox(width: 8),
                                        top(context),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                                child: Column(
                                  children: [
                                    const SizedBox(width: 8),
                                    FutureBuilder(
                                        future: getLikeStatus(),
                                        builder: (context, snapshot) {
                                          return LikeButton(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            isLiked: isLiked,
                                            size: 20.0,
                                            likeCount:
                                                tempuser.post1[index].likes,
                                            circleColor: CircleColor(
                                                start:
                                                    AppColors.primaryLightest,
                                                end: AppColors.primaryLighter),
                                            bubblesColor: BubblesColor(
                                              dotPrimaryColor:
                                                  AppColors.secondaryDark,
                                              dotSecondaryColor:
                                                  AppColors.secondaryLight,
                                            ),
                                            likeBuilder: (isLiked) {
                                              final color = isLiked
                                                  ? AppColors.secondaryLight
                                                  : AppColors.grey;
                                              return Icon(
                                                Icons.favorite,
                                                color: color,
                                                size: 20.0,
                                              );
                                            },
                                            onTap: (isLiked) async {
                                              this.isLiked = !isLiked;
                                              tempuser.post1[index].likes +=
                                                  this.isLiked ? 1 : -1;
                                              updateLikes(this.isLiked,
                                                  tempuser.post1[index].likes);
                                              return !isLiked;
                                            },
                                          );
                                        }),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        FutureBuilder(
                                            future: getMarkStatus(),
                                            builder: (context, snapshot) {
                                              return LikeButton(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                isLiked: isMarked,
                                                size: 20.0,
                                                circleColor: CircleColor(
                                                    start: AppColors
                                                        .primaryLighter,
                                                    end: AppColors.white),
                                                bubblesColor: BubblesColor(
                                                  dotPrimaryColor:
                                                      AppColors.primaryLightest,
                                                  dotSecondaryColor:
                                                      AppColors.white,
                                                ),
                                                likeBuilder: (isLiked) {
                                                  final color = isLiked
                                                      ? AppColors.white
                                                      : AppColors.grey;
                                                  return Icon(
                                                    Icons.bookmark,
                                                    color: color,
                                                    size: 20.0,
                                                  );
                                                },
                                                onTap: (isMarked) async {
                                                  this.isMarked = !isMarked;
                                                  updateMarks(this.isMarked);
                                                  return !isMarked;
                                                },
                                              );
                                            }),
                                        SizedBox(
                                          width: 7,
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              // FutureBuilder(
                              //   future: updateLikes(),
                              //     builder: (context, snapshot) {
                              //     return Text('');
                              // }
                              //),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                )
              ],
            );
          }
          //  else {
          //    db.addKP('false');
          //   return Text("lolio");
          // }
          //}
          // }
          return Text("");
        });
  }
}
