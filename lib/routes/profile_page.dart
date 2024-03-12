import 'dart:io' show Platform;

import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lightbulb/routes/edit_profile.dart';
import 'package:lightbulb/ui/post.dart';
import 'package:lightbulb/ui/post.dart';
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
import '../model/classes.dart';
//import '../ui/post_card.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key, required this.analytics, required this.observer})
      : super(key: key);

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
  static const String routeName = '/profilepage';
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  initState() {
    super.initState();
    setCurrentScreen(widget.analytics, 'Profile Page', 'profilePage');
    getPostTokens();
  }

  DBService db = DBService();

  // List<Post> posts = [
  //   Post(
  //       title: 'Hello World 1',
  //       hashtag: 'sfsdg',
  //       image:
  //           'https://static.birgun.net/resim/haber-detay-resim/2021/02/25/erzurum-oyununun-yapimcisi-oyun-begenilmeyince-hakaretler-yagdirdi-845533-5.jpg'),
  //   Post(
  //       title: 'Hello World 2',
  //       hashtag: 'sfsdg',
  //       image:
  //           'https://pixnio.com/free-images/2019/07/24/2019-07-24-05-25-19-550x309.jpg'),
  //   Post(
  //       title: 'Hello World 3',
  //       hashtag: 'sfsdg',
  //       image:
  //           'https://pixnio.com/free-images/2018/12/11/2018-12-11-12-39-11-550x365.jpg')
  // ];

  List<String?> userTokens = [];
  List<String> postTokens = [];
  int postT = 0;
  late QuerySnapshot querySnapshotPosts;
  Future getCurrUserDetails() async {
    SharedPreferences? prefs = await SharedPreferences.getInstance();
    String? cuID = prefs!.getString('userID');
    print(cuID);
    DocumentSnapshot documentSnapshotCurrUser =
        await FirebaseFirestore.instance.collection('users').doc(cuID).get();
    userData = documentSnapshotCurrUser.data();
  }

  Future getPosts() async {
    SharedPreferences? prefs = await SharedPreferences.getInstance();
    String? cuID = prefs!.getString('userID');
    querySnapshotPosts = await FirebaseFirestore.instance
        .collection('users')
        .doc(cuID)
        .collection('posts')
        .get();
  }

  Future getPostTokens() async {
    SharedPreferences? prefs = await SharedPreferences.getInstance();
    String? cuID = prefs!.getString('userID');
    //print("idx give: $idx");
    print("*************************");
    print(cuID);
    QuerySnapshot querySnapshotPost = await FirebaseFirestore.instance
        .collection('users')
        .doc(cuID)
        .collection('posts')
        .get();
    postT = querySnapshotPost.docs.length - 1;
    userTokens.add(cuID);
    return;
  }

  Future getUserAndPosts() async {
    await getPosts();
    await getCurrUserDetails();
  }

  List<User> currentUser = [
    //User(Name: 'Name', TempUsername: 'TempUsername', pass: 'pass', bio: 'bio', followReq: ["dummy" , "dummy"], followersList: ["dummy" , "dummy"], followingList: ["dummy" , "dummy"], sentReq: ["dummy" , "dummy"], location: 'location', profilepic: 'https://www.tenforums.com/geek/gars/images/2/types/thumb_15951118880user.png', token: 'token', state: true, Email: 'Email', post1: [Post1(caption: 'caption', topics: ["dummy" , "dummy"], image: 'image', likes: 0, comments: 0, token: 'token')])
  ];
  //List<>User currentUser = User(Name: 'Name', TempUsername: 'TempUsername', pass: 'pass', bio: 'bio', followReq: ["dummy" , "dummy"], followersList: ["dummy" , "dummy"], followingList: ["dummy" , "dummy"], sentReq: ["dummy" , "dummy"], location: 'location', profilepic: 'https://www.tenforums.com/geek/gars/images/2/types/thumb_15951118880user.png', token: 'token', state: true, Email: 'Email', post1: [Post1(caption: 'caption', topics: ["dummy" , "dummy"], image: 'image', likes: 0, comments: 0, token: 'token')]);
  dynamic userData;
  // bool state = true;
  // String name = '';
  // String username = '';
  // String profpic = '';
  // String pass = '';
  // String email = '';
  // int postsnum = 0;
  // int followers = 0;
  // int following = 0;
  // String bio = '';
  // String location = '';
  // List<dynamic> followersList = ["dummy", "dummy"];
  // List<dynamic> followingList = ["dummy", "dummy"];
  // List<dynamic> followReq = ["dummy", "dummy"];
  // List<dynamic> sentReq = ["dummy", "dummy"];
  // String token1 = '';

  // String caption = '';
  // int comments = 0;
  // String image = '';
  // int likes = 0;
  // String token = '';
  // List<dynamic> topics = [];

  // Future getUsers() async {
  //   //print("hiiii");
  //   currentUser.clear();
  //   SharedPreferences? prefs = await SharedPreferences.getInstance();
  //   String? cuID = prefs!.getString('userID');
  //   //print("currUser Token ${querySnapshotCurrUser.docs[0]["token"]}");
  //   //for (int i = 0; i < querySnapshotCurrUser.docs.length; i++){
  //   List<Post1> UserPosts = [];
  //   QuerySnapshot querySnapshotPost = await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(cuID)
  //       .collection('posts')
  //       .get();
  //   QuerySnapshot querySnapshotUsers =
  //       await FirebaseFirestore.instance.collection('users').get();
  //   for (int j = 0; j < querySnapshotPost.docs.length; j++) {
  //     //print("hi");
  //     //if(querySnapshotPost.docs[j]["token"] != "post0") {
  //     if (querySnapshotPost.docs[j]["token"] != 'postToken') {
  //       caption = querySnapshotPost.docs[j]["caption"];
  //       comments = querySnapshotPost.docs[j]["comments"];
  //       image = querySnapshotPost.docs[j]["image"];
  //       likes = querySnapshotPost.docs[j]["likes"];
  //       location = querySnapshotPost.docs[j]["location"];
  //       token = querySnapshotPost.docs[j]["token"];
  //       topics = querySnapshotPost.docs[j]["topics"];

  //       if (checkPost(UserPosts, token) == false &&
  //           querySnapshotPost.docs[j]["token"] != "post0") {
  //         // print("here");
  //         UserPosts.add(Post1(
  //             caption: caption,
  //             topics: topics,
  //             image: image,
  //             likes: likes,
  //             comments: comments,
  //             token: token));
  //         //print(UserPosts.length);
  //       }
  //     }
  //     //print(UserPosts.length);
  //     // }
  //   }
  //   for (int k = 0; k < querySnapshotUsers.docs.length; k++) {
  //     if (querySnapshotUsers.docs[k]["token1"] == cuID) {
  //       state = querySnapshotUsers.docs[k]["state"];
  //       name = querySnapshotUsers.docs[k]["name"];
  //       username = querySnapshotUsers.docs[k]["username"];
  //       profpic = querySnapshotUsers.docs[k]["profpic"];
  //       pass = querySnapshotUsers.docs[k]["password"];
  //       email = querySnapshotUsers.docs[k]["email"];
  //       postsnum = querySnapshotUsers.docs[k]["posts"];
  //       //followers = querySnapshotUser.docs[i]["followersList"].length;
  //       // following = querySnapshotUser.docs[i]["followingList"].length;
  //       followersList = querySnapshotUsers.docs[k]["followersList"];
  //       followingList = querySnapshotUsers.docs[k]["followingList"];
  //       followReq = querySnapshotUsers.docs[k]["followReq"];
  //       sentReq = querySnapshotUsers.docs[k]["sentReq"];
  //       bio = querySnapshotUsers.docs[k]["bio"];
  //       location = querySnapshotUsers.docs[k]["location"];
  //       token1 = querySnapshotUsers.docs[k]["token1"];
  //       if (checkUser(currentUser, token1) == false) {
  //         currentUser.add(User(
  //             Name: name,
  //             TempUsername: username,
  //             pass: pass,
  //             bio: bio,
  //             followReq: followReq,
  //             followersList: followersList,
  //             followingList: followingList,
  //             sentReq: sentReq,
  //             location: location,
  //             profilepic: profpic,
  //             token: token1,
  //             state: state,
  //             Email: email,
  //             post1: UserPosts));
  //         // print(currentUser[0].TempUsername);
  //       }
  //     }
  //   }
  //   //}
  //   //UserPosts.clear();
  //   //}
  //   //print(tempusers.length);
  // }

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
    await getPosts();
    setState(() {});
  }

  void showToast(String message, Toast t) => Fluttertoast.showToast(
        toastLength: t,
        msg: message,
        fontSize: 18.0,
      );

  Future onFollowersClick() async {
    SharedPreferences? prefs = await SharedPreferences.getInstance();

    // id = currentUser[0].token;
    // QuerySnapshot u = await FirebaseFirestore.instance.collection('users').get();
    // for(int h = 0; h < currentUser[0].followersList.length; h++) {
    // for (int i = 0; i < u.docs.length; i++) {
    //if (u.docs[i]["token1"] == currentUser[0].followersList[h]) {
    List<String> l = currentUser[0].followersList.cast<String>();
    await prefs!.setStringList('followers', l);
    //}
    //}
    //}
    Navigator.pushNamed(context, '/followers');
  }

  Future onFollowingClick() async {
    SharedPreferences? prefs = await SharedPreferences.getInstance();

    // id = currentUser[0].token;
    //QuerySnapshot u = await FirebaseFirestore.instance.collection('users').get();
    // for(int h = 0; h < currentUser[0].followingList.length; h++) {
    //  for (int i = 0; i < u.docs.length; i++) {
    // if (u.docs[i]["token1"] == currentUser[0].followingList[h]) {
    // List<String> l = currentUser[0].followingList.cast<String>();
    await prefs!.setStringList(
        'followings', currentUser[0].followingList.cast<String>());
    //List<String>?  f = await prefs!.getStringList('followings');
    // print("LIIIST:: ${f}");
    // print("${currentUser[0].followingList}");
    // }
    // }
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
        title: Text(
          'Profile',
          style: navBarHeadingStyle,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.settings,
              color: AppColors.primary,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
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
                          future: getUserAndPosts(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              print("************************");
                              print("this was done");
                              return Center(
                                child: ListView.builder(
                                  primary: false,
                                  //physics: ScrollPhysics(),
                                  itemCount: querySnapshotPosts.docs.length,
                                  itemBuilder: (context, index) {
                                    print("this was done toooooo");
                                    PostData currPost = PostData(
                                        caption: querySnapshotPosts.docs[index]
                                            ['caption'],
                                        comments: querySnapshotPosts.docs[index]
                                            ['comments'],
                                        image: querySnapshotPosts.docs[index]
                                            ['image'],
                                        likes: querySnapshotPosts.docs[index]
                                            ['likes'],
                                        token: querySnapshotPosts.docs[index]
                                            ['token'],
                                        topics: querySnapshotPosts.docs[index]
                                            ['topics'],
                                        author: userData['uid']);
                                    print("this was done too");
                                    return ListTile(
                                      title: profPost(
                                        post: currPost,
                                        index: index,
                                        // postDocID: "user${idx.toString()}post${index}",
                                        //postDocID: "user${idx.toString()}post${postTokens[index][postTokens[index].length-1]}",
                                        // ),
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
                    child: FutureBuilder(
                      future: getCurrUserDetails(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          print(userData);
                          return Column(
                            children: [
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    CircleAvatar(
                                      radius: screenHeight(context) / 20,
                                      backgroundColor: AppColors.secondaryDark,
                                      child: ClipOval(
                                        child: Image.network(
                                          userData["profPic"],
                                          fit: BoxFit.fitHeight,
                                        ),
                                      ),
                                    )
                                  ]),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 12, 0, 0),
                                      child: Text(
                                        userData["name"],
                                        style: pfpNameStyle,
                                      )),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                      child: Text(
                                        userData["username"],
                                        style: pfpUserNameStyle,
                                      ))
                                ],
                              ),
                              SizedBox(
                                height: screenHeight(context) / 42.2,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: screenWidth(context) / 4.9,
                                    decoration: FollowerFollowingStyle.lsButton,
                                    child: TextButton(
                                      onPressed: () {},
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            userData["posts"].toString(),
                                            style: pfpStatsStyle,
                                          ),
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
                                        await onFollowersClick();
                                      },
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            userData["followersList"]
                                                .length
                                                .toString(),
                                            style: pfpStatsStyle,
                                          ),
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
                                        await onFollowingClick();
                                      },
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            userData["followingList"]
                                                .length
                                                .toString(),
                                            style: pfpStatsStyle,
                                          ),
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
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 24, 0, 0),
                                      child: Text(
                                        userData["bio"],
                                        style: pfpStatsCaptionStyle,
                                      )),
                                ],
                              ), // 'Hopefully CS310 grade boundaries are nice and low.'
                              SizedBox(
                                height: screenHeight(context) / 42.2,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Container(
                                    // margin: const EdgeInsets.fromLTRB(0, 0, 0, 9),
                                    child: OutlinedButton(
                                        onPressed: () {
                                          // showToast(
                                          //     'Please click Ok/Enter on your keyboard after typing in new information to save it.',
                                          //     Toast.LENGTH_LONG);
                                          Navigator.pushNamed(
                                              context, '/editprofile');
                                          logCustomEvent(widget.analytics,
                                              'edit profile button tapped');
                                        },
                                        child: const Text(
                                          'Edit Profile',
                                          style: lsButtonTextStyle,
                                        ),
                                        style: OutlinedButton.styleFrom(
                                            side: const BorderSide(
                                          color: Color(0x00000000),
                                        ))),
                                    decoration: ButtonStyling.lsButton,
                                    height: screenHeight(context) / 21.1,
                                  ),
                                ],
                              ),
                            ],
                          );
                        }
                        return const Center(
                            //child: CircularProgressIndicator(),
                            );
                      },
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
