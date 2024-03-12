import 'dart:io' show Platform;
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lightbulb/util/auth.dart';
import 'package:lightbulb/util/colors.dart';
import 'package:lightbulb/util/dimensions.dart';
import 'package:lightbulb/util/screen_sizes.dart';
import 'package:lightbulb/util/styles.dart';
import 'package:lightbulb/util/button_styling.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../analytics.dart';
import '../ui/bottom_nav.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../util/db.dart';

class Login extends StatefulWidget {
  const Login({Key? key, required this.analytics, required this.observer})
      : super(key: key);

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  _LoginState createState() => _LoginState();

  static const String routeName = '/login';
}

class _LoginState extends State<Login> {
  @override
  initState() {
    super.initState();
    setCurrentScreen(widget.analytics, 'Login Page', 'loginPage');
  }

  int loginCounter = 0;
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String pass = '';
  String name = '@sillygoose';
  String username = '';
  final String googleIcon = 'lib/assets/icons/googleLogo.svg';
  final String appLogo = 'lib/assets/icons/appLogo.png';
  final String bg = 'lib/assets/backgrounds/lsBg.png';

  final AuthService _auth = AuthService();
  DBService db = DBService();

  Future loginUser() async {
    dynamic result = await _auth.signInWithEmailPass(email, pass);
    if (result is String) {
      _showDialog('Login Error', result);
    } else if (result is UserCredential) {
      //User signed in
      SharedPreferences? prefs = await SharedPreferences.getInstance();
      prefs!.setBool('isLoggedIn', true);
      prefs!.setString('userID', result.user!.uid);
      Navigator.pushNamedAndRemoveUntil(
          context, '/bottomNav', (route) => false);
    } else {
      _showDialog('Login Error', result.toString());
    }
  }

