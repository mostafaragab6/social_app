class UserModel{
  String? userName;
  String? name;
  String? email;
  String? image;
  String? phone;
  String? uId;
  List<Followers> followers = [];
  List<Following> following = [];


  UserModel.fromJson(dynamic json){
    name = json['name'];
    email = json['email'];
    image = json['image'];
    phone = json['phone'];
    userName = json['userName'];
    uId = json['uId'];


  }
}

class Followers{
  String? followerId;

  Followers.fromJson(Map<String,dynamic> json){
    followerId = json['followerId'];
  }
}

class Following{
  String? followedId;

  Following.fromJson(Map<String,dynamic> json){
    followedId = json['followedId'];
  }
}