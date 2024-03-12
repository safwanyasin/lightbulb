import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lightbulb/routes/edit_profile.dart';
import 'package:lightbulb/ui/post.dart';
import 'package:lightbulb/ui/search_and_explore_card.dart';
import 'package:lightbulb/util/colors.dart';
import 'package:lightbulb/util/styles.dart';
import 'package:lightbulb/util/screen_sizes.dart';
import 'package:lightbulb/util/button_styling.dart';
import 'package:lightbulb/routes/settings.dart';
import '../analytics.dart';
import '../model/classes.dart';
import '../ui/topics.dart';
import '../util/dimensions.dart';
import '../util/create_material_color.dart';

class SearchAndExplore extends StatefulWidget {
  const SearchAndExplore(
      {Key? key, required this.analytics, required this.observer})
      : super(key: key);

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  State<SearchAndExplore> createState() => _SearchAndExploreState();

  static const String routeName = '/searchandexplore';
}

class _SearchAndExploreState extends State<SearchAndExplore> {
  List<dynamic> myUserItems = [];
  List<String> myUserNames = [];
  List<String> myProfPic = [];
  List<searchUsers> userDetails = [];
  List<searchUsers> myUserList = [];
  final controller = TextEditingController();

  Future getUsers() async {
    QuerySnapshot querySnapshotUser =
        await FirebaseFirestore.instance.collection('users').get();
    for (int i = 0; i < querySnapshotUser.docs.length; i++) {
      myUserItems.add(querySnapshotUser.docs[i]);
      String username = querySnapshotUser.docs[i]["username"];
      // myUserNames.add(username);
      String profPic = querySnapshotUser.docs[i]["profpic"];
      // myProfPic.add(profPic);
      bool checkifexists = false;
      for (int j = 0; j < userDetails.length; j++) {
        if (username == userDetails[j].username) {
          checkifexists = true;
          break;
        }
      }
      if (checkifexists != true) {
        userDetails.add(searchUsers(username: username, profImage: profPic));
      }

      print(username);
      print(profPic);
    }
    // myUserList = userDetails;
    for (int i = 0; i < 5; i++) {
      myUserList.add(userDetails[i]);
    }
    print(myUserList);
    // return myUserList;
    // print(myUserList);
  }

  @override
  initState() {
    super.initState();
    // print(myUserList);
    setCurrentScreen(
        widget.analytics, 'Search and Explore page', 'searchandexplorePage');
    getUsers();
    // print(myUserList);
  }

  List<dynamic> myTopicList = [];

  void searchUser(String query) {
    // final suggestions = userDetails.where((userDetail) {
    //   final userName = userDetail.username.toLowerCase();
    //   final input = query.toLowerCase();
    //   return userName.contains(input);
    // }).toList();
    final suggestions = userDetails.where((userDetail) {
      final userName = userDetail.username.toLowerCase();
      final input = query.toLowerCase();
      return userName.contains(input);
    }).toList();

    setState(() {
      myUserList = suggestions;
    });
  }

  Future getTopics() async {
    myTopicList.clear();
    QuerySnapshot myTopics =
        await FirebaseFirestore.instance.collection('topics').get();
    for (int i = 0; i < myTopics.docs.length; i++) {
      myTopicList.add(myTopics.docs[i]["topic"]);
    }
  }

