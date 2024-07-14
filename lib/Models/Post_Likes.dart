import 'package:cloud_firestore/cloud_firestore.dart';

class Likes{
  List<LikeData> likeData = [];

  Likes.fromJson(List<QueryDocumentSnapshot> json){
    json.forEach((element){
      likeData.add(LikeData.fromJson(element));
    });
  }
}

class LikeData {
  String? userName;
  String? postId;
  String? email;
  String? likeId;

  LikeData.fromJson(QueryDocumentSnapshot json) {
    var data = json.data() as Map<String,dynamic>;
    userName = data['userName'];
    postId = data['postId'];
    email = data['email'];
    likeId = json.id;
  }
}

