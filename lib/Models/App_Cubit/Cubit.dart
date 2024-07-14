import 'dart:ffi';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/Models/All_Users_Model.dart';
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
  UserModel? userModel;
  List<AllUsersData> followersData=[];
  void GetUserData(String uId){
    emit(GetUserDataLoading());

    GetAllUsers();

    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .get()
        .then((value){
      userModel = UserModel.fromJson(value.data()!);
      likes.addAll({
        "${userModel!.email}":[]
      });
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


        for(var follower in userModel!.followers ){
          for(var element in allUsersModel!.data){
            if(follower.followerId == element.uId){
              followersData.add(element);
            }
          }
        }

        print('>>>>>>>>>>>>>>>>>>>>>>>>>>${followersData[0].name}<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<');
        GetPostsLikes();
        print("Retrieved");
        print(userModel!.name);
        emit(GetUserDataSuccess());

      }).catchError((error) {
        print("Error fetching followers: ${error.toString()}");
        emit(GetUserDataError());
      });
    })
        .catchError((error){
      print(error.toString());
      emit(GetUserDataError());
    });
  }

  AllUsersModel? allUsersModel;
  void GetAllUsers(){
    emit(GetAllUsersDataLoading());

    FirebaseFirestore
        .instance
        .collection('users')
        .get()
        .then((value){

          allUsersModel = AllUsersModel.fromJson(value.docs);


          allUsersModel!.data.forEach((element){

            FirebaseFirestore.instance
                  .collection('users')
                  .doc(element.uId)
                  .collection('followers')
                  .get()
                .then((value){

              for (var follower in value.docs) {
                element.followers.add(AllUsersFollowers.fromJson(follower.data()));
              }
            })
                .catchError((error){
                  print(error.toString());
                  emit(GetSpecificUserFollowersError());
            });

          });


          print(allUsersModel!.data[0].phone);
          print(allUsersModel!.data[1].phone);

          emit(GetAllUsersrDataSuccess());
    })
        .catchError((error){
          print(error.toString());
          emit(GetAllUsersDataError());
    });
  }


  List<AllUsersData>? allUsersData=[];
  void Search({required String userName}){

    allUsersData = [];

    allUsersModel!.data.forEach((element){
      if(element.name!.contains(userName.toUpperCase()) || element.name!.contains(userName.toLowerCase())){
        allUsersData!.add(element);
      }
    });
    print(allUsersData![0].name);
    emit(SearchUsersState());

  }

  // List<Followers> specificUserFollowersIds = [];
  // List<AllUsersData>? specificUserFollowersData=[];
  // void getSpecificUserFollowers(String uId){
  //   emit(GetSpecificUserFollowersLoading());
  //
  //   GetAllUsers();
  //
  //   FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(uId)
  //       .collection('followers')
  //       .get()
  //       .then((value) {
  //
  //     for (var element in value.docs) {
  //       specificUserFollowersIds.add(Followers.fromJson(element.data()));
  //     }
  //
  //     for(var follower in specificUserFollowersIds){
  //       for(var element in allUsersModel!.data){
  //         if(follower.followerId == element.uId){
  //           specificUserFollowersData!.add(element);
  //         }
  //       }
  //     }
  //
  //     emit(GetSpecificUserFollowersSuccess());
  //
  //   }).catchError((error) {
  //     print("Error fetching followers: ${error.toString()}");
  //     emit(GetSpecificUserFollowersError());
  //   });
  //
  //
  // }


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


  void makeFollow({required String uId}){
    emit(MakeFollowLoading());

    FirebaseFirestore
        .instance
        .collection('users')
        .doc(uId)
        .collection('followers')
        .add({
      'followerId' : userModel!.uId
    })
        .then((value){
          print('Follow made successfully');
          emit(MakeFollowSuccess());

    })
        .catchError((error){
          print(error.toString());
          emit(MakeFollowError());
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