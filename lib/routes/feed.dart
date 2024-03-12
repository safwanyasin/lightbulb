
//import 'dart:html';
import 'dart:io' show Platform;
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lightbulb/routes/create_post.dart';
import 'package:lightbulb/routes/edit_profile.dart';
import 'package:lightbulb/routes/search_and_explore.dart';
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
import '../util/auth.dart';
import '../util/db.dart';

//int runs = 0;
//bool calledAlready = false;
//int len = 0;


class Feed extends StatefulWidget {
  const  Feed({Key? key, required this.analytics, required this.observer}) : super(key: key);

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  _FeedState createState() => _FeedState();

  static const String routeName = '/feed';
}

class _FeedState extends State<Feed>{
  AuthService auth = AuthService();
  DBService db = DBService();

  @override
  initState() {
    super.initState();
    setCurrentScreen(widget.analytics, 'Feed', 'feedPage');
    //getUserTokens();
  }
  //bool state = true;
  List<User> tempusers = [
    //User( Name: 'Fawaz Mirza', TempUsername: '@sillygoose', pass: 'password', Email: 'fawaz@email.com', Location: 'IST, Turkey', post1: Post1(caption: 'caption', topics: ["#topics","#topics","#topics"], image: 'https://i.pinimg.com/736x/63/04/af/6304afcd59fd8b795a6482bcb1181404.jpg', likes: 0, comments:  0)),
   // User( Name: 'Safwan Yasin',TempUsername: '@safwanyasin', pass: 'password', Email: 'safwan@email.com', Location: 'IST, Turkey', post1: Post1(caption: 'caption', topics: ["#topics","#topics","#topics"], image: 'https://i.pinimg.com/736x/f6/85/f1/f685f10a3692c5bb362b0f335a37c572.jpg', likes: 0, comments:  0)),
    //User( Name: 'Nofil Iqbal',TempUsername: '@nofiliqbal', pass: 'password', Email: 'nofil@email.com', Location: 'IST, Turkey', post1: Post1(caption: 'caption', topics: ["#topics","#topics","#topics"], image: 'https://i.pinimg.com/originals/e5/66/45/e56645a9967cd34ca88fcc7d7220b60c.jpg', likes: 0, comments:  0)),
    //User( Name: 'Melih',TempUsername: '@melih', pass: 'password', Email: 'melih@email.com', Location: 'IST, Turkey', post1: Post1(caption: 'caption', topics: ["#topics","#topics","#topics"], image: 'https://i.pinimg.com/564x/ea/35/27/ea3527f8f8b4b40a023ce27d9c19c40e.jpg', likes: 0, comments:  0)),
    //User( Name: 'User420',TempUsername: '@user420', pass: 'password', Email: 'random@email.com', Location: 'IST, Turkey', post1: Post1(caption: 'caption', topics: ["#topics","#topics","#topics"], image: 'https://img.universitystudent.org/1/4/3410/me-finishing-the-semester-meme.jpg', likes: 0, comments:  0)),
    //User( Name: 'User69',TempUsername: '@user69', pass: 'password', Email: 'random@email.com', Location: 'IST, Turkey', post1: Post1(caption: 'caption', topics: ["#topics","#topics","#topics"], image: 'https://titterfun.com/api/assets/image/21wkagpmtm20.jpg', likes: 0, comments:  0)),
    //User(Name: "Fawaz Mirza", TempUsername: "@sillygoose", pass: "password", bio: "bio", followReq: ["dummy", "dummy"], followersList: ["dummy", "dummy"], followingList: ["dummy", "dummy"], sentReq: ["dummy", "dummy"], location: "location", profilepic: "https://www.tenforums.com/geek/gars/images/2/types/thumb_15951118880user.png", token: "token", state: true, Email: "fawaz@email.com", post1: [Post1(caption: "caption", topics: ["#topics","#topics","#topics"], image: 'https://i.pinimg.com/736x/63/04/af/6304afcd59fd8b795a6482bcb1181404.jpg', likes: 0, comments: 0)]),
    //User(Name: "Safwan Yasin", TempUsername: "@safwanyasin", pass: "password", bio: "bio", followReq: ["dummy", "dummy"], followersList: ["dummy", "dummy"], followingList: ["dummy", "dummy"], sentReq: ["dummy", "dummy"], location: "location", profilepic: "https://www.tenforums.com/geek/gars/images/2/types/thumb_15951118880user.png", token: "token", state: true, Email: "safwan@email.com", post1: [Post1(caption: "caption", topics: ["#topics","#topics","#topics"], image: 'https://i.pinimg.com/736x/f6/85/f1/f685f10a3692c5bb362b0f335a37c572.jpg', likes: 0, comments: 0)]),
    //User(Name: "Nofil Iqbal", TempUsername: "@nofiliqbal", pass: "password", bio: "bio", followReq: ["dummy", "dummy"], followersList: ["dummy", "dummy"], followingList: ["dummy", "dummy"], sentReq: ["dummy", "dummy"], location: "location", profilepic: "https://www.tenforums.com/geek/gars/images/2/types/thumb_15951118880user.png", token: "token", state: true, Email: "nofil@email.com", post1: [Post1(caption: "caption", topics: ["#topics","#topics","#topics"], image: 'https://i.pinimg.com/originals/e5/66/45/e56645a9967cd34ca88fcc7d7220b60c.jpg', likes: 0, comments: 0)]),
    //User(Name: "Melih", TempUsername: "@melih", pass: "password", bio: "bio", followReq: ["dummy", "dummy"], followersList: ["dummy", "dummy"], followingList: ["dummy", "dummy"], sentReq: ["dummy", "dummy"], location: "location", profilepic: "https://www.tenforums.com/geek/gars/images/2/types/thumb_15951118880user.png", token: "token", state: true, Email: "melih@email.com", post1: [Post1(caption: "caption", topics: ["#topics","#topics","#topics"], image: 'https://i.pinimg.com/564x/ea/35/27/ea3527f8f8b4b40a023ce27d9c19c40e.jpg', likes: 0, comments: 0)]),
    //User(Name: "User420", TempUsername: "@user420", pass: "password", bio: "bio", followReq: ["dummy", "dummy"], followersList: ["dummy", "dummy"], followingList: ["dummy", "dummy"], sentReq: ["dummy", "dummy"], location: "location", profilepic: "https://www.tenforums.com/geek/gars/images/2/types/thumb_15951118880user.png", token: "token", state: true, Email: "random@email.com", post1: [Post1(caption: "caption", topics: ["#topics","#topics","#topics"], image: 'https://img.universitystudent.org/1/4/3410/me-finishing-the-semester-meme.jpg', likes: 0, comments: 0)]),
    //User(Name: "User69", TempUsername: "@user69", pass: "password", bio: "bio", followReq: ["dummy", "dummy"], followersList: ["dummy", "dummy"], followingList: ["dummy", "dummy"], sentReq: ["dummy", "dummy"], location: "location", profilepic: "https://www.tenforums.com/geek/gars/images/2/types/thumb_15951118880user.png", token: "token", state: true, Email: "random@email.com", post1: [Post1(caption: "caption", topics: ["#topics","#topics","#topics"], image: 'https://titterfun.com/api/assets/image/21wkagpmtm20.jpg', likes: 0, comments: 0)]),

  ];



