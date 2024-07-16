import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/Models/App_Cubit/States.dart';
import 'package:social_app/Models/Post_Likes.dart';
import 'package:social_app/Models/Posts_Model.dart';
import 'package:social_app/Modules/Home_Screen.dart';
import 'package:social_app/Modules/Profile_Screen.dart';
import 'package:social_app/Modules/Search_Screen.dart';

import '../../Const/Consts.dart';
import '../User_Model.dart';

class AppCubit extends Cubit<AppStates>{
  AppCubit(): super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  List<Widget> Screens =[
    HomeScreen(),
    SearchScreen(),
    ProfileScreen()
  ];

  Map<String,List<String>> likes= {};


  void CreatePost(
      {
        required String content ,
        required String userName ,
        required DateTime dateTime ,
        }){
    emit(CreatePostLoadingState());


      FirebaseFirestore
          .instance
          .collection('posts')
          .add({
        'content' : content,
        'userName' : userName,
        'dateTime' : dateTime,
        'postImage' : postImageUrl,
        'userImage' : userModel!.image,
        'email' : userModel!.email
      })
          .then((value){
            print("created successfully");
            GetPosts();
            emit(CreatePostSuccessState());
      })
          .catchError((error){
            print(error.toString());
            emit(CreatePostErrorState());
      });

  }

  void sharePost(
      {
        required String content ,
        required String userName ,
        required DateTime dateTime ,
        String? postImage,
        required String ownerImage,
        required DateTime currentDateTime,
        required String sharedPostId

      }){
    emit(CreatePostLoadingState());


    FirebaseFirestore
        .instance
        .collection('posts')
        .add({
      'content' : content,
      'userName' : userName,
      'dateTime' : dateTime,
      'postImage' : postImage,
      'userImage' : ownerImage,
      'email' : userModel!.email,
      'myName': userModel!.name,
      'myImage': userModel!.image,
      'currentDateTime': currentDateTime,
      'sharedPostId': sharedPostId,
      'method': 'Share',
    })
        .then((value){
      print("created successfully");
      GetPosts();
      emit(CreatePostSuccessState());
    })
        .catchError((error){
      print(error.toString());
      emit(CreatePostErrorState());
    });

  }


  PostData? postData;
  void getSpecificPostData({required String postId}){

    emit(GetSpecificPostDataLoading());

    FirebaseFirestore
        .instance
        .collection('posts')
        .doc(postId)
        .get()
        .then((value){

          postData = PostData.fromMap(value);
          //postData!.postId = value.id;
          print(postData!.userName);
          print(postData!.userName);


          emit(GetSpecificPostDataSuccess());
    })
        .catchError((error){
          print(error.toString());
          emit(GetSpecificPostDataError());
    });


  }


  UserModel? userModel;
  void GetUserData(String uId){
    emit(GetUserDataLoading());

    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .get()
        .then((value){
      userModel = UserModel.fromJson(value.data()!);
      likes.addAll({
        "${userModel!.email}":[]
      });

      getUserFollowersAndFollowing();

      GetPostsLikes();
    })
        .catchError((error){
      print(error.toString());
      emit(GetUserDataError());
    });
  }


  void getUserFollowersAndFollowing(){
    emit(GetUserFollowersAndFollowingDataLoading());
    userModel!.followers.clear();
    userModel!.following.clear();
    // Fetch followers
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('followers')
        .get()
        .then((value) {
      for (var element in value.docs) {
        userModel!.followers.add(Followers.fromJson(element.data()));
      }


      emit(GetUserFollowersAndFollowingDataSuccess());

    }).catchError((error) {
      print("Error fetching followers: ${error.toString()}");
      emit(GetUserFollowersAndFollowingDataError());
    });

    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('following')
        .get()
        .then((value) {
      for (var element in value.docs) {
        userModel!.following.add(Following.fromJson(element.data()));


      }
      emit(GetUserFollowersAndFollowingDataSuccess());

    }).catchError((error) {
      print("Error fetching followers: ${error.toString()}");
      emit(GetUserFollowersAndFollowingDataError());
    });


  }