  List<topicsInSearch> topicsList = [
    //topicsInSearch(Topic: "#Math", image: "https://www.theparisreview.org/blog/wp-content/uploads/2019/07/istock-512102071.jpg"),
    //topicsInSearch(Topic: "#ComputerScience", image: "https://i.pinimg.com/736x/e9/88/b6/e988b66e788ce0f049190c4ec8587f17.jpg"),
    //topicsInSearch(Topic: "#Biology", image: "https://data.whicdn.com/images/330805121/original.jpg?t=1558830645"),
    //topicsInSearch(Topic: "#Psychology", image: "https://wallpaperaccess.com/full/6679227.png"),
    //topicsInSearch(Topic: "#Mechatronics", image: "https://www.springwise.com/wp-content/uploads/2019/02/Tech_Explained_Dark_Data_Springwise.jpg"),
    //topicsInSearch(Topic: "#Law", image: "https://thumbs.dreamstime.com/b/justice-law-background-concept-constitution-lawyer-aesthetics-justice-118485209.jpg"),
    //topicsInSearch(Topic: "#Arts", image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTNde8XihrNaEYf5o5VkUzfJFe0AbJsCLFiGw&usqp=CAU"),
  ];
  // List<searchUsers> dummyList = [
  //   searchUsers(username: 'hello', profImage: 'www'),
  //   searchUsers(username: 'hell2', profImage: 'www'),
  //   searchUsers(username: 'hllo3', profImage: 'www'),
  // ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primarySwatch: createMaterialColor(AppColors.secondaryDark)),
      home: Scaffold(
        backgroundColor: AppColors.primary,
        appBar: AppBar(
          backgroundColor: AppColors.secondaryDark,
          title: Text(
            'Explore',
            style: navBarHeadingStyle,
          ),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: AppColors.primary,
            ),
          ),
          actions: [],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Container(
                  child: //FutureBuilder(
                      //future: getUsers(),
                      //builder: (context, snapshot) {
                      //if (snapshot.connectionState == ConnectionState.done) {
                      // print(myUserList);
                      Container(
                          height: screenHeight(context) / 1.2,
                          child: Column(
                            children: [
                              TextFormField(
                                style: lsInputTextStyle,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        color: AppColors.white,
                                        width: 1,
                                      )),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        color: AppColors.white,
                                        width: 1,
                                      )),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      color: AppColors.white,
                                      width: 1,
                                    ),
                                  ),
                                  errorStyle: lsErrorTextStyle,
                                  label: Container(
                                    width: screenWidth(context) / 2.6,
                                    child: const Text(
                                      'Search for users or topics...',
                                      style: TextStyle(color: AppColors.grey),
                                    ),
                                  ),
                                  fillColor: AppColors.primary,
                                  filled: true,
                                  labelStyle: lsInputTextStyle,
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: AppColors.white,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                // onSaved: (value) {
                                //
                                // },
                                onChanged: searchUser,
                              ),
                              // ),
                              SizedBox(height: 15),
                              Expanded(
                                child: ListView.builder(
                                  // itemCount: myUserList.length,
                                  physics: ScrollPhysics(),
                                  // shrinkWrap: true,
                                  itemCount: myUserList.length,
                                  itemBuilder: (context, index) {
                                    // final oneUser = myUserList[index];
                                    // print('OneUser ${oneUser} ');
                                    // return SearchAndExploreCard(userData: oneUser);
                                    final userObj = myUserItems[index];
                                    return SearchAndExploreCard(
                                        userData: myUserList[index]);
                                  },
                                ),
                              ),
                            ],
                          )
                          //);

                          //}
                          //return const Center(child: CircularProgressIndicator(),);
                          //}
                          )),
              // Text(myUserList[0].username),
            ],
            // children: [
            //   Container(
            //     // padding: EdgeInsets.all(8),
            //     margin: const EdgeInsets.fromLTRB(0, 15, 0, 11),
            //     height: screenHeight(context)/9,
            //     width: screenWidth(context)/1.09,
            //     child: TextFormField(
            //       style: lsInputTextStyle,
            //       keyboardType: TextInputType.text,
            //       decoration: InputDecoration(
            //         focusedBorder: OutlineInputBorder(
            //             borderRadius: BorderRadius.circular(10),
            //             borderSide: const BorderSide(
            //               color: AppColors.white,
            //               width: 1,
            //             )
            //         ),
            //         enabledBorder: OutlineInputBorder(
            //             borderRadius: BorderRadius.circular(10),
            //             borderSide: const BorderSide(
            //               color: AppColors.white,
            //               width: 1,
            //             )
            //         ),
            //         errorBorder: OutlineInputBorder(
            //           borderRadius: BorderRadius.circular(10),
            //           borderSide: const BorderSide(
            //             color: AppColors.white,
            //             width: 1,
            //           ),
            //         ),
            //         errorStyle: lsErrorTextStyle,
            //         label: Container(
            //           width: screenWidth(context)/2.6,
            //           child: const Text('Search for users or topics...', style: TextStyle(color: AppColors.grey),),
            //         ),
            //         fillColor: AppColors.primary,
            //         filled: true,
            //         labelStyle: lsInputTextStyle,
            //         border: OutlineInputBorder(
            //           borderSide: const BorderSide(
            //             color: AppColors.white,
            //             width: 1,
            //           ),
            //           borderRadius: BorderRadius.circular(10),
            //         ),
            //       ),
            //       // onSaved: (value) {
            //       //
            //       // },
            //       // onChanged: searchUser,
            //     ),
            //   ),

            //   ListView.builder(
            //     itemCount: myUserList.length,
            //     itemBuilder: (context, index) {
            //       final oneUser = myUserList[index];
            //
            //       return SearchAndExploreCard(userData: oneUser);
            //     },
            //   ),
            //   // SafeArea(
            //   //   minimum: EdgeInsets.fromLTRB(0, screenHeight(context)/9, 0, 0),
            //   //   child: SingleChildScrollView(
            //   //   //  child: SafeArea(
            //   //         child: Padding(
            //   //           padding: const EdgeInsets.all(0),
            //   //           child: Column(
            //   //             children: [
            //   //               FutureBuilder(
            //   //                 future: getTopics(),
            //   //                   builder: (context, snapshot){
            //   //                     return Wrap(
            //   //                       children: [
            //   //                         for(int i = 0; i < myTopicList.length; i++)//{
            //   //                           Wrap(
            //   //                             children: [
            //   //                               SizedBox(width: 10,),
            //   //                               InputChip(
            //   //
            //   //                                 padding: EdgeInsets.all(8),
            //   //                                 labelStyle: chipStyle,
            //   //                                 label: Text(
            //   //                                   myTopicList[i],
            //   //                                 ),
            //   //                                 backgroundColor: AppColors.secondaryDark,
            //   //                                 onPressed: () {},
            //   //                               ),
            //   //                             ],
            //   //                           ),
            //   //
            //   //                         //}
            //   //                       ],
            //   //                     );
            //   //                   }
            //   //               )
            //   //             ],
            //   //           ),
            //   //         )
            //   //     //),
            //   //   ),
            //   // ),
            // ],
          ),
        ),
      ),
    );
  }
}
