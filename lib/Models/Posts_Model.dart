import 'package:cloud_firestore/cloud_firestore.dart';

class PostsModel{

  List<PostData> data =[];

  PostsModel.fromJson(List<QueryDocumentSnapshot> json){
    json.forEach((element){
      data.add(PostData.fromJson(element));
    });
  }

}



class PostData{
  String? content;
  DateTime? dateTime;
  Timestamp? timestamp;
  String? userImage;
  String? postImage;
  String? userName;
  String? postId;
  String? email;

  PostData.fromJson(QueryDocumentSnapshot  json){
    var data = json.data() as Map<String , dynamic>;
    content = data['content'];
    timestamp = data['dateTime'];
    userName = data['userName'];
    postImage = data['postImage'];
    userImage = data['userImage'];
    email = data['email'];

    postId = json.id;
    dateTime = timestamp!.toDate();

  }
}