  List<UserModel> followersData=[];
  void fetchUserFollowers(String uId,UserModel userModel){
    followersData.clear();

      for(var follower in userModel.followers ){
        FirebaseFirestore
            .instance
            .collection('users')
            .doc(follower.followerId)
            .get()
            .then((vaule){
         // print('<<<<<<<<<>>>>>>>>>>${vaule.data()!['name']}');
          followersData.add(UserModel.fromJson(vaule.data()));
          //print(followersData[1].name);
        })
            .catchError((error){
          print("Error fetching followers: ${error.toString()}");
          emit(GetUserDataError());
        });

      }


  }

  List<UserModel> followingData=[];
  void fetchUserFollowing(String uId,UserModel userModel){
    followingData.clear();

    for(var following in userModel.following ){
      FirebaseFirestore
          .instance
          .collection('users')
          .doc(following.followedId)
          .get()
          .then((vaule){
        //print('<<<<<<<<<>>>>>>>>>>${vaule.data()!['name']}');
        followingData.add(UserModel.fromJson(vaule.data()));
        //print(followersData[1].name);
      })
          .catchError((error){
        print("Error fetching following: ${error.toString()}");
        emit(GetUserDataError());
      });

    }


  }

  List<UserModel> allUsersModel=[];
  void GetAllUsers(){
    emit(GetAllUsersDataLoading());
    allUsersModel.clear();
    FirebaseFirestore
        .instance
        .collection('users')
        .get()
        .then((value){

          for(var user in value.docs){
            print('?????????????????????${user.data()['name']}');
            allUsersModel.add(UserModel.fromJson(user.data()));
          }


            emit(GetAllUsersrDataSuccess());
    })
        .catchError((error){
          print(error.toString());
          emit(GetAllUsersDataError());
    });
  }



  void getSpecificUserData(UserModel? specificUserModel){
    emit(GetSpecificUserDataLoading());

      // Fetch followers
      FirebaseFirestore.instance
          .collection('users')
          .doc(specificUserModel!.uId)
          .collection('followers')
          .get()
          .then((value) {
        for (var element in value.docs) {
          specificUserModel!.followers.add(Followers.fromJson(element.data()));

        }

        emit(GetSpecificUserDataSuccess());

      }).catchError((error) {
        print("Error fetching followers: ${error.toString()}");
        emit(GetSpecificUserDataError());
      });


      FirebaseFirestore.instance
          .collection('users')
          .doc(specificUserModel!.uId)
          .collection('following')
          .get()
          .then((value) {
        for (var element in value.docs) {
          specificUserModel!.following.add(Following.fromJson(element.data()));
        }


        //print(specificUserModel!.following[0].followedId);
        //print(specificUserModel!.following[1].followedId);
        //getUserFollowersAndFollowing();
        emit(GetSpecificUserDataSuccess());

      }).catchError((error) {
        print("Error fetching followers: ${error.toString()}");
        emit(GetSpecificUserDataError());
      });

  }


  List<UserModel>? allUsersData=[];
  void Search({required String userName}){

    if(userName.isEmpty) {
      allUsersData!.clear();
    }
    else {
      allUsersData!.clear();
      allUsersModel.forEach((element) {
        if (element.name!.contains(userName)) {
          allUsersData!.add(element);
        }
      });
      print(allUsersData![0].name);
      emit(SearchUsersState());
    }
  }


  PostsModel? postsModel;
  List<PostData> userPosts=[];
  List<PostData> specificUserPosts=[];
  String? formattedDate;
  void GetPosts({String? email}){
    emit(GetPostsDataLoading());

    specificUserPosts.clear();
    userPosts.clear();
    FirebaseFirestore
        .instance
        .collection('posts')
        .get()
        .then((value){

          postsModel = PostsModel.fromJson(value.docs);

          postsModel!.data.forEach((element){
            if(element.email == userModel!.email){
              userPosts.add(element);
            }
          });

          if(email != null){

            postsModel!.data.forEach((element){
              if(element.email == email){
                specificUserPosts.add(element);
              }
            });

          }


          emit(GetPostsDataSuccess());
    })
        .catchError((error){
          print(error.toString());
          emit(GetPostsDataError());
    });

  }


