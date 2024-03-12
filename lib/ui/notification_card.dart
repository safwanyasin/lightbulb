import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lightbulb/util/colors.dart';
import 'package:lightbulb/util/screen_sizes.dart';
import 'package:lightbulb/util/styles.dart';

import '../model/classes.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:flutter/material.dart';
import '../routes/settings.dart';

class notificationCard extends StatelessWidget {
  final String tempNoti;

  const notificationCard({Key? key, required this.tempNoti}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: 20),
            Container(
              //color: AppColors.secondaryDark,
              child: Icon(
                Icons.circle_notifications,
                color: AppColors.secondaryDark,
                size: 80,
              ),
              height: MediaQuery.of(context).size.height/10,
              width: MediaQuery.of(context).size.width/5,
            ),
            SizedBox(
              width: screenWidth(context)/8,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tempNoti,
                    style: fromNotificationStyle),
                Text(
                  "",
                  style: notificationInfo
                )
              ],
            ),
            Spacer(),
            Column(

              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                  child: Text("",
                      style: GoogleFonts.nunito(
                        fontSize: 12,
                        color: AppColors.primaryLightest,
                        fontWeight: FontWeight.w800,
                      )),
                ),
              ],
            ),
            SizedBox(width: 5,)
          ],
        ),
        Divider(
          height: 25,
          thickness: 1,
          color: AppColors.secondaryLight,
        )
      ],
    );
  }
}
