import 'package:cloud_firestore/cloud_firestore.dart';

class DBService{
  //final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
  //final CollectionReference postCollection = FirebaseFirestore.instance.collection('user/posts');
  //final Stream<QuerySnapshot> users = FirebaseFirestore.instance.collection('users').snapshots();


  Future addUser(bool state, String email, String? bio, int postsnum, String? profpic,List<dynamic> followReq, List<dynamic> followingList, List<dynamic> followersList, String? name, String? username, String password, List<dynamic> sentReq, String? token1, String caption, List<dynamic> topics, String image, int likes, int comments, String? location, String postToken, String notiContent, String notiSender, String notiToken, List<dynamic>? notifsList ,String attempt) async{
    CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
    var result = await userCollection.doc(token1).set({
      'state' : state,
      'email' : email,
      'name' : name,
      'username' : username,
      'password' : password,
      'followReq' : followReq,
      'location' : location,
      'username' : username,
      'sentReq' : sentReq,
      'location' : location,
      'profpic' : profpic,
      'followersList' : followersList,
      'followingList' : followingList,
      'sentReq' : sentReq,
      'posts' : postsnum,
      'bio' : bio,
      'notifsList' : notifsList,
      'token1' : token1
    })
    .then((value) => print('User Added.'))
    .catchError((error) => print('Error: ${error.toString()}'));
    if(attempt != "1st" && attempt != "notThis") {
      await addPost(caption, topics, image, likes, comments, location, postToken, token1);
    }
  }

  Future addPost(String caption, List<dynamic>? topics, String image, int likes, int comments, String? location, String? token, String? id) async{
    CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
    return await userCollection.doc(id).collection('posts').doc(token).set({
      'caption' : caption,
      'topics' : topics,
      'image' : image,
      'likes' : likes,
      'comments' : comments,
      'location' : location,
      'token' : token,

    })
        .then((value) => print('Post Added.'))
        .catchError((error) => print('Error: ${error.toString()}'));
  }

  Future addActiveUser(String username, String token) async {
    CollectionReference auCollection = FirebaseFirestore.instance.collection('activeUsers');
    return await auCollection.doc(token).set({
    })
        .then((value) => print('Active User Added.'))
        .catchError((error) => print('Error: ${error.toString()}'));
  }


  //Future addPostAlter(String caption, String image, int likes, int comments, String token, String id) async{
 //   CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
  //  return await userCollection.doc(id).collection('posts').doc(token).set({
  //    'caption' : caption,
  //    'image' : image,
  //    'likes' : likes,
  //    'comments' : comments,
   //   'token' : token
  //  })
  //      .then((value) => print('PostAlter Added.'))
  //      .catchError((error) => print('Error: ${error.toString()}'));
  //}

  Future addNoti(String name, String username, String image, String token, String content, String type,String? id) async{
    CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
    return await userCollection.doc(id).collection('notifications').doc(token).set({
      'name' : name,
      'username' : username,
      'image' : image,
      'token' : token,
      'content' : content,
      'type' : type,
    })
        .then((value) => print('Notification Added.'))
        .catchError((error) => print('Error: ${error.toString()}'));
  }
  Future addTopics(String topic, String token) async{
    CollectionReference topicCollection = FirebaseFirestore.instance.collection('topics');
    return await topicCollection.doc(token).set({
      'topic' : topic,
      'token' : token
    })
        .then((value) => print('Topic Added.'))
        .catchError((error) => print('Error: ${error.toString()}'));
  }

  Future addImage(String image, String? token) async{
    CollectionReference imageCollection = FirebaseFirestore.instance.collection('image');
    return await imageCollection.doc(token).set({
      'image' : image,
      'token' : token
    })
        .then((value) => print('Image Added.'))
        .catchError((error) => print('Error: ${error.toString()}'));
  }

  Future newInfo(String name, String username, String email, String pass, String location, String token) async{
    CollectionReference newInfoCollection = FirebaseFirestore.instance.collection('newInfo');
    return await newInfoCollection.doc(token).set({
      'name' : name,
      'username' : username,
      'email' : email,
      'pass' : pass,
      'location' : location,
      'token' : token
    })
        .then((value) => print('Info Added.'))
        .catchError((error) => print('Error: ${error.toString()}'));
  }

  Future addCurrUser(bool state, String name, String username, String email, String password, String location, String? profpic, List<dynamic> followReq, List<dynamic> followersList, List<dynamic> followingList,List<dynamic> sentReq, int posts, String bio ,String token) async{
    CollectionReference currUserCollection = FirebaseFirestore.instance.collection('currUser');
    return await currUserCollection.doc(token).set({
      'state' : state,
      'name' : name,
      'username' : username,
      'password' : password,
      'location' : location,
      'profpic' : profpic,
      'followReq' : followReq,
      'followersList' : followersList,
      'followingList' : followingList,
      'sentReq' : sentReq,
      'posts' : posts,
      'bio' : bio,
      'token' : token
    })
        .then((value) => print('currUser Added.'))
        .catchError((error) => print('Error: ${error.toString()}'));
  }

  Future addSubscribedTopics(String topicSel, String? id) async{
    CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
    return await userCollection.doc(id).collection('subscribedTopics').doc(topicSel).set({
      'topicSel' : topicSel,
    })
        .then((value) => print('addSubscribedTopics Added.'))
        .catchError((error) => print('Error: ${error.toString()}'));
  }

  Future addlikedPosts(String postName, bool isLiked, String? id, String by) async{
    CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
    return await userCollection.doc(id).collection('likedPosts').doc(postName).set({
      'postName' : postName,
      'isLiked' : true,
      'token' : postName,
      'by' : by

    })
        .then((value) => print('likedPost Added.'))
        .catchError((error) => print('Error: ${error.toString()}'));
  }

  Future addmarkedPosts(String postName, bool isLiked, String? id, String by) async{
    CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
    return await userCollection.doc(id).collection('bookmarkedPosts').doc(postName).set({
      'postName' : postName,
      'isMarked' : true,
      'token' : postName,
      'by' : by
    })
        .then((value) => print('MarkedPost Added.'))
        .catchError((error) => print('Error: ${error.toString()}'));
  }

  //List<User> UserListFromSnapshot(QuerySnapshot snapshot){
    //return snapshot.docs.map((doc){
   //   return User(
     //   TempUsername: doc.get('TempUsername'),
     //   pass: doc.get('pass'),
     //   Email: doc.get('Email'),
     //   Location: doc.get('Location'),
      //  post1: doc.get('post1'),
    // );
   // }).toList();
 // }


  //Stream<List<User>> get users {
  //  return userCollection.snapshots().map(UserListFromSnapshot);
  //}
}