  // List<User> users = [
  // User.post(username: 'Fawaz', email: 'fawaz.WantsAnA@please.com', password: 'pass', followers: 300, following: 0, posts: TempUser( TempUsername: 'Hello world 1', TempCaption: 'March 31', likes: 0, comments: 0, topics: Topic(name: '#CS310'), image: 'https://i.pinimg.com/736x/63/04/af/6304afcd59fd8b795a6482bcb1181404.jpg') ),
  // ];
  // int postcount = 0;
  void deletePost(User tempuser){
    setState(() {
      tempusers.remove(tempuser);
    });
  }

  void incrementlikes(tempuser){
    setState(() {
      tempuser.likes++;
      //post.likes.color = AppColors.secondaryLight;
    });
  }

  void buttonClicked(){
    setState(() {
      //  postcount++;
    });
  }
  //final Stream<QuerySnapshot> users = FirebaseFirestore.instance.collection('users').snapshots();

  //CollectionReference _collectionRef =
 // FirebaseFirestore.instance.collection('users');


  //Future getPostInfo() async {

 // }
  List<String> dummy = ["dummy", "dummy"];

  //CollectionReference userCollection = FirebaseFirestore.instance.collection('users');

  List<String> userTokens = [];
  List<String> postTokens = [];
  int postT = 0;




