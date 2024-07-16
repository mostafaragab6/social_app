import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:social_app/Const/Consts.dart';
import 'package:social_app/Models/App_Cubit/Cubit.dart';
import 'package:social_app/Models/App_Cubit/States.dart';
import 'package:social_app/Modules/Edit_Profile.dart';
import 'package:social_app/Modules/LoginScreen.dart';

import 'Post_View.dart';

class ProfileScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      builder: (BuildContext context, AppStates state) { 
        var cubit = AppCubit.get(context);
      return SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.only(top: 25.0,start: 25.0,end: 25.0),
                child: Row(
                  children: [

                        DropdownButton(
                          icon: Icon(Icons.arrow_downward_sharp),
                                isDense: false,
                                isExpanded: false,
                                iconDisabledColor: Colors.black,
                                iconEnabledColor: Colors.black,
                                dropdownColor: Colors.white,
                                style: const TextStyle(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10.0),
                             value: cubit.userModel!.userName,
                             onChanged: (value) {
                                  if (value == 'SignOut') {
                                  FirebaseAuth.instance.signOut().then((_) {
                                  Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                  builder: (context) => LoginScreen()));
                                  cubit.currentIndex = 0;
                                  uId = null;
                                  cubit.userModel = null;
                                  cubit.userPosts.clear();
                                  cubit.postsModel = null;
                                  cubit.likes.clear();
                                  cubit.followersData.clear();
                                  });
                             }}  ,
                            items:[
                            DropdownMenuItem(
                              value: cubit.userModel!.userName,
                              child: Text('${cubit.userModel!.userName}',style: TextStyle(color: Colors.black,fontSize: 17,fontWeight: FontWeight.w500),),),
                              DropdownMenuItem(

                                value: 'SignOut' ,
                                child: Text('SignOut',style: TextStyle(color: Colors.black,fontSize: 17,fontWeight: FontWeight.w500),),)
                          , ]),
                    Spacer(),
                    InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (builder)=>EditProfile()));
                      },
                      child: Container(
                        width: 60,
                        height: 40,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30)
                        ),
                        child:
                       Center(
                           child:
                           Text('Edit',
                             style:
                             TextStyle(
                                 color: Colors.black,fontSize: 16,fontWeight: FontWeight.w500),
                           ))
                      ),
                    ),

                  ],
                ),
              ),
              SizedBox(height: 50,),

              Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(70)
                  ),
                  child:
                  ClipRRect(
                    borderRadius: BorderRadius.circular(70),
                    child: CachedNetworkImage(
                      imageUrl: '${cubit.userModel!.image}',
                      placeholder: (context, url) => SpinKitRing(
                        color: Colors.grey,
                        lineWidth: 3.0,
                        size: 35.0,
                        duration: Duration(milliseconds: 500),
                      ),
                      errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
                    ),
                  )
              ),

              SizedBox(height: 20,),
              Text('${cubit.userModel!.name}'
              ,style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500
                ),),

              SizedBox(height: 25,),

              Padding(
                padding: const EdgeInsetsDirectional.symmetric(horizontal: 25.0),
                child: Container(
                  width: double.infinity,
                  height: 120.0,
                  decoration: BoxDecoration(
                    border: BorderDirectional(top: BorderSide(color: MaterialColor(0xFFC4D0CF, {})),bottom: BorderSide(color: MaterialColor(0xFFC4D0CF, {})))
                  ),
                  child:
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('${cubit.userPosts.length}',style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500),),
                            SizedBox(height: 6,),
                            Text('Posts',style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey))
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('${cubit.userModel!.followers.length}',style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500)),
                            SizedBox(height: 6,),
                            Text('Followers',style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey))
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('${cubit.userModel!.following.length}',style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500)),
                            SizedBox(height: 6,),
                            Text('Following',style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsetsDirectional.only(top: 8.0,start: 10.0,end: 10.0,bottom: 90),
                child: ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context,index){
                      if(cubit.userPosts[index].method == 'Share'){
                        return Card(
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)
                          ),
                          color: Colors.white38,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: [

                                Row(
                                  children: [
                                    Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(25)
                                        ),
                                        child:
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(25),
                                          child: CachedNetworkImage(
                                            imageUrl: '${cubit.userPosts[index].myImage!}',
                                            placeholder: (context, url) => SpinKitRing(
                                              color: Colors.grey,
                                              lineWidth: 3.0,
                                              size: 25.0,
                                              duration: Duration(milliseconds: 500),
                                            ),
                                            errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
                                          ),
                                        )
                                    ),

                                    SizedBox(width: 10,),
                                    Column(
                                      crossAxisAlignment:CrossAxisAlignment.start,
                                      children: [
                                        Text('${cubit.userPosts[index].myName}',
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w700
                                          ),),
                                        Text("${DateFormat('MMMM d, y').format(cubit.userPosts[index].currentDateTime!)}",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 15
                                          ),)
                                      ],
                                    )
                                  ],
                                ),


                                InkWell(
                                  onTap: (){
                                    cubit.getSpecificPostData(postId: cubit.userPosts[index].sharedPostId!);
                                    Navigator.push(context, MaterialPageRoute(builder: (builder)=>PostView()));
                                  },
                                  child: Card(
                                      shadowColor: Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20.0)
                                      ),
                                      color: Colors.white,
                                      child: Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Column(
                                          crossAxisAlignment:CrossAxisAlignment.start,

                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                    width: 50,
                                                    height: 50,
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: BorderRadius.circular(25)
                                                    ),
                                                    child:
                                                    ClipRRect(
                                                      borderRadius: BorderRadius.circular(25),
                                                      child: CachedNetworkImage(
                                                        imageUrl: '${cubit.userPosts[index].userImage!}',
                                                        placeholder: (context, url) => SpinKitRing(
                                                          color: Colors.grey,
                                                          lineWidth: 3.0,
                                                          size: 25.0,
                                                          duration: Duration(milliseconds: 500),
                                                        ),
                                                        errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
                                                      ),
                                                    )
                                                ),

                                                SizedBox(width: 10,),
                                                Column(
                                                  crossAxisAlignment:CrossAxisAlignment.start,
                                                  children: [
                                                    Text('${cubit.userPosts[index].userName}',
                                                      style: TextStyle(
                                                          fontSize: 17,
                                                          fontWeight: FontWeight.w700
                                                      ),),
                                                    Text("${DateFormat('MMMM d, y').format(cubit.userPosts[index].dateTime!)}",
                                                      style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 15
                                                      ),)
                                                  ],
                                                )
                                              ],
                                            ),
                                            SizedBox(height: 20,),
                                            Text('${cubit.userPosts[index].content}'
                                              ,style: TextStyle(
                                                fontSize: 17,

                                              ),),
                                            SizedBox(height: 20,),

                                            cubit.userPosts[index].postImage!.isNotEmpty ?
                                            Container(
                                              width: double.infinity,
                                              height: 400,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(20)
                                              ),
                                              child:

                                              ClipRRect(
                                                  borderRadius: BorderRadius.circular(20),
                                                  child: CachedNetworkImage(
                                                    imageUrl: '${cubit.userPosts[index].postImage}',fit: BoxFit.cover,
                                                    placeholder: (context, url) => SpinKitRing(
                                                      color: Colors.grey,
                                                      lineWidth: 3.0,
                                                      size: 50.0,
                                                      duration: Duration(milliseconds: 50),
                                                    ),
                                                    errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
                                                  )
                                              ),
                                            ):SizedBox(),
                                            SizedBox(height: 10,),

                                          ],
                                        ),
                                      )
                                  ),
                                ),

                                Row(
                                  children: [
                                    Expanded(
                                      child: IconButton(
                                          onPressed: (){
                                            if(cubit.checkLike(postId: cubit.userPosts[index].postId!)) {

                                              cubit.DeleteLike(postId: cubit.userPosts[index].postId!);

                                            }
                                            else{
                                              cubit.MakeLike(
                                                  postId: cubit.userPosts[index].postId!,
                                                  userName: cubit.userModel!
                                                      .name!,
                                                  email: cubit.userModel!
                                                      .email!
                                              );
                                            }
                                          },
                                          icon: cubit.checkLike(postId: cubit.userPosts[index].postId!) ?
                                          Icon(Icons.favorite,color: Colors.red,) : Icon(Icons.favorite_outline,)
                                      ),
                                    ),
                                    Text("|"),
                                    Expanded(
                                      child: IconButton(
                                          onPressed: (){
                                            DateTime dateTime = DateTime.now();
                                            cubit.sharePost(
                                                sharedPostId:cubit.userPosts[index].sharedPostId!,
                                                content: cubit.userPosts[index].content!,
                                                userName: cubit.userPosts[index].userName!,
                                                dateTime: cubit.userPosts[index].dateTime!,
                                                ownerImage: cubit.userPosts[index].userImage!,
                                                postImage: cubit.userPosts[index].postImage,
                                                currentDateTime: dateTime);
                                          },
                                          icon: Icon(Icons.arrow_forward)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      else {
                        return Card(
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)
                            ),
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [
                                  Row(
                                    children: [

                                      Container(
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius
                                                  .circular(25)
                                          ),
                                          child:
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                25),
                                            child: CachedNetworkImage(
                                              imageUrl: '${cubit
                                                  .userPosts[index].userImage}',
                                              placeholder: (context, url) =>
                                                  SpinKitRing(
                                                    color: Colors.grey,
                                                    lineWidth: 3.0,
                                                    size: 25.0,
                                                    duration: Duration(
                                                        milliseconds: 500),
                                                  ),
                                              errorWidget: (context, url,
                                                  error) =>
                                                  Center(
                                                      child: Icon(Icons.error)),
                                            ),
                                          )
                                      ),
                                      SizedBox(width: 10,),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: [
                                          Text('${cubit.userPosts[index]
                                              .userName}',
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w700
                                            ),),
                                          Text(
                                            "${DateFormat('MMMM d, y').format(
                                                cubit.userPosts[index]
                                                    .dateTime!)}",
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 15
                                            ),)
                                        ],
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 20,),
                                  Text('${cubit.userPosts[index].content}'
                                    , style: TextStyle(
                                      fontSize: 17,

                                    ),),
                                  SizedBox(height: 20,),
                                  cubit.userPosts[index].postImage!.isNotEmpty ?
                                  Container(
                                    width: double.infinity,
                                    height: 400,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20)
                                    ),
                                    child:

                                    ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: CachedNetworkImage(
                                          imageUrl: '${cubit.userPosts[index]
                                              .postImage}', fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              SpinKitRing(
                                                color: Colors.grey,
                                                lineWidth: 3.0,
                                                size: 50.0,
                                                duration: Duration(
                                                    milliseconds: 50),
                                              ),
                                          errorWidget: (context, url, error) =>
                                              Center(child: Icon(Icons.error)),
                                        )
                                    )
                                    ,
                                  ) : SizedBox(),
                                  SizedBox(height: 10,),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: IconButton(
                                            onPressed: () {
                                              if (cubit.checkLike(
                                                  postId: cubit.userPosts[index]
                                                      .postId!)) {
                                                cubit.DeleteLike(postId: cubit
                                                    .userPosts[index].postId!);
                                              }
                                              else {
                                                cubit.MakeLike(
                                                    postId: cubit
                                                        .userPosts[index]
                                                        .postId!,
                                                    userName: cubit.userModel!
                                                        .name!,
                                                    email: cubit.userModel!
                                                        .email!
                                                );
                                              }
                                            },
                                            icon: cubit.checkLike(
                                                postId: cubit.userPosts[index]
                                                    .postId!) ?
                                            Icon(Icons.favorite,
                                              color: Colors.red,) : Icon(
                                              Icons.favorite_outline,)
                                        ),
                                      ),
                                      Text("|"),
                                      Expanded(
                                        child: IconButton(
                                            onPressed: () {},
                                            icon: Icon(Icons.arrow_forward)),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                        );
                      }
                    },
                    separatorBuilder: (context,index){
                      return SizedBox(height: 10,);
                    },
                    itemCount: cubit.userPosts.length),
              ),
            ],
          ),
        ),
      );
    }, listener: (BuildContext context, AppStates state) {  },
        
    );
  }
}
