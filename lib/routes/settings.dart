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
class SettingsPage extends StatefulWidget {
  const SettingsPage(
      {Key? key, required this.analytics, required this.observer})
      : super(key: key);

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  _SettingsPageState createState() => _SettingsPageState();

  static const String routeName = '/settings';
}

class _SettingsPageState extends State<SettingsPage> {
  final AuthService _auth = AuthService();
  DBService db = DBService();

  final _formKey = GlobalKey<FormState>();
  var newPass = '';
  final newPassController = TextEditingController();

  @override
  void dispose() {
    newPassController.dispose();
    super.dispose();
  }

  final currUser = FirebaseAuth.instance.currentUser;

  void showToast(String message, Toast t) => Fluttertoast.showToast(
        toastLength: t,
        msg: message,
        fontSize: 18.0,
      );

  changePass() async {
    try {
      await currUser!.updatePassword(newPass);
      await _auth.signOut();
      Navigator.pushNamedAndRemoveUntil(context, '/welcome', (route) => false);
      showToast("Password updated. Please login again.", Toast.LENGTH_SHORT);
    } catch (error) {
      print(error);
    }
  }

  bool state = false;
  Future getState() async {
    SharedPreferences? prefs = await SharedPreferences.getInstance();
    String? cuID = prefs!.getString('userID');
    DocumentSnapshot u =
        await FirebaseFirestore.instance.collection('users').doc(cuID).get();
    state = u['private'];
    // for (int i = 0; i < u.docs.length; i++) {
    //   if (u.docs[i]["token1"] == cuID) {
    //     state = u.docs[i]["state"];
    //   }
    // }
  }