  Future getUserTokens() async{
    //postTokens.clear();
    //postTokens.clear();

    QuerySnapshot querySnapshotUser = await FirebaseFirestore.instance.collection('users').get();
    //return await FirebaseFirestore.instance.collection('users').get().then(
          //  (snapshot) => snapshot.docs.forEach((document) {
              //print(document.reference.id);
              //if(calledAlready == false) {
    for(int i = 0; i < querySnapshotUser.docs.length; i++){
      //print(querySnapshotUser.docs[i]["token1"]);
      if(querySnapshotUser.docs[i]["token1"].contains(new RegExp(r'[0-9]')) == false){
        //FirebaseFirestore.instance.collection('users').doc(document.reference.id).delete();
      }
      else {
      //  if(check(userTokens, querySnapshotUser.docs[i]["token1"]) == false) {
          userTokens.add(querySnapshotUser.docs[i]["token1"]);
         // if(idx != -1) {
           // postTokens.clear();
            //QuerySnapshot querySnapshotPost = await FirebaseFirestore.instance.collection('users').doc(idx.toString()).collection('posts').get();
            //for (int j = 0; j < querySnapshotPost.docs.length; j++) {
             // postTokens.add(querySnapshotPost.docs[j]["token"]);
            //}
         // }
         // postT = querySnapshotPost.docs.length;
          //print(querySnapshotUser.docs[i]["token1"]);

      //  }
        //print(userTokens.length);
      }
    }
              //}
            //})
   // );
    //for(int i = num; i < num+1; i++){
      //print(i);
      //postTokens.clear();

   // }
    //print("num: ${num}");
    //print("user: ${userTokens.length}");


    //postTokens.clear();
  }
  
  Future getPostTokens(idx) async{
    print("idx give: $idx");
    QuerySnapshot querySnapshotPost = await FirebaseFirestore.instance.collection('users').doc(idx.toString()).collection('posts').get();
    postT = querySnapshotPost.docs.length;
    //return;
   // postTokens.clear();
   // return await FirebaseFirestore.instance.collection('users').doc(idx.toString()).collection('posts').get().then(
     //       (snapshot) => snapshot.docs.forEach((document) {
     //     if(check(postTokens, document.reference.id) == false) {
            //print(document.reference.id);
      //      //PostCard(userDocID: userTokens[int.parse(document.reference.id)]);
      //      postTokens.add(document.reference.id);
    //      }
    //    })
   // );
    //print("post: ${postTokens.length}");
  }
  bool state = true;
  String name = '';
  String  username = '';
  String profpic = '';
  String pass = '';
  String email = '';
  int posts = 0;
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




