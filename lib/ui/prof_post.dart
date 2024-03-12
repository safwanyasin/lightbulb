import 'dart:io' show Platform;
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
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
import '../util/db.dart';

class profPost extends StatelessWidget {
  //final User user;
  final PostData post;
  int index;
  String username = "";
  String profPic = "";

  //final VoidCallback delete;
  //final VoidCallback inclikes;
  profPost({
    required this.post,
    required this.index,
    //required this.delete,
    //required this.inclikes
  });
  Color _iconcolor = AppColors.white;
  DBService db = DBService();

  Widget top(BuildContext context) {
    // if (post["image"] == "image") {
    //   return Text("");
    // }
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
          children: post.topics
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
    //print(post.image);
    if (post.image == "image") {
      return Container(
        child: Center(
          child: Text(
            post.caption,
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
          post.image,
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }

  Widget captORtop(BuildContext context) {
    // if (post.image == "image") {
    //   return Container(
    //     //color: AppColors.secondaryDark,
    //     constraints: const BoxConstraints(maxWidth: 200),
    //     width: MediaQuery.of(context).size.width,
    //     //child: Align(
    //     // alignment: Alignment.centerRight,
    //     child: Row(
    //         // Text(
    //         //   tempuser.post1.topics[0],
    //         //   style: topicStyle,
    //         //   //textAlign: TextAlign.start,
    //         // ),
    //         children: post.topics
    //             .map((topic) => Text(
    //                   topic + ' ',
    //                   style: topicStyle,
    //                   textAlign: TextAlign.start,
    //                 ))
    //             .toList()),
    //     // ),
    //   );
    // }
    if (post.image != "image") {
      return Container(
        //color: AppColors.secondaryDark,
        constraints: const BoxConstraints(maxWidth: 200),
        width: MediaQuery.of(context).size.width,
        //child: Align(
        // alignment: Alignment.centerRight,
        child: Text(
          post.caption,
          style: captionStyle,
          //textAlign: TextAlign.start,
        ),
        // ),
      );
    }
    return Container();
  }

  Future updateLikes(bool liked, int likes, String author) async {
    print("the author is " + author + " and the likes are " + likes.toString());
    SharedPreferences? prefs = await SharedPreferences.getInstance();
    String? cuID = prefs!.getString('userID');
    QuerySnapshot likedP = await FirebaseFirestore.instance
        .collection('users')
        .doc(cuID)
        .collection('likedPosts')
        .get();
    DocumentSnapshot userILiked =
        await FirebaseFirestore.instance.collection('users').doc(author).get();
    //print(tempuser.TempUsername);
    if (liked == true) {
      db.addlikedPosts(post.token, true, cuID, author);
      final data = {'likes': likes};
      await FirebaseFirestore.instance
          .collection('users')
          .doc(author)
          .collection('posts')
          .doc(post.token)
          .set(data, SetOptions(merge: true));

      // for (int h = 0; h < userILiked.docs.length; h++) {
      //   //print(userILiked.docs[h]["token1"]);
      //   //print(tempuser.token);
      //   if (userILiked.docs[h]["token1"] == post.token) {
      //     int newLikes = likes;
      //     //QuerySnapshot userPostILiked = await FirebaseFirestore.instance.collection('users').doc(userILiked.docs[h]["token1"]).collection('posts').get();
      //     db.addUser(
      //         userILiked.docs[h]["state"],
      //         userILiked.docs[h]["email"],
      //         userILiked.docs[h]["bio"],
      //         userILiked.docs[h]["posts"],
      //         userILiked.docs[h]["profpic"],
      //         userILiked.docs[h]["followReq"],
      //         userILiked.docs[h]["followingList"],
      //         userILiked.docs[h]["followersList"],
      //         userILiked.docs[h]["name"],
      //         userILiked.docs[h]["username"],
      //         userILiked.docs[h]["password"],
      //         userILiked.docs[h]["sentReq"],
      //         userILiked.docs[h]["token1"],
      //         post.caption,
      //         post.topics,
      //         post.image,
      //         newLikes,
      //         0,
      //         'location',
      //         post.token,
      //         'notiContent',
      //         'notiSender',
      //         'notiToken',
      //         userILiked.docs[h]["notifsList"],
      //         '');
      //   }
    } else {
      // for (int i = 0; i < likedP.docs.length; i++) {
      //   if (likedP.docs[i]["postName"] == post.token) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(cuID)
          .collection('likedPosts')
          // .doc(likedP.docs[i]["postName"])
          .doc(post.token)
          .delete();
      final data = {'likes': likes};
      await FirebaseFirestore.instance
          .collection('users')
          .doc(author)
          .collection('posts')
          .doc(post.token)
          .set(data, SetOptions(merge: true));
      // for (int h = 0; h < userILiked.docs.length; h++) {
      //   // print(userILiked.docs[h]["token1"]);
      //   //print(tempuser.token);
      //   if (userILiked.docs[h]["token1"] == post.token) {
      //     int newLikes = likes;
      //     //QuerySnapshot userPostILiked = await FirebaseFirestore.instance.collection('users').doc(userILiked.docs[h]["token1"]).collection('posts').get();
      //     db.addUser(
      //         userILiked.docs[h]["state"],
      //         userILiked.docs[h]["email"],
      //         userILiked.docs[h]["bio"],
      //         userILiked.docs[h]["posts"],
      //         userILiked.docs[h]["profpic"],
      //         userILiked.docs[h]["followReq"],
      //         userILiked.docs[h]["followingList"],
      //         userILiked.docs[h]["followersList"],
      //         userILiked.docs[h]["name"],
      //         userILiked.docs[h]["username"],
      //         userILiked.docs[h]["password"],
      //         userILiked.docs[h]["sentReq"],
      //         userILiked.docs[h]["token1"],
      //         post.caption,
      //         post.topics,
      //         post.image,
      //         newLikes,
      //         0,
      //         'location',
      //         post.token,
      //         'notiContent',
      //         'notiSender',
      //         'notiToken',
      //         userILiked.docs[h]["notifsList"],
      //         '');
      //   }
      // }
      //}
      //}
    }
    //print(tempuser.);
  }

  Future updateMarks(bool marked, String author) async {
    SharedPreferences? prefs = await SharedPreferences.getInstance();
    String? cuID = prefs!.getString('userID');
    QuerySnapshot markedP = await FirebaseFirestore.instance
        .collection('users')
        .doc(cuID)
        .collection('bookmarkedPosts')
        .get();
    if (marked == true) {
      db.addmarkedPosts(post.token, true, cuID, author);
    } else {
      // for (int i = 0; i < markedP.docs.length; i++) {
      //   if (markedP.docs[i]["postName"] == post.token) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(cuID)
          .collection('bookmarkedPosts')
          // .doc(markedP.docs[i]["postName"])
          .doc(post.token)
          .delete();
    }
    //   }
    // }
  }

  bool isLiked = false;
  bool isMarked = false;

  Future getLikeStatus() async {
    SharedPreferences? prefs = await SharedPreferences.getInstance();
    String? cuID = prefs!.getString('userID');
    DocumentSnapshot likedP = await FirebaseFirestore.instance
        .collection('users')
        .doc(cuID)
        .collection('likedPosts')
        .doc(post.token)
        .get();
    if (likedP.exists == true) {
      this.isLiked = true;
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
      if (markedP.docs[i]["postName"] == post.token) {
        this.isMarked = true;
      }
    }
  }

  void showToast(String message, Toast t) => Fluttertoast.showToast(
        toastLength: t,
        msg: message,
        fontSize: 18.0,
      );

  Future deletePost() async {
    SharedPreferences? prefs = await SharedPreferences.getInstance();
    String? cuID = prefs!.getString('userID');
    QuerySnapshot myPost = await FirebaseFirestore.instance
        .collection('users')
        .doc(cuID)
        .collection('posts')
        .get();
    QuerySnapshot myImage =
        await FirebaseFirestore.instance.collection('image').get();
    for (int i = 0; i < myPost.docs.length; i++) {
      if (myPost.docs[i]["token"] == post.token) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(cuID)
            .collection('posts')
            .doc(myPost.docs[i]["token"])
            .delete();
        await FirebaseFirestore.instance
            .collection('image')
            .doc(myPost.docs[i]["token"])
            .delete();
      }
    }
    QuerySnapshot cLP = await FirebaseFirestore.instance
        .collection('users')
        .doc(cuID)
        .collection('likedPosts')
        .get();
    for (int i = 0; i < cLP.docs.length; i++) {
      if (cLP.docs[i]["token"] == post.token) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(cuID)
            .collection('likedPosts')
            .doc(cLP.docs[i]["token"])
            .delete();
      }
    }
    QuerySnapshot cMP = await FirebaseFirestore.instance
        .collection('users')
        .doc(cuID)
        .collection('bookmarkedPosts')
        .get();
    for (int i = 0; i < cMP.docs.length; i++) {
      if (cMP.docs[i]["token"] == post.token) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(cuID)
            .collection('bookmarkedPosts')
            .doc(cMP.docs[i]["token"])
            .delete();
      }
    }

    showToast(
        'Post deleted! Please scroll down to refresh.', Toast.LENGTH_SHORT);
  }

  Future uploadPost(BuildContext context) async {
    SharedPreferences? prefs = await SharedPreferences.getInstance();
    await prefs!.setString('postToken', post.token);
    await prefs!.setString('epCaption', post.caption);
    List<String> l = post.topics.cast<String>();
    await prefs!.setStringList('epTopics', l);
    await prefs!.setString('epImage', post.image);
    Navigator.pushNamed(context, '/editpost');
  }

  Future getUserName() async {
    SharedPreferences? prefs = await SharedPreferences.getInstance();
    String? cuid = prefs!.getString('userID');
    DocumentSnapshot user =
        await FirebaseFirestore.instance.collection('users').doc(cuid).get();
    username = user['username'];
    profPic = user['profPic'];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getUserName(),
        builder: (context, snapshot) {
          return Column(
            children: [
              // const SizedBox(height: 12),
              Container(
                margin: const EdgeInsets.only(top: 15),
                child: ClipRRect(
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
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  // color: AppColors.white,
                                  height: 30,
                                  width: 25,
                                  child: IconButton(
                                    splashRadius: 1,
                                    icon: Icon(
                                      Icons.edit,
                                      color: AppColors.grey,
                                      size: 20,
                                    ),
                                    onPressed: () async {
                                      showToast(
                                          'Please click Ok/Enter on your keyboard after typing in new information to save it.',
                                          Toast.LENGTH_LONG);
                                      await uploadPost(context);
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 6,
                                ),
                                Container(
                                  // color: AppColors.white,
                                  height: 30,
                                  width: 25,
                                  child: IconButton(
                                    splashRadius: 1,
                                    icon: Icon(
                                      Icons.delete,
                                      color: AppColors.grey,
                                      size: 20,
                                    ),
                                    onPressed: () async {
                                      showToast('Deleting post, please wait...',
                                          Toast.LENGTH_SHORT);
                                      await deletePost();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),

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
                                    padding: const EdgeInsets.all(8),
                                    child: Material(
                                      shape: CircleBorder(),
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      child: InkWell(
                                        splashColor: AppColors.secondaryDark,
                                        onTap: () {
                                          showToast(
                                              'Already at your profile page.',
                                              Toast.LENGTH_SHORT);
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
                                              profPic,
                                            ),
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
                                        const EdgeInsets.fromLTRB(0, 16, 0, 0),
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
                                            username,
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
                                            likeCount: post.likes,
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
                                              post.likes +=
                                                  this.isLiked ? 1 : -1;
                                              updateLikes(this.isLiked,
                                                  post.likes, post.author);
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
                                                  updateMarks(this.isMarked,
                                                      post.author);
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
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              )
            ],
          );
        });
  }
}
