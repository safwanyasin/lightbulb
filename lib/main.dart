import 'package:flutter/material.dart';
import 'package:lightbulb/routes/followers_page.dart';
import 'package:lightbulb/routes/following_page.dart';
import 'package:lightbulb/routes/edit_post.dart';
import 'package:lightbulb/routes/login.dart';
import 'package:lightbulb/routes/notifications.dart';
import 'package:lightbulb/routes/profile_page.dart';
import 'package:lightbulb/routes/signup.dart';
import 'package:lightbulb/routes/visited_profile.dart';
import 'package:lightbulb/routes/welcome.dart';
import 'package:lightbulb/routes/search_and_explore.dart';
import 'package:lightbulb/routes/edit_profile.dart';
import 'package:lightbulb/routes/settings.dart';
import 'package:lightbulb/ui/bottom_nav.dart';
import 'package:lightbulb/util/auth.dart';
import 'package:lightbulb/util/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'analytics.dart';
import 'model/walkthrough.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lightbulb/util/colors.dart';
import 'package:lightbulb/util/create_material_color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // const MyApp({Key? key, required this.analytics}) : super(key: key);
  const MyApp({Key? key}) : super(key: key);

  // final FirebaseAnalytics analytics;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // static FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  int? firstLoad;
  String? userID;
  SharedPreferences? prefs;
  final Future<FirebaseApp> _init = Firebase.initializeApp();

  decideRoute() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      firstLoad = (prefs!.getInt('appInitialLoad') ?? 0);
      userID = (prefs!.getString('userID') ?? "");
    });
  }

  @override
  void initState() {
    super.initState();
    decideRoute();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _init,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return ErrorScreen(message: snapshot.error.toString());
        }
        if (snapshot.connectionState == ConnectionState.done) {
          if (firstLoad == null) {
            return Container();
          } else if (firstLoad == 0) {
            firstLoad = 1;
            prefs!.setInt('appInitialLoad', firstLoad!);
            // setCurrentScreen(widget.analytics, 'Walkthrough', 'walkthrough-page');
            // return MaterialApp(
            //     home: WalkThrough(),
            //     routes: {
            //       // '/': (context) => Login(),
            //       SignUp.routeName: (context) => SignUp(),
            //       Login.routeName: (context) => Login(),
            //       BottomNav.routeName: (context) => const BottomNav(),
            //       Welcome.routeName: (context) => Welcome(),
            //     },
            //     theme: ThemeData(
            //         primarySwatch: createMaterialColor(AppColors.secondaryDark)
            //     )
            // );
            return AppBaseWalkthrough();
          } else {
            // return StreamProvider<User?>.value(
            //   value: AuthService().user,
            //   initialData: null,
            //   child: AuthenticationStatus(),
            // );
            // return MaterialApp(
            //     routes: {
            //       '/': (context) => FirebaseAuth.instance.currentUser == null ? Login() : const BottomNav(),
            //       SignUp.routeName: (context) => SignUp(),
            //       Login.routeName: (context) => Login(),
            //       BottomNav.routeName: (context) => const BottomNav(),
            //       Welcome.routeName: (context) => Welcome(),
            //     },
            //     theme: ThemeData(
            //         primarySwatch: createMaterialColor(AppColors.secondaryDark)
            //     )
            // );
            // print("---------------------");
            // print(prefs!.getString("userID"));
            return AppBase(isLoggedIn: prefs!.getBool("isLoggedIn") ?? false);
          }
        }
        return const WaitingScreen();
      },
    );
  }
}
// class AuthenticationStatus extends StatefulWidget {
//   const AuthenticationStatus({Key? key}) : super(key: key);
//
//   @override
//   State<AuthenticationStatus> createState() => _AuthenticationStatusState();
// }
//
// class _AuthenticationStatusState extends State<AuthenticationStatus> {
//   @override
//   Widget build(BuildContext context) {
//     final user = Provider.of<User?>(context);
//
//     if(user == null) {
//       return MaterialApp(
//           routes: {
//             '/': (context) => Welcome(analytics: ,),
//             SignUp.routeName: (context) => SignUp(),
//             Login.routeName: (context) => Login(),
//             BottomNav.routeName: (context) => const BottomNav(),
//             Welcome.routeName: (context) => Welcome(),
//           },
//           theme: ThemeData(
//               primarySwatch: createMaterialColor(AppColors.secondaryDark)
//           )
//       );
//     } else {
//       return MaterialApp(
//           routes: {
//             '/': (context) => const BottomNav(),
//             SignUp.routeName: (context) => SignUp(),
//             Login.routeName: (context) => Login(),
//             BottomNav.routeName: (context) => const BottomNav(),
//             Welcome.routeName: (context) => Welcome(),
//           },
//           theme: ThemeData(
//               primarySwatch: createMaterialColor(AppColors.secondaryDark)
//           )
//       );
//     }
//   }
// }

class ErrorScreen extends StatelessWidget {
  final String appLogo = 'lib/assets/icons/appLogo.png';
  final String bg = 'lib/assets/backgrounds/lsBg.png';
  const ErrorScreen({Key? key, required this.message}) : super(key: key);