  Future getUsers() async{
    tempusers.clear();
    SharedPreferences? prefs = await SharedPreferences.getInstance();
    String? cuID =  await prefs!.getString("userID");
    QuerySnapshot querySnapshotUser = await FirebaseFirestore.instance.collection('users').get();
    for (int i = 0; i < querySnapshotUser.docs.length; i++){
      //bool flw = await flwing(cuID, querySnapshotUser.docs[i]["token1"]);
      //bool tpcs = await tpcsS(cuID, querySnapshotUser.docs[i]["token1"]);
      List<Post1> UserPosts = [];
      QuerySnapshot querySnapshotPost = await FirebaseFirestore.instance.collection('users').doc(querySnapshotUser.docs[i]["token1"]).collection('posts').get();
      if(true == true//flw == true || //tpcs == true
      ) {
        for (int j = 0; j < querySnapshotPost.docs.length; j++) {
          //if(querySnapshotPost.docs[j]["token"] != "post0") {
          caption = querySnapshotPost.docs[j]["caption"];
          comments = querySnapshotPost.docs[j]["comments"];
          image = querySnapshotPost.docs[j]["image"];
          likes = querySnapshotPost.docs[j]["likes"];
          location = querySnapshotPost.docs[j]["location"];
          token = querySnapshotPost.docs[j]["token"];
          topics = querySnapshotPost.docs[j]["topics"];

          if (checkPost(UserPosts, token) == false) {
            UserPosts.add(Post1(caption: caption,
                topics: topics,
                image: image,
                likes: likes,
                comments: comments,
                token: token));
          }
          //print(UserPosts.length);
          // }
        }
        state = querySnapshotUser.docs[i]["state"];
        name = querySnapshotUser.docs[i]["name"];
        username = querySnapshotUser.docs[i]["username"];
        profpic = querySnapshotUser.docs[i]["profpic"];
        pass = querySnapshotUser.docs[i]["password"];
        email = querySnapshotUser.docs[i]["email"];
        posts = querySnapshotUser.docs[i]["posts"];
        //followers = querySnapshotUser.docs[i]["followersList"].length;
        // following = querySnapshotUser.docs[i]["followingList"].length;
        followersList = querySnapshotUser.docs[i]["followersList"];
        followingList = querySnapshotUser.docs[i]["followingList"];
        followReq = querySnapshotUser.docs[i]["followReq"];
        sentReq = querySnapshotUser.docs[i]["sentReq"];
        bio = querySnapshotUser.docs[i]["bio"];
        location = querySnapshotUser.docs[i]["location"];
        token1 = querySnapshotUser.docs[i]["token1"];
        if (checkUser(tempusers, token1) == false) {
          tempusers.add(User(Name: name, TempUsername: username, pass: pass, bio: bio, followReq: followReq, followersList: followersList, followingList: followingList, sentReq: sentReq, location: location, profilepic: profpic, token: token1, state: state, Email: email, post1: UserPosts));
          //print(UserPosts.length);
        }
      }
      //UserPosts.clear();
    }
    //print(tempusers.length);
  }

  Future<bool> tpcsS(String? cuID, String id) async {
    List<dynamic> myTops = [];
    List<dynamic> theirTops = [];
    QuerySnapshot u = await FirebaseFirestore.instance.collection('users').get();
    for(int i = 0; i < u.docs.length; i++){
      if(u.docs[i]["token1"] == cuID) {
          QuerySnapshot T1 = await FirebaseFirestore.instance.collection('users').doc(cuID).collection('subscribedTopics').get();
          for(int j = 0; j < T1.docs.length; j++){
            myTops.add(T1.docs[j]);
          }
        }
      }
    for(int i = 0; i < u.docs.length; i++){
      if(u.docs[i]["token1"] == id) {
        QuerySnapshot T2 = await FirebaseFirestore.instance.collection('users').doc(id).collection('subscribedTopics').get();
        for(int j = 0; j < T2.docs.length; j++){
          theirTops.add(T2.docs[j]);
        }
      }
    }
    for(int i = 0; i < myTops.length; i++){
      for(int j = 0; j < theirTops.length; j++){
        if(myTops[i] == theirTops[j]){
          return true;
        }
      }
    }
    return false;
  }

 Future<bool> flwing(String? id, String compare) async {
   QuerySnapshot u = await FirebaseFirestore.instance.collection('users').get();
   for(int i = 0; i < u.docs.length; i++){
     if(u.docs[i]["token1"] == id) {
       for (int j = 0; j < u.docs[i]['followingList'].length; j++) {
         if (u.docs[i]['followingList'][j] == compare) {
           return true;
         }
       }
     }
   }
   return false;
 }

bool checkUser(List<User> l, String item){
    for(int i = 0; i < l.length; i++){
      if(l[i].token == item)
        return true;
    }
    return false;
}

bool checkPost(List<Post1> l, String item){
  for(int i = 0; i < l.length; i++){
    //print(l[i].token);
    if(l[i].token == item)
      return true;
  }
  return false;
}

  Future ref() async {
    await getUsers();
    setState(() {});
  }


//Widget feed(int num){