  Future changeState() async {
    List<dynamic> dummy = [];
    SharedPreferences? prefs = await SharedPreferences.getInstance();
    String? cuID = prefs!.getString('userID');
    // DocumentSnapshot u =
    //     await FirebaseFirestore.instance.collection('users').doc(cuID).get();
    final data = {'private': !state};
    await FirebaseFirestore.instance
        .collection('users')
        .doc(cuID)
        .set(data, SetOptions(merge: true));
    // for (int i = 0; i < u.docs.length; i++) {
    //   if (u.docs[i]["token1"] == cuID) {
    //     if (st == "priv") {
    //       await db.addUser(
    //           true,
    //           u.docs[i]["email"],
    //           u.docs[i]["bio"],
    //           u.docs[i]["posts"],
    //           u.docs[i]["profpic"],
    //           u.docs[i]["followReq"],
    //           u.docs[i]["followingList"],
    //           u.docs[i]["followersList"],
    //           u.docs[i]["name"],
    //           u.docs[i]["username"],
    //           u.docs[i]["password"],
    //           u.docs[i]["sentReq"],
    //           u.docs[i]["token1"],
    //           'caption',
    //           dummy,
    //           'image',
    //           0,
    //           0,
    //           'location',
    //           'post0',
    //           'notiContent',
    //           'notiSender',
    //           'notiToken',
    //           u.docs[i]["notifsList"],
    //           'notThis');
    //     }
    //     if (st == "pub") {
    //       await db.addUser(
    //           false,
    //           u.docs[i]["email"],
    //           u.docs[i]["bio"],
    //           u.docs[i]["posts"],
    //           u.docs[i]["profpic"],
    //           u.docs[i]["followReq"],
    //           u.docs[i]["followingList"],
    //           u.docs[i]["followersList"],
    //           u.docs[i]["name"],
    //           u.docs[i]["username"],
    //           u.docs[i]["password"],
    //           u.docs[i]["sentReq"],
    //           u.docs[i]["token1"],
    //           'caption',
    //           dummy,
    //           'image',
    //           0,
    //           0,
    //           'location',
    //           'post0',
    //           'notiContent',
    //           'notiSender',
    //           'notiToken',
    //           u.docs[i]["notifsList"],
    //           'notThis');
    //     }
    //   }
    // }
    setState(() {
      getState();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings",
            style: GoogleFonts.nunito(
              color: AppColors.primary,
              fontWeight: FontWeight.w900,
              fontSize: 30.0,
            )),
        centerTitle: true,
        backgroundColor: AppColors.secondaryDark,
        elevation: 1,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
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
            const SizedBox(
              height: 40,
            ),
            Row(
              children: [
                const Icon(
                  Icons.password,
                  color: AppColors.white,
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  "Password",
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondaryDark,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Form(
              key: _formKey,
              child: Container(
                //color: AppColors.secondaryDark,
                //height: MediaQuery.of(context).size.height / 15,
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                height: screenHeight(context, dividedBy: 21),
                //width: MediaQuery.of(context).size.width / 1.3,
                width: screenWidth(context, dividedBy: 1.1),
                child: TextFormField(
                  autofocus: false,
                  obscureText: true,
                  style: lsInputTextStyle,
                  decoration: InputDecoration(
                    labelText: "New passoword",
                    labelStyle: lsInputTextStyle,
                    hintText: "Enter new password",
                    hintStyle: GoogleFonts.nunito(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.grey,
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: AppColors.white,
                        )),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: AppColors.white,
                        )),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: AppColors.white,
                      ),
                    ),
                    // labelStyle: GoogleFonts.nunito(
                    //   fontSize: 16,
                    //   fontWeight: FontWeight.bold,
                    //   color: AppColors.white,
                    // ),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: AppColors.white,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    // errorStyle: GoogleFonts.nunito(
                    //   fontSize: 16,
                    //   fontWeight: FontWeight.bold,
                    //   color: AppColors.grey,
                    // ),
                    errorStyle: lsErrorTextStyle,
                  ),
                  //controller: newPassController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a password";
                    }
                    //return null;
                  },
                  onSaved: (value) {
                    newPass = value.toString();
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  // setState(() {
                  //   newPass = newPassController.text;
                  // });
                  changePass();
                }
              },
              style: ElevatedButton.styleFrom(
                elevation: 0,
                primary: AppColors.greyDarker,
              ),
              child: Text(
                "Change password",
                style: GoogleFonts.nunito(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Row(
              children: [
                const Icon(
                  Icons.person,
                  color: AppColors.white,
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  "Privacy",
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondaryDark,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),

            Container(
              //color: AppColors.secondaryDark,
              height: MediaQuery.of(context).size.height / 15,
              width: MediaQuery.of(context).size.width / 1.3,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Account type:",
                      style: GoogleFonts.nunito(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.grey,
                      ),
                    ),
                    FutureBuilder(
                        future: getState(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return state == true
                                ? Text(
                                    "Private",
                                    style: GoogleFonts.nunito(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.white,
                                    ),
                                  )
                                : Text(
                                    "Public",
                                    style: GoogleFonts.nunito(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.white,
                                    ),
                                  );

                            // if (state == true) {
                            //   return Text(
                            //     "Private",
                            //     style: GoogleFonts.nunito(
                            //       fontSize: 16,
                            //       fontWeight: FontWeight.bold,
                            //       color: AppColors.white,
                            //     ),
                            //   );
                            // }
                          }
                          return Text("");
                        }),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            FutureBuilder(
                future: getState(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return ElevatedButton(
                      onPressed: () async {
                        changeState();
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        primary: AppColors.greyDarker,
                      ),
                      child: state == true
                          ? Text(
                              "Change to public",
                              style: GoogleFonts.nunito(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.white,
                              ),
                            )
                          : Text(
                              "Change to private",
                              style: GoogleFonts.nunito(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.white,
                              ),
                            ),
                    );

                    // if (state == true) {
                    //   return ElevatedButton(
                    //     onPressed: () async {
                    //       changeState(false);
                    //     },
                    //     style: ElevatedButton.styleFrom(
                    //       elevation: 0,
                    //       primary: AppColors.greyDarker,
                    //     ),
                    //     child: Text(
                    //       "Change to public",
                    //       style: GoogleFonts.nunito(
                    //         fontSize: 16,
                    //         fontWeight: FontWeight.bold,
                    //         color: AppColors.white,
                    //       ),
                    //     ),
                    //   );
                    // }
                  }
                  return Text("");
                }),
            const Divider(
              height: 15,
              thickness: 2,
            ),
            const SizedBox(
              height: 10,
            ),

            const SizedBox(
              height: 40,
            ),
            Row(
              children: [
                // const Icon(
                //  Icons.volume_up_outlined,
                //  color: AppColors.white,
                // ),
                const SizedBox(
                  width: 8,
                ),
                // Text(
                //   "Notifications",
                //  style: GoogleFonts.nunito(
                //    fontSize: 16,
                //    fontWeight: FontWeight.bold,
                //     color: AppColors.secondaryDark,
                //   ),
                // ),
              ],
            ),
            // const Divider(
            //   height: 15,
            //   thickness: 2,
            // ),
            const SizedBox(
              height: 10,
            ),
            // buildNotificationOptionRow("New for you", true),
            // buildNotificationOptionRow("Account activity", true),
            // buildNotificationOptionRow("Opportunity", false),
            // const SizedBox(
            //   height: 50,
            // ),
            Center(
              child: Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 11),
                child: OutlinedButton(
                    onPressed: () async {
                      // QuerySnapshot pic = await FirebaseFirestore.instance.collection("image").get();
                      // for(int i = 1; i < pic.docs.length; i++){
                      //  await FirebaseFirestore.instance.collection("image").doc(pic.docs[i]["token"]).delete();
                      // }
                      //QuerySnapshot cu = ""
                      // await FirebaseFirestore.instance.collection('currUser').doc(cu.docs[0]["token"]).delete();
                      logCustomEvent(widget.analytics, 'user signed out');
                      await _auth.signOut();
                      QuerySnapshot au = await FirebaseFirestore.instance
                          .collection('activeUser')
                          .get();
                      
                      SharedPreferences? prefs =
                          await SharedPreferences.getInstance();
                      prefs!.setBool('isLoggedIn', false);
                      prefs!.setString('userID', "null");
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/welcome', (route) => false);
                    },
                    child: const Text(
                      'Sign Out',
                      style: lsButtonTextStyle,
                    ),
                    style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                      color: Color(0x00000000),
                    ))),
                decoration: ButtonStyling.lsButton,
                height: 40,
              ),
            )
          ],
        ),
      ),
    );
  }

  Row buildNotificationOptionRow(String title, bool isActive) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.nunito(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.grey,
          ),
        ),
        Transform.scale(
            scale: 0.7,
            child: CupertinoSwitch(
              activeColor: AppColors.secondaryDark,
              value: isActive,
              onChanged: (bool val) {
                setState(() {
                  isActive = false;
                });
              },
            ))
      ],
    );
  }
}
