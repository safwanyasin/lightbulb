import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lightbulb/util/colors.dart';
import 'package:lightbulb/util/styles.dart';
import 'package:lightbulb/util/screen_sizes.dart';
import '../model/classes.dart';

class topicsInSearch {
  String Topic;
  String image;
  topicsInSearch({
    required this.Topic,
    required this.image,
  });
}

class topicsPost extends StatelessWidget {
  final topicsInSearch topicsinsearch;

  topicsPost({required this.topicsinsearch});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.primary,
      margin: EdgeInsets.fromLTRB(0, 2, 0, 2),
      child: Padding(
        padding: EdgeInsets.all(2),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(topicsinsearch.image),
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    width: screenWidth(context) / 2.5,
                    height: screenWidth(context) / 2.5,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.secondaryLight.withOpacity(0.01),
                            AppColors.secondaryDark
                          ],
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            topicsinsearch.Topic,
                            style: GoogleFonts.nunito(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w900,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