  final String message;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('LightBulb'),
          centerTitle: true,
        ),
        body: Container(
          child: Center(
              child: Column(
            children: [
              Image.asset(
                appLogo,
                width: 100,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 5, 0, 30),
                child: Text(
                  'LightBulb',
                  style: appNameHeadingStyle,
                ),
              ),
              Text(
                message,
                style: walkthroughDescription,
              )
            ],
          )),
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage(bg),
            fit: BoxFit.cover,
          )),
        ),
      ),
    );
  }
}

class WaitingScreen extends StatelessWidget {
  final String appLogo = 'lib/assets/icons/appLogo.png';
  final String bg = 'lib/assets/backgrounds/lsBg.png';
  const WaitingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          child: Center(
            child: Column(
              children: [
                Image.asset(
                  appLogo,
                  width: 100,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 30),
                  child: Text(
                    'LightBulb',
                    style: appNameHeadingStyle,
                  ),
                ),
                Text(
                  'Connecting to Firebase',
                  style: appNameHeadingStyle,
                ),
              ],
            ),
          ),
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage(bg),
            fit: BoxFit.cover,
          )),
        ),
      ),
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({
//     Key? key,
//     required this.title,
//     required this.analytics
//   }) : super(key: key);
//
//   final String title;
//   final FirebaseAnalytics analytics;
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }

class AppBaseWalkthrough extends StatelessWidget {
  const AppBaseWalkthrough({Key? key}) : super(key: key);

  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        navigatorObservers: <NavigatorObserver>[observer],
        home: WalkThrough(analytics: analytics, observer: observer),
        routes: {
          // '/': (context) => Login(),
          SignUp.routeName: (context) =>
              SignUp(analytics: analytics, observer: observer),
          Login.routeName: (context) =>
              Login(analytics: analytics, observer: observer),
          BottomNav.routeName: (context) =>
              BottomNav(analytics: analytics, observer: observer),
          Welcome.routeName: (context) =>
              Welcome(analytics: analytics, observer: observer),
          SearchAndExplore.routeName: (context) =>
              SearchAndExplore(analytics: analytics, observer: observer),
          EditProfilePage.routeName: (context) =>
              EditProfilePage(analytics: analytics, observer: observer),
          SettingsPage.routeName: (context) =>
              SettingsPage(analytics: analytics, observer: observer),
          ProfilePage.routeName: (context) =>
              ProfilePage(analytics: analytics, observer: observer),
          EditPost.routeName: (context) =>
              EditPost(analytics: analytics, observer: observer),
          VisitedProfilePage.routeName: (context) =>
              VisitedProfilePage(analytics: analytics, observer: observer),
          FollowersPage.routeName: (context) =>
              FollowersPage(analytics: analytics, observer: observer),
          FollowingPage.routeName: (context) =>
              FollowingPage(analytics: analytics, observer: observer),
          NotificationsPage.routeName: (context) =>
              NotificationsPage(analytics: analytics, observer: observer),
        },
        theme: ThemeData(
            primarySwatch: createMaterialColor(AppColors.secondaryDark)));
  }
}

class AppBase extends StatelessWidget {
  bool isLoggedIn;
  AppBase({Key? key, required this.isLoggedIn}) : super(key: key);

  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        navigatorObservers: <NavigatorObserver>[observer],
        home: isLoggedIn == false
            ? Welcome(analytics: analytics, observer: observer)
            : BottomNav(analytics: analytics, observer: observer),
        routes: {
          // '/': (context) => FirebaseAuth.instance.currentUser == null ? Welcome(analytics: analytics, observer: observer) : const BottomNav(analytics: analytics, observer: observer),
          SignUp.routeName: (context) =>
              SignUp(analytics: analytics, observer: observer),
          Login.routeName: (context) =>
              Login(analytics: analytics, observer: observer),
          BottomNav.routeName: (context) =>
              BottomNav(analytics: analytics, observer: observer),
          Welcome.routeName: (context) =>
              Welcome(analytics: analytics, observer: observer),
          SearchAndExplore.routeName: (context) =>
              SearchAndExplore(analytics: analytics, observer: observer),
          EditProfilePage.routeName: (context) =>
              EditProfilePage(analytics: analytics, observer: observer),
          SettingsPage.routeName: (context) =>
              SettingsPage(analytics: analytics, observer: observer),
          ProfilePage.routeName: (context) =>
              ProfilePage(analytics: analytics, observer: observer),
          EditPost.routeName: (context) =>
              EditPost(analytics: analytics, observer: observer),
          VisitedProfilePage.routeName: (context) =>
              VisitedProfilePage(analytics: analytics, observer: observer),
          FollowersPage.routeName: (context) =>
              FollowersPage(analytics: analytics, observer: observer),
          FollowingPage.routeName: (context) =>
              FollowingPage(analytics: analytics, observer: observer),
          NotificationsPage.routeName: (context) =>
              NotificationsPage(analytics: analytics, observer: observer),
        },
        theme: ThemeData(
            primarySwatch: createMaterialColor(AppColors.secondaryDark)));
  }
}
