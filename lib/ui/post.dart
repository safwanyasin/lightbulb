import 'package:flutter/material.dart';
import 'package:lightbulb/util/colors.dart';
import 'package:lightbulb/util/styles.dart';
import 'package:lightbulb/util/screen_sizes.dart';
class Post {
  String title;
  String hashtag;
  String image;
  Post({
    required this.title,
    required this.hashtag,
    required this.image,
  });
}



class mainPost extends StatelessWidget {
  final Post post;

  mainPost({required this.post});

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
                      width: screenWidth(context)/2.5,
                      height: screenWidth(context)/2.5,
                      child: FittedBox(
                          child: Image.network(post.image),
                        fit: BoxFit.fitHeight,
                      )

                  ),
                )
              ],
            ),
            const SizedBox(height: 8),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  post.title,
                  style: pfpPostCaptionStyle,
                )
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.hashtag,
                  style: pfpPostHashtagStyle,
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
