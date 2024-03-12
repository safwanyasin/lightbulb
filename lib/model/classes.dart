// class User {
//   String username;
//   String email;
//   String password;
//   int followers = 0;
//   int following = 0;
//   late TempUser posts;
//   Topic? topics;
//   // Notification? notifications;
//
//   User({
//     required this.username,
//     required this.email,
//     required this.password,
//   });
//
//   @override
//   String toString() {
//     // TODO: implement toString
//     print('$this.username, $this.email, $this.password');
//     return super.toString();
//   }
// }

class PostData {
  String caption;
  List<dynamic> topics;
  String image;
  int likes;
  int comments;
  String token;
  String author;

  PostData({
    required this.caption,
    required this.topics,
    required this.image,
    required this.likes,
    required this.comments,
    required this.token,
    required this.author
  });
}

class notifications {
  String name;
  String username;
  String image;
  String token1;
  String content;
  String type;
  notifications({
    required this.name,
    required this.username,
    required this.image,
    required this.token1,
    required this.content,
    required this.type,
  });
}

class Post1 {
  String caption;
  List<dynamic> topics;
  String image;
  int likes;
  int comments;
  String token;

  Post1({
    required this.caption,
    required this.topics,
    required this.image,
    required this.likes,
    required this.comments,
    required this.token,
  });
}

class User {
  // i changed post to this for now, ill edit it later. its the exact same as post, just different variable names so you can still use it like before
  String Name;
  String TempUsername;
  String pass;
  String bio;
  List<dynamic> followReq;
  List<dynamic> followersList;
  List<dynamic> followingList;
  List<dynamic> sentReq;
  String location;
  String profilepic;
  String token;
  bool state;
  //String TempCaption;
  //int likes;
  //int comments;
  // String topics;
  // String image;
  String Email;
  List<Post1> post1;

  User({
    required this.Name,
    required this.TempUsername,
    required this.pass,
    required this.bio,
    required this.followReq,
    required this.followersList,
    required this.followingList,
    required this.sentReq,
    required this.location,
    required this.profilepic,
    required this.token,
    required this.state,
    // required this.TempCaption,
    // required this.likes,
    // required this.comments,
    //required this.topics,
    //required this.image,
    required this.Email,
    required this.post1,
  });
}

class searchFor {
  //TempUser tempuser;
  //String topics;

  //searchFor({
  //required this.topics,
  // required this.tempuser,
  // });
}

class Topic {
  String name;

  Topic({required this.name});
}

class tempNotification {
  String name;
  DateTime time;
  String Info;

  tempNotification(
      {required this.name, required this.time, required this.Info});
}

class searchUsers {
  String username;
  String profImage;

  searchUsers({required this.username, required this.profImage});
}
