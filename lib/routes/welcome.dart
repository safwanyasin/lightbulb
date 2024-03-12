import 'dart:io' show Platform;
import 'dart:ui';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lightbulb/util/colors.dart';
import 'package:lightbulb/util/dimensions.dart';
import 'package:lightbulb/util/screen_sizes.dart';
import 'package:lightbulb/util/styles.dart';
import 'package:lightbulb/util/button_styling.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../analytics.dart';

class Welcome extends StatefulWidget {
  const Welcome({Key? key, required this.analytics, required this.observer})
      : super(key: key);

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  _WelcomeState createState() => _WelcomeState();

  static const String routeName = '/welcome';
}

class _WelcomeState extends State<Welcome> {
  @override
  initState() {
    super.initState();
    setCurrentScreen(widget.analytics, 'Welcome Page', 'welcomePage');
  }

  int loginCounter = 0;
  final String googleIcon = 'lib/assets/icons/googleLogo.svg';
  final String appLogo = 'lib/assets/icons/appLogo.png';
  final String bg = 'lib/assets/backgrounds/lsBg.png';

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
                            width: 100,
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 5, 0, 30),
                            child: Text(
                              'LightBulb',
                              style: appNameHeadingStyle,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(25, 0, 25, 40),
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Container(
                                    margin: EdgeInsets.fromLTRB(0, 0, 0, 11),
                                    child: OutlinedButton(
                                        onPressed: () {
                                          Navigator.pushNamed(
                                              context, '/login');
                                          // logCustomEvent(widget.analytics);
                                          // await AppAnalytics.setScreenName('login');
                                        },
                                        child: Text(
                                          'Login',
                                          style: lsButtonTextStyle,
                                        ),
                                        style: OutlinedButton.styleFrom(
                                            side: BorderSide(
                                          color: Color(0x00000000),
                                        ))),
                                    decoration: ButtonStyling.lsButton,
                                    height: 40,
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(0, 0, 0, 11),
                                    child: OutlinedButton(
                                        onPressed: () {
                                          Navigator.pushNamed(
                                              context, '/signup');
                                        },
                                        child: Text(
                                          'Sign Up',
                                          style: lsButtonTextStyle,
                                        ),
                                        style: OutlinedButton.styleFrom(
                                            side: BorderSide(
                                          color: Color(0x00000000),
                                        ))),
                                    decoration: ButtonStyling.lsButton,
                                    height: 40,
                                  ),
                                ],
                              ),
                            ),
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
                        maxHeight: screenHeight(context) / 1.8,
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