  Future<void> _showDialog(String title, String message) async {
    bool isAndroid = Platform.isAndroid;
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          if (isAndroid) {
            return AlertDialog(
              title: Text(title),
              content: SingleChildScrollView(
                child: ListBody(
                  children: [
                    Text(message),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          } else {
            return CupertinoAlertDialog(
              title: Text(title, style: lsInputTextStyle),
              content: SingleChildScrollView(
                child: ListBody(
                  children: [
                    Text(message, style: lsInputTextStyle),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          }
        });
  }

  List<String> dummy = ["dummy", "dummy"];
  List<dynamic> dummy2 = ["dummy2", "dummy2"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(
      //     'LOGIN',
      //     style: kAppBarTitleTextStyle,
      //   ),
      //   backgroundColor: AppColors.primary,
      //   centerTitle: true,
      //   elevation: 0.0,
      // ),
      resizeToAvoidBottomInset: false,
      body: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Container(
                      width: screenWidth(context) / 1.4,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            appLogo,
                            width: screenHeight(context) / 8.44,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 30),
                            child: Text(
                              'LightBulb',
                              style: appNameHeadingStyle,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(25, 0, 25, 40),
                            child: Container(
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Container(
                                      // padding: EdgeInsets.all(8),
                                      margin: const EdgeInsets.fromLTRB(
                                          0, 0, 0, 11),
                                      width:
                                          screenWidth(context, dividedBy: 1.1),
                                      height:
                                          screenHeight(context, dividedBy: 21),
                                      child: TextFormField(
                                        style: lsInputTextStyle,
                                        keyboardType: TextInputType.text,
                                        enableSuggestions: false,
                                        autocorrect: false,
                                        decoration: InputDecoration(
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: const BorderSide(
                                                color: AppColors.white,
                                              )),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: const BorderSide(
                                                color: AppColors.white,
                                              )),
                                          errorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                              color: AppColors.white,
                                            ),
                                          ),
                                          errorStyle: lsErrorTextStyle,
                                          label: Container(
                                            width: 75,
                                            child: const Text('Username'),
                                          ),
                                          fillColor: AppColors.primary,
                                          filled: true,
                                          labelStyle: lsInputTextStyle,
                                          border: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: AppColors.white,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value != null) {
                                            if (value.isEmpty) {
                                              return 'Cannot leave username empty';
                                            }
                                            // if(value.length < 6) {
                                            //   return 'Password too short';
                                            // }
                                          }
                                        },
                                        onSaved: (value) {
                                          username = value ?? '';
                                        },
                                      ),
                                    ),
                                    Container(
                                      // padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
                                      margin: const EdgeInsets.fromLTRB(
                                          0, 0, 0, 11),
                                      // padding: EdgeInsets.all(0),
                                      width:
                                          screenWidth(context, dividedBy: 1.1),
                                      height:
                                          screenHeight(context, dividedBy: 21),
                                      child: TextFormField(
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        style: lsInputTextStyle,
                                        decoration: InputDecoration(
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: const BorderSide(
                                                color: AppColors.white,
                                              )),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: const BorderSide(
                                                color: AppColors.white,
                                              )),
                                          errorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                              color: AppColors.white,
                                            ),
                                          ),
                                          errorStyle: lsErrorTextStyle,
                                          label: Container(
                                            width: 40,
                                            child: const Text('Email'),
                                          ),
                                          fillColor: AppColors.primary,
                                          filled: true,
                                          labelStyle: lsInputTextStyle,
                                          border: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: Colors.white,
                                              width: 3,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value != null) {
                                            if (value.isEmpty) {
                                              return 'Cannot leave e-mail empty';
                                            }
                                            if (!EmailValidator.validate(
                                                value)) {
                                              return 'Please enter a valid e-mail address';
                                            }
                                          }
                                        },
                                        onSaved: (value) {
                                          email = value ?? '';
                                        },
                                      ),
                                      // decoration: lsInputBoxStyle,
                                    ),
                                    Container(
                                      // padding: EdgeInsets.all(8),
                                      margin: const EdgeInsets.fromLTRB(
                                          0, 0, 0, 11),
                                      width:
                                          screenWidth(context, dividedBy: 1.1),
                                      height:
                                          screenHeight(context, dividedBy: 21),
                                      child: TextFormField(
                                        style: lsInputTextStyle,
                                        keyboardType: TextInputType.text,
                                        obscureText: true,
                                        enableSuggestions: false,
                                        autocorrect: false,
                                        decoration: InputDecoration(
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: const BorderSide(
                                                color: AppColors.white,
                                              )),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: const BorderSide(
                                                color: AppColors.white,
                                              )),
                                          errorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                              color: AppColors.white,
                                            ),
                                          ),
                                          errorStyle: lsErrorTextStyle,
                                          label: Container(
                                            width: 75,
                                            child: const Text('Password'),
                                          ),
                                          fillColor: AppColors.primary,
                                          filled: true,
                                          labelStyle: lsInputTextStyle,
                                          border: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: AppColors.white,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value != null) {
                                            if (value.isEmpty) {
                                              return 'Cannot leave password empty';
                                            }
                                            if (value.length < 6) {
                                              return 'Password too short';
                                            }
                                          }
                                        },
                                        onSaved: (value) {
                                          pass = value ?? '';
                                        },
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.fromLTRB(
                                          0, 0, 0, 11),
                                      child: OutlinedButton(
                                          onPressed: () async {
                                            logCustomEvent(widget.analytics,
                                                'Login attempt with email');
                                            if (_formKey.currentState!
                                                .validate()) {
                                              // print('Email: $email');
                                              _formKey.currentState!.save();

                                              await loginUser();
                                              // print('Email: $email');
                                              //db.addUser(true,email, "Enter Bio Here", 0, "https://www.tenforums.com/geek/gars/images/2/types/thumb_15951118880user.png", dummy2, dummy2, dummy2, username, name, pass, dummy2, email, 'caption', dummy2, "https://images-wixmp-530a50041672c69d335ba4cf.wixmp.com/templates/image/5bf41cca049f03cdc7e842db2201172d6cc1a6b173e8db293a3b880ecc5836561616582409012.jpg", 0, 0, 'location', 'postToken', 'notiContent', 'notiSender', 'notiToken', "1st");
                                              //db.addUser(email, dummy, dummy, name, username, pass, dummy, email, 'caption', dummy, 'https://images-wixmp-530a50041672c69d335ba4cf.wixmp.com/templates/image/5bf41cca049f03cdc7e842db2201172d6cc1a6b173e8db293a3b880ecc5836561616582409012.jpg', 0, 0, "location",'postToken', 'notiContent', 'notiSender', 'notiToken', "1st");
                                              //   Navigator.pushNamedAndRemoveUntil(context, '/bottomNav', (route) => false);
                                              //   initState();
                                              // });

                                            } else {
                                              _showDialog('Form Error',
                                                  'Your form is invalid');
                                            }
                                          },
                                          child: const Text(
                                            'Login',
                                            style: lsButtonTextStyle,
                                          ),
                                          style: OutlinedButton.styleFrom(
                                              side: const BorderSide(
                                            color: Color(0x00000000),
                                          ))),
                                      decoration: ButtonStyling.lsButton,
                                      height:
                                          screenHeight(context, dividedBy: 21),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.fromLTRB(
                                          0, 0, 0, 11),
                                      child: ElevatedButton.icon(
                                        onPressed: () async {
                                          logCustomEvent(widget.analytics,
                                              'Login attempt with fb');
                                          dynamic user =
                                              await _auth.signInWithFacebook();
                                          if (user != null) {
                                            Navigator.pushNamedAndRemoveUntil(
                                                context,
                                                '/bottomNav',
                                                (route) => false);
                                          }
                                        },
                                        // child: Padding(
                                        //   padding: const EdgeInsets.symmetric(vertical: 12.0),
                                        //   child: Row(
                                        //     // mainAxisAlignment: MainAxisAlignment.start,
                                        //     // crossAxisAlignment: CrossAxisAlignment.center,
                                        //     children: const [
                                        //       Icon(Icons.facebook, size: 20),
                                        //       Text(
                                        //       'Continue with Facebook',
                                        //       style: lsButtonTextStyle,
                                        //       ),
                                        //   ]
                                        //   ),
                                        // ),
                                        // style: OutlinedButton.styleFrom(
                                        //     side: const BorderSide(
                                        //       color: Color(0x00000000),
                                        //     )
                                        // )
                                        icon: const Icon(
                                          Icons.facebook,
                                          size: 25,
                                          color: AppColors.white,
                                        ),
                                        label: const Text(
                                          'Continue with Facebook',
                                          style:
                                              TextStyle(color: AppColors.white),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          shape: new RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(10),
                                          ),
                                          elevation: 0,
                                          primary: AppColors.fbColor,
                                        ),
                                      ),
                                      height:
                                          screenHeight(context, dividedBy: 21),
                                    ),
                                    Container(
                                      child: ElevatedButton.icon(
                                        onPressed: () async {
                                          // logCustomEvent(widget.analytics,
                                          //     'Login attempt with Google');
                                          dynamic user =
                                              await _auth.signInWithGoogle();

                                          if (user != null) {
                                            await thirdPartyAuth(user);
                                            Navigator.pushNamedAndRemoveUntil(
                                                context,
                                                '/bottomNav',
                                                (route) => false);
                                          }
                                        },
                                        // child: Padding(
                                        //   padding: const EdgeInsets.symmetric(vertical: 12.0),
                                        //   child: Row(
                                        //     // mainAxisAlignment: MainAxisAlignment.start,
                                        //     // crossAxisAlignment: CrossAxisAlignment.center,
                                        //     children: const [
                                        //       Icon(Icons.facebook, size: 20),
                                        //       Text(
                                        //       'Continue with Facebook',
                                        //       style: lsButtonTextStyle,
                                        //       ),
                                        //   ]
                                        //   ),
                                        // ),
                                        // style: OutlinedButton.styleFrom(
                                        //     side: const BorderSide(
                                        //       color: Color(0x00000000),
                                        //     )
                                        // )
                                        icon: SvgPicture.asset(googleIcon),
                                        label:
                                            const Text('Continue with Google',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                )),
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            side: BorderSide(
                                              color: Colors.black,
                                              width: 1,
                                            ),
                                          ),
                                          elevation: 0,
                                          primary: AppColors.white,
                                        ),
                                      ),
                                      height:
                                          screenHeight(context, dividedBy: 21),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamedAndRemoveUntil(
                                      context, '/signup', (route) => false);
                                },
                                child: Text("Don't have an account? Sign Up!",
                                    style: lsInputTextStyle),
                              ),
                            ],
                          ),
                        ],
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                            colors: [
                              AppColors.primaryLight,
                              AppColors.primaryLighter
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      constraints: BoxConstraints(
                        maxHeight: screenHeight(context) / 1.4,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage(bg),
          fit: BoxFit.cover,
        )),
      ),
    );
  }
}