  //return Container(
  //  height: MediaQuery.of(context).size.height,
   // width: MediaQuery.of(context).size.width,
   // child: FutureBuilder(
    //  future: getUserTokens(),
   //   builder: (context, snapshot){
    //    return ListView.builder(
    //      //shrinkWrap: false,
    //        itemCount: userTokens.length,
    //        itemBuilder: (context, idx){
    //          //getUserTokens(i);
     //         return Container(
     //           height: MediaQuery.of(context).size.height,
    //            width: MediaQuery.of(context).size.width,
     //           child: FutureBuilder(
     //             future: getUserTokens(idx),
     //             builder: (context, snapshot) {
     //               return ListView.builder(
     //                 itemCount: postTokens.length,
      //                itemBuilder: (context, index) {
       //                 return ListTile(
       //                   title: PostCard(userDocID: userTokens[idx],
       //                     postDocID: postTokens[index],
       //                   ),
        //                );
        //              }
        //            );
        //          }
       //         ),
       //       );
      //      }
    //    );
    //  },),
 // );

//}

  @override
  Widget build(BuildContext context){
   // runs++;

   // if(runs == 1) {

     //for (int i = 0; i < tempusers.length; i++) {
        //db.addUser(true,tempusers[i].Email, dummy, dummy,tempusers[i].Name, tempusers[i].TempUsername, tempusers[i].pass, dummy,i.toString(),tempusers[i].post1.caption, tempusers[i].post1.topics, tempusers[i].post1.image, tempusers[i].post1.likes, tempusers[i].post1.comments, "location","user${i.toString()}post0", "dummy", "dummy", i.toString(), "");
       //db.addUser(true, tempusers[i].Email, tempusers[i].bio, tempusers[i].post1.length, tempusers[i].profilepic, tempusers[i].followReq, tempusers[i].followingList, tempusers[i].followersList, tempusers[i].Name, tempusers[i].TempUsername, tempusers[i].pass, tempusers[i].sentReq, i.toString(), "caption", ["#topics","#topics","#topics"], tempusers[i].post1[0].image, 0, 0, "location", "postToken", "notiContent", "notiSender", "notiToken", "");
        ////db.addPost();
      //}
      //getUserInfo();
      //print("this one: ${tempusers.length}");
  // }

    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        title: Text(
          'Feed',
          style: navBarHeadingStyle,
        ),
        centerTitle: true,
        backgroundColor: AppColors.secondaryDark,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              color: AppColors.primary,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/searchandexplore');
            },
          ),
        ],
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
        // IconButton(
        //   icon: Icon(
        //     Icons.settings,
        //     color: AppColors.primary,
        //   ),
        //   onPressed: () {
        //     Navigator.of(context).push(MaterialPageRoute(
        //         builder: (BuildContext context) => EditProfilePage()));
        //   },
        // ),
        //   IconButton(
        //     icon: Icon(
        //       Icons.add,
        //       color: AppColors.primary,
        //     ),
        //     onPressed: () {
        //       Navigator.of(context).push(MaterialPageRoute(
        //           builder: (BuildContext context) => createPost()));
        //     },
        //   ),
        // ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(8),
        child:
    //SingleChildScrollView(
          //child:
        // SafeArea(
            // child: Padding(
            //  padding: const EdgeInsets.all(8.0),
              //child:

              Column(
                children: [
                  RefreshIndicator(
                      onRefresh: ref,
                    backgroundColor: AppColors.secondaryDark,
                    color: AppColors.primary,
                    strokeWidth: 3,
                    child: Container(
                      height: MediaQuery.of(context).size.height/1.22,
                      width: MediaQuery.of(context).size.width,
                      child: FutureBuilder(
                        future: getUsers(),
                        builder: (context, snapshot){
                          if(snapshot.connectionState == ConnectionState.done) {
                            //if (tempusers[index].state == true) {

                              return Center(
                                child: ListView.builder(
                                  itemCount: tempusers.length,
                                  itemBuilder: (context, index) {
                                    return ListView.builder(
                                      shrinkWrap: true,
                                      physics: ScrollPhysics(),
                                      itemCount: tempusers[index].post1.length,
                                      itemBuilder: (context, idx) {
                                        return ListTile(
                                          title: PostCard(
                                            tempuser: tempusers[index],
                                            index: idx,
                                            notInVis: true,
                                             isPublic: tempusers[index].state,
                                            // postDocID: "user${idx.toString()}post${index}",
                                            //postDocID: "user${idx.toString()}post${postTokens[index][postTokens[index].length-1]}",
                                            // ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              );
                            //}
                          }
                          return const Center(child: CircularProgressIndicator(),);
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
          //),
        //),
      ),
    );



  }
}//
