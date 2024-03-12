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
import 'package:lightbulb/model/classes.dart';


class SearchAndExploreCard extends StatelessWidget {


  searchUsers userData;
  SearchAndExploreCard({Key? key, required this.userData}) : super(key: key);
  bool notInVis = true;
  @override
  Widget build(BuildContext context) {
    return
      Container(
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.grey),
          borderRadius: BorderRadius.circular(15.0),
        ),
        //color: AppColors.primary,
        margin: const EdgeInsets.all(2),
        child: Padding(
          padding: const EdgeInsets.all(13.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Container(
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: screenHeight(context)/40,
                      backgroundColor: AppColors.secondaryDark,
                      child: ClipOval(
                        child: Image.network(
                          userData.profImage,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),

                    SizedBox(width: 5,),
                    Column(
                      // mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userData.username,
                          style: GoogleFonts.nunito(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: AppColors.white,
                          ),
                        ),
                        // Text(
                        //   FollowersL[number].username,
                        //   style: GoogleFonts.nunito(
                        //     fontSize: 12,
                        //     fontWeight: FontWeight.w900,
                        //     color: AppColors.white,
                        //   ),
                        // ),
                      ],
                    ),
                  ],
                ),
              ),

              // widg(FollowersL[number]),
            ],
          ),
        ),
      );
  }
}
