import 'package:cached_network_image/cached_network_image.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:social_app/Const/Consts.dart';
import 'package:social_app/Models/App_Cubit/Cubit.dart';
import 'package:social_app/Models/App_Cubit/States.dart';
import 'package:social_app/Models/User_Model.dart';

class SearchedUser extends StatelessWidget {


  UserModel userModel;
  SearchedUser({required this.userModel});


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      builder: (BuildContext context, AppStates state) {
        var cubit = AppCubit.get(context);

        return WillPopScope(
          onWillPop: () async{
            userModel.followers.clear();
            userModel.following.clear();
           return true;
          },
          child: Scaffold(
            body: ConditionalBuilder(
              condition: userModel != null,
              builder: (BuildContext context) {  
                return Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: double.infinity,

                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,

                              colors: [
                                MaterialColor(0xFF3CDEC4, {}).withOpacity(0.4),
                                MaterialColor(0xFFF4F7F6, {}),
                                MaterialColor(0xFFF4F7F6, {}),
                                MaterialColor(0xFFF4F7F6, {}),
                                MaterialColor(0xFFF4F7F6, {}),


                              ])
                      ),
                    ),
                    SafeArea(

                        child:
                        SingleChildScrollView(
                          child: Column(

                            children: [

                              Align(
                                  alignment: AlignmentDirectional.topStart,
                                  child: Padding(
                                    padding: const EdgeInsetsDirectional.only(start: 15.0 ,top: 20.0),
                                    child: Row(
                                      children: [
                                        IconButton(onPressed: (){
                                         // cubit.specificUserModel =null;
                                          Navigator.pop(context);
                                        }, icon: Icon(Icons.arrow_back_ios_new)),
                                        Text('${userModel.userName}',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w400
                                          ),),
                                      ],
                                    ),
                                  )),


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
                                      imageUrl: '${userModel.image}',
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
                              Text('${userModel.name}'
                                ,style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500
                                ),),

                              SizedBox(height: 25,),

                              Padding(
                                padding: const EdgeInsetsDirectional.symmetric(horizontal: 25.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: InkWell(
                                        onTap: (){
                                          if(cubit.checkFollow(uId: userModel.uId!)) {
                                            cubit.deleteFollow(
                                                followedUId: userModel.uId!);
                                            userModel.followers.clear();
                                            userModel.following.clear();
                                            cubit.getSpecificUserData(userModel);



                                            //cubit.GetUserData(cubit.userModel!.uId!);


                                          }
                                          else {

                                             cubit.makeFollow(
                                              followedUId: userModel.uId!,);
                                            userModel.followers.clear();
                                            userModel.following.clear();
                                            cubit.getSpecificUserData(userModel);



                                            //cubit.GetUserData(cubit.userModel!.uId!);

                                          }
                                        },
                                        child: Container(
                                          height: 30,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(20),
                                              color: MaterialColor(0xFF67E9D7, {})
                                          ),
                                          child:
                                          Center(child: cubit.checkFollow(uId: userModel.uId!)?
                                          Text('Following',style: TextStyle(color: Colors.black),):
                                          Text('Follow',style: TextStyle(color: Colors.black),)
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10,),
                                    Expanded(
                                      child: InkWell(
                                        onTap: (){

                                        },
                                        child: Container(
                                          height: 30,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(20),
                                              color: Colors.grey[300]
                                          ),
                                          child:
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text('Message',style: TextStyle(color: Colors.black),),
                                              SizedBox(width: 5,),
                                              Icon(Icons.telegram,color: Colors.grey,)
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),

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
                                            Text('${cubit.specificUserPosts.length}',style: TextStyle(
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
                                            Text('${userModel.followers.length}',style: TextStyle(
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
                                            Text('${userModel.following.length}',style: TextStyle(
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
                                      return Card(
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
                                                            imageUrl: '${cubit.specificUserPosts[index].userImage}',
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
                                                        Text('${cubit.specificUserPosts[index].userName}',
                                                          style: TextStyle(
                                                              fontSize: 17,
                                                              fontWeight: FontWeight.w700
                                                          ),),
                                                        Text("${DateFormat('MMMM d, y').format(cubit.specificUserPosts[index].dateTime!)}",
                                                          style: TextStyle(
                                                              color: Colors.grey,
                                                              fontSize: 15
                                                          ),)
                                                      ],
                                                    )
                                                  ],
                                                ),
                                                SizedBox(height: 20,),
                                                Text('${cubit.specificUserPosts[index].content}'
                                                  ,style: TextStyle(
                                                    fontSize: 17,

                                                  ),),
                                                SizedBox(height: 20,),
                                                cubit.specificUserPosts[index].postImage!.isNotEmpty ?
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
                                                        imageUrl: '${cubit.specificUserPosts[index].postImage}',fit: BoxFit.cover,
                                                        placeholder: (context, url) => SpinKitRing(
                                                          color: Colors.grey,
                                                          lineWidth: 3.0,
                                                          size: 50.0,
                                                          duration: Duration(milliseconds: 50),
                                                        ),
                                                        errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
                                                      )
                                                  )
                                                  ,
                                                ):SizedBox(),
                                                SizedBox(height: 10,),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: IconButton(
                                                          onPressed: (){
                                                            if(cubit.checkLike(postId: cubit.specificUserPosts[index].postId!)) {

                                                              cubit.DeleteLike(postId: cubit.specificUserPosts[index].postId!);

                                                            }
                                                            else{
                                                              cubit.MakeLike(
                                                                  postId: cubit.specificUserPosts[index].postId!,
                                                                  userName: cubit.userModel!
                                                                      .name!,
                                                                  email: cubit.userModel!
                                                                      .email!
                                                              );
                                                            }
                                                          },
                                                          icon: cubit.checkLike(postId: cubit.specificUserPosts[index].postId!) ?
                                                          Icon(Icons.favorite,color: Colors.red,) : Icon(Icons.favorite_outline,)
                                                      ),
                                                    ),
                                                    Text("|"),
                                                    Expanded(
                                                      child: IconButton(
                                                          onPressed: (){},
                                                          icon: Icon(Icons.arrow_forward)),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          )
                                      );
                                    },
                                    separatorBuilder: (context,index){
                                      return SizedBox(height: 10,);
                                    },
                                    itemCount: cubit.specificUserPosts.length),
                              ),
                            ],
                          ),
                        )


                    ),
                  ],
                );
              },
              fallback: (BuildContext context) { 
                return Center(child: SpinKitCircle(color: Colors.deepPurple,));
                ; 
              },
              
            ),
          ),
        ) ;
      },
      listener: (BuildContext context, AppStates state) {  },

    );
  }
}
