import 'dart:ui';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lightbulb/routes/create_post.dart';
import 'package:lightbulb/routes/feed.dart';
import 'package:lightbulb/routes/messages.dart';
import 'package:lightbulb/routes/notifications.dart';
import 'package:lightbulb/model/bottom_nav_model.dart';
import 'package:lightbulb/routes/profile_page.dart';
import 'package:lightbulb/util/colors.dart';

import '../analytics.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({Key? key, required this.analytics, required this.observer})
      : super(key: key);

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  static const String routeName = '/bottomNav';
  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  late FirebaseAnalytics myAnalytics;
  late FirebaseAnalyticsObserver myObserver;

  @override
  initState() {
    super.initState();
    myAnalytics = widget.analytics;
    myObserver = widget.observer;
    setCurrentScreen(
        widget.analytics, 'main app after successful login', 'mainApp');
  }

  int _selectedIndex = 0;

  // runFeed() {
  //   Feed(analytics: widget.analytics, observer: widget.observer);
  // }

  // static final List<Widget> _bottomNavView = [
  //   Feed(),
  //   Messages(),
  //   CreatePost(),
  //   Notifications(),
  //   ProfilePage(),
  // ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    logCustomEvent(widget.analytics, 'Nav bar item $index tapped');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: showWidget(),
      ),
      bottomNavigationBar: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryLighter,
                  AppColors.primaryLight,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            child: BottomNavigationBar(
                elevation: 0,
                backgroundColor: Colors.black.withOpacity(0),
                currentIndex: _selectedIndex,
                onTap: _onItemTapped,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                selectedItemColor: Colors.black.withOpacity(0),
                unselectedItemColor: Colors.black.withOpacity(0),
                type: BottomNavigationBarType.fixed,
                items: _navBarItem
                    .map((f) => BottomNavigationBarItem(
                          icon: SvgPicture.asset(
                            f.icon,
                            width: 24.0,
                          ),
                          activeIcon: SvgPicture.asset(
                            f.activeIcon,
                            width: 24.0,
                          ),
                          label: f.title,
                        ))
                    .toList()),
          ),
        ),
      ),
      extendBody: true,
      extendBodyBehindAppBar: true,
    );
  }

  showWidget() {
    if (_selectedIndex == 0) {
      return Feed(analytics: widget.analytics, observer: widget.observer);
    } else if (_selectedIndex == 1) {
      return Messages(analytics: widget.analytics, observer: widget.observer);
    } else if (_selectedIndex == 2) {
      return CreatePost(analytics: widget.analytics, observer: widget.observer);
    } else if (_selectedIndex == 3) {
      return NotificationsPage(
          analytics: widget.analytics, observer: widget.observer);
    } else if (_selectedIndex == 4) {
      return ProfilePage(
          analytics: widget.analytics, observer: widget.observer);
    }
  }
}

List<NavBarModel> _navBarItem = [
  NavBarModel(
    icon: 'lib/assets/icons/home.svg',
    activeIcon: 'lib/assets/icons/homeSelected.svg',
    title: "feed",
    width: 35,
  ),
  NavBarModel(
    icon: 'lib/assets/icons/message.svg',
    activeIcon: 'lib/assets/icons/messageSelected.svg',
    title: "messages",
    width: 35,
  ),
  NavBarModel(
    icon: 'lib/assets/icons/add.svg',
    activeIcon: 'lib/assets/icons/addSelected.svg',
    title: "create post",
    width: 35,
  ),
  NavBarModel(
    icon: 'lib/assets/icons/bell.svg',
    activeIcon: 'lib/assets/icons/bellSelected.svg',
    title: "notifications",
    width: 35,
  ),
  NavBarModel(
    icon: 'lib/assets/icons/person.svg',
    activeIcon: 'lib/assets/icons/personSelected.svg',
    title: "profile",
    width: 35,
  ),
];