  void makeFollow({required String followedUId}){
    emit(MakeFollowLoading());

    FirebaseFirestore
        .instance
        .collection('users')
        .doc(followedUId)
        .collection('followers')
        .doc(userModel!.uId)
        .set({
      'followerId' : userModel!.uId
    })
        .then((value){

      FirebaseFirestore
          .instance
          .collection('users')
          .doc(userModel!.uId)
          .collection('following')
          .doc(followedUId)
          .set({
          'followedId' : followedUId
      })
          .then((value){

      })
          .catchError((error){
            print(error.toString());
            emit(MakeFollowError());
      });

          getUserFollowersAndFollowing();
          print('Follow made successfully');
          emit(MakeFollowSuccess());

    })
        .catchError((error){
          print(error.toString());
          emit(MakeFollowError());
    });

  }
  void deleteFollow({required String followedUId}){
    emit(DeleteFollowLoading());

    FirebaseFirestore
        .instance
        .collection('users')
        .doc(followedUId)
        .collection('followers')
        .doc(userModel!.uId)
        .delete()
        .then((value){

      FirebaseFirestore
          .instance
          .collection('users')
          .doc(userModel!.uId)
          .collection('following')
          .doc(followedUId)
          .delete()
          .then((value){

      })
          .catchError((error){
        print(error.toString());
        emit(DeleteFollowError());
      });

      getUserFollowersAndFollowing();
      print('Deleted successfully');
      emit(DeleteFollowSuccess());

    })
        .catchError((error){
      print(error.toString());
      emit(DeleteFollowError());
    });

  }

  Likes? likesData;
  void GetPostsLikes(){
    emit(GetLikeLoading());

    FirebaseFirestore
        .instance
        .collection('likes')
        .get()
        .then((value){
          likesData = Likes.fromJson(value.docs);

             if(likes[userModel!.email]!.isEmpty) {
               likesData!.likeData.forEach((element) {
                 if (element.email == userModel!.email) {
                   likes[userModel!.email]!.add(element.postId!);
                 }
               });
             }
          print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>${likes[userModel!.email]!.length}");


          emit(GetLikeSuccess());
    })    .catchError((error){
      print(error.toString());
      emit(GetLikeError());
    })
    ;
  }

  String? likeId;
  void MakeLike({required String postId, required String userName , required String email}){
    emit(MakeLikeLoading());


        FirebaseFirestore
            .instance
            .collection('likes')
            .add({
                'userName': userName,
                'email' : email,
                'postId' : postId
             }).then((value){

               GetPostsLikes();
               if( likes[userModel!.email]!.isNotEmpty) {
                 likes[userModel!.email]!.add(postId);
               }
               emit(MakeLikeSuccess());
        }).catchError((error){
          print(error.toString());
          emit(MakeLikeError());
        });


  }

  void DeleteLike({required String postId}){

    emit(DeleteLikeLoading());
    for(var element in likesData!.likeData){
      if(element.postId == postId){
        likeId = element.likeId;
        break;
      }
    }
    FirebaseFirestore
        .instance
        .collection('likes')
        .doc(likeId)
        .delete()
        .then((value){
          print(likes[userModel!.email]!);
      likes[userModel!.email]!.remove(postId);
          print(likes[userModel!.email]!);

          print(likeId);
      emit(DeleteLikeSuccess());
    }).catchError((error){
      print(error.toString());
      emit(DeleteLikeError());
    });
  }


  bool checkFollow({required String uId}) {
    for (var user in userModel!.following) {
      if (user.followedId == uId) {
        return true;
      }
    }
    return false;
  }




  bool checkLike({required String postId}) {
    for (var element in likes[userModel!.email]!) {
      if (element == postId) {
        return true;
      }
    }
    return false;
  }


