import 'package:cloud_firestore/cloud_firestore.dart';

class AllUsersModel{

  List<AllUsersData> data=[];

  AllUsersModel.fromJson(List<QueryDocumentSnapshot> json){
    json.forEach((element){
      data.add(AllUsersData.fromJson(element));
    });
  }

}

class AllUsersData{
  String? userName;
  String? name;
  String? email;
  String? image;
  String? phone;
  String? uId;
  List<AllUsersFollowers> followers = [];



  AllUsersData.fromJson(dynamic json){
    name = json['name'];
    email = json['email'];
    image = json['image'];
    phone = json['phone'];
    userName = json['userName'];
    uId = json['uId'];


  }

}

class AllUsersFollowers{
  String? followerId;

  AllUsersFollowers.fromJson(Map<String,dynamic> json){
    followerId = json['followerId'];
  }
}