  File? image;
  final ImagePicker picker = ImagePicker();

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      image = File(pickedFile.path);
      print(image!.path);
      //emit(UploadedImageState());
    } else {
      print('No image selected.');
    }
  }

  File? profileImage;
  Future<void> pickProfileImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(UploadedImageState());
    } else {
      print('No image selected.');
    }
  }

  String profileImageUrl='';
  void uploadProfileImage(
      {
        required String fullName,
        required String userName,
        required String phone,
      }

      ){
    emit(UploadProfileImageToStorageLoading());


    firebase_storage.FirebaseStorage
        .instance
        .ref()
        .child("users/${Uri.file(profileImage!.path).pathSegments.last}")
        .putFile(profileImage!).
    then((value){
      value
          .ref
          .getDownloadURL()
          .then((value){
            profileImageUrl = value;
            updateUser(fullName: fullName, userName: userName, phone: phone);
            updateUserPosts(
              userName: fullName
            );
            profileImageUrl = '';
            emit(UploadProfileImageToStorageSuccess());
      })
          .catchError((error){
            print(error.toString());
            emit(UploadProfileImageToStorageError());
      });
    })
        .catchError((error){
      print(error.toString());
      emit(UploadProfileImageToStorageError());

    });
  }

  String postImageUrl='';
  void uploadPostImage(
      {
        required String content ,
        required String userName ,
        required DateTime dateTime ,
      }
      ){
    emit(UploadPostImageToStorageLoading());
    firebase_storage.FirebaseStorage
        .instance
        .ref()
        .child('posts/${Uri.file(image!.path).pathSegments.last}')
        .putFile(image!)
        .then((value){
      value
          .ref
          .getDownloadURL()
          .then((value){
            postImageUrl = value;
            print(postImageUrl);
            CreatePost(content: content, userName: userName, dateTime: dateTime);
            emit(UploadPostImageToStorageSuccess());
      })
          .catchError((error){
        print(error.toString());
        emit(UploadPostImageToStorageError());
      });
    })
        .catchError((error){
      print(error.toString());
      emit(UploadPostImageToStorageError());

    });
  }


  void updateUser(
  {
    required String fullName,
    required String userName,
    required String phone,
  }
      ){
    emit(UpdateUserLoading());

    FirebaseFirestore
        .instance
        .collection('users')
        .doc(userModel!.uId)
        .update({
            'email' : userModel!.email,
            'uId' : userModel!.uId,
            'name' : fullName,
            'userName' : userName,
            'phone' : phone,
            'image' : profileImageUrl.isNotEmpty? profileImageUrl : userModel!.image
        })
        .then((value){
          GetUserData(uId!);
          emit(UpdateUserSuccess());
    })
        .catchError((error){
          print(error.toString());
          emit(UpdateUserError());
    });
  }


  void updateUserPosts(
  {
    required String userName,
}
      ){
    emit(UpdateUserPostsLoading());

    userPosts.forEach((element){
      FirebaseFirestore
          .instance
          .collection('posts')
          .doc(element.postId)
          .update({
          'content' : element.content,
          'userName' : userName,
          'dateTime' : element.dateTime,
          'postImage' : element.postImage,
          'userImage' : profileImageUrl.isNotEmpty? profileImageUrl : element.userImage,
          'email' : element.email
      }).then((value){
        GetPosts();
        emit(UpdateUserPostsSuccess());
      })
          .catchError((error){
        print(error.toString());
        emit(UpdateUserPostsError());
      });
    });


  }

  List<BottomNavigationBarItem> items= [
    BottomNavigationBarItem(icon: Image.asset("icons/home.png",width: 30.0,height: 30.0,),label: "_"),
    BottomNavigationBarItem(icon: Image.asset("icons/loupe.png",width: 30.0,height: 30.0,),label: "_"),
    BottomNavigationBarItem(icon: Image.asset("icons/user.png",width: 30.0,height: 30.0,),label: "_"),

  ];

  int currentIndex = 0;
  void ChangeIndex(int ind){
    currentIndex = ind;
    emit(ChangeNavBarIndex());
  }

}