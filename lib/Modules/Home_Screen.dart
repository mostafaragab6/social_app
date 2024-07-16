import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:social_app/Models/App_Cubit/Cubit.dart';
import 'package:social_app/Models/App_Cubit/States.dart';
import 'package:social_app/Modules/Post_View.dart';

class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      builder: (BuildContext context, AppStates state) {
        var cubit = AppCubit.get(context);
        return SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.only(top: 25.0,start: 25.0,end: 25.0),
                  child: Row(
                    children: [
                      Container(
                        width: 70,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30)
                        ),
                        child:
                        Row(
                          children: [
                            SizedBox(width: 10,),
                            Icon(Icons.notifications_sharp),
                            SizedBox(width: 9),
                            Text('3')
                          ],
                        ),
                      ),
                      SizedBox(width: 10,),
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25)
                        ),
                        child:
                        Icon(Icons.comment,color: Colors.grey,)
                      ),
                      Spacer(),
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
                              imageUrl: '${cubit.userModel!.image}',
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

                    ],
                  ),
                ),
                SizedBox(height: 25.0,),
            
                Padding(
                  padding: const EdgeInsetsDirectional.only(start: 25.0,end: 25.0),
                  child: Text('Stories',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400
                  ),),
                ),
                SizedBox(height: 20.0,),
            
                Padding(
                  padding: const EdgeInsetsDirectional.only(start: 25.0),
                  child: Container(
                    height: 130,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                        itemBuilder: (context,index) {
                        if(index == 0){
                          return Container(
                            width: 100,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20)
                            ),
                            child:
                            Stack(
                              alignment: AlignmentDirectional.center,
                              children: [

                                Container(
                                width: 55,
                                height: 55,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(25)
                                ),
                                child:
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(25),
                                  child: CachedNetworkImage(
                                    imageUrl: '${cubit.userModel!.image}',
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

                                Positioned(
                                  top: 75,
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                        color: Colors.green,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: Colors.white)
                                    ),
                                    child:
                                    Icon(Icons.add,color: Colors.white,),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.only(bottom: 5.0),
                                  child: Align(
                                      alignment: AlignmentDirectional.bottomCenter,
                                      child: Text('Your Story',
                                      style: TextStyle(
                                        color: Colors.grey[500]
                                      ),)),
                                )
                              ],
                            ),
            
                          ) ;
                        }else {
                            return Container(
                              width: 100,
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(20)),
                            );
                          }
                        },
                        separatorBuilder: (context,index) {
                          return SizedBox(width: 15.0,);
            
                        }
                        ,
                        itemCount: 1),
                  ),
                ),
            
                Padding(
                  padding: const EdgeInsetsDirectional.only(top: 35.0,start: 25.0,end: 25.0),
                  child: Row(
                    children: [
                      Text('Recently Post',
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.grey
                      ),),
                    ],
                  ),
                ),

                 if(state is CreatePostLoadingState || state is UploadPostImageToStorageLoading)
                   Padding(
                     padding: const EdgeInsetsDirectional.only(top: 8.0,start: 10.0,end: 10.0,bottom: 5),
                     child: Container(
                       width: double.infinity,
                       height: 40,
                       decoration: BoxDecoration(
                         borderRadius: BorderRadius.circular(20),
                         color: Colors.grey[200]
                       ),
                       child: Column(
                         children: [
                           Text('Uploading your post...',
                             style:TextStyle(
                               color: Colors.grey[500]
                             ) ,),
                           SizedBox(height: 5,),
                           Padding(
                             padding: const EdgeInsetsDirectional.symmetric(horizontal: 10.0),
                             child: LinearProgressIndicator(color: Colors.blue,),
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
                        if(cubit.postsModel!.data[index].method == 'Share'){
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
                                              imageUrl: '${cubit.postsModel!.data[index].myImage!}',
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
                                          Text('${cubit.postsModel!.data[index].myName}',
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w700
                                            ),),
                                          Text("${DateFormat('MMMM d, y').format(cubit.postsModel!.data[index].currentDateTime!)}",
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
                                      
                                      cubit.getSpecificPostData(postId: cubit.postsModel!.data[index].sharedPostId!);
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
                                                          imageUrl: '${cubit.postsModel!.data[index].userImage!}',
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
                                                      Text('${cubit.postsModel!.data[index].userName}',
                                                        style: TextStyle(
                                                            fontSize: 17,
                                                            fontWeight: FontWeight.w700
                                                        ),),
                                                      Text("${DateFormat('MMMM d, y').format(cubit.postsModel!.data[index].dateTime!)}",
                                                        style: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 15
                                                        ),)
                                                    ],
                                                  )
                                                ],
                                              ),
                                              SizedBox(height: 20,),
                                              Text('${cubit.postsModel!.data[index].content}'
                                                ,style: TextStyle(
                                                  fontSize: 17,

                                                ),),
                                              SizedBox(height: 20,),

                                              cubit.postsModel!.data[index].postImage!.isNotEmpty ?
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
                                                      imageUrl: '${cubit.postsModel!.data[index].postImage}',fit: BoxFit.cover,
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
                                              if(cubit.checkLike(postId: cubit.postsModel!.data[index].postId!)) {

                                                cubit.DeleteLike(postId: cubit.postsModel!.data[index].postId!);

                                              }
                                              else{
                                                cubit.MakeLike(
                                                    postId: cubit.postsModel!
                                                        .data[index].postId!,
                                                    userName: cubit.userModel!
                                                        .name!,
                                                    email: cubit.userModel!
                                                        .email!
                                                );
                                              }
                                            },
                                            icon: cubit.checkLike(postId: cubit.postsModel!.data[index].postId!) ?
                                            Icon(Icons.favorite,color: Colors.red,) : Icon(Icons.favorite_outline,)
                                        ),
                                      ),
                                      Text("|"),
                                      Expanded(
                                        child: IconButton(
                                            onPressed: (){
                                              DateTime dateTime = DateTime.now();
                                              cubit.sharePost(
                                                  content: cubit.postsModel!.data[index].content!,
                                                  userName: cubit.postsModel!.data[index].userName!,
                                                  dateTime: cubit.postsModel!.data[index].dateTime!,
                                                  ownerImage: cubit.postsModel!.data[index].userImage!,
                                                  postImage: cubit.postsModel!.data[index].postImage,
                                                  currentDateTime: dateTime,
                                                  sharedPostId: cubit.postsModel!.data[index].sharedPostId!
                                              );
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
                                              borderRadius: BorderRadius
                                                  .circular(25),
                                              child: CachedNetworkImage(
                                                imageUrl: '${cubit.postsModel!
                                                    .data[index].userImage!}',
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
                                                    Center(child: Icon(
                                                        Icons.error)),
                                              ),
                                            )
                                        ),

                                        SizedBox(width: 10,),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment
                                              .start,
                                          children: [
                                            Text(
                                              '${cubit.postsModel!.data[index]
                                                  .userName}',
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w700
                                              ),),
                                            Text(
                                              "${DateFormat('MMMM d, y').format(
                                                  cubit.postsModel!.data[index]
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
                                    Text(
                                      '${cubit.postsModel!.data[index].content}'
                                      , style: TextStyle(
                                      fontSize: 17,

                                    ),),
                                    SizedBox(height: 20,),

                                    cubit.postsModel!.data[index].postImage!
                                        .isNotEmpty ?
                                    Container(
                                      width: double.infinity,
                                      height: 400,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              20)
                                      ),
                                      child:

                                      ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              20),
                                          child: CachedNetworkImage(
                                            imageUrl: '${cubit.postsModel!
                                                .data[index].postImage}',
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) =>
                                                SpinKitRing(
                                                  color: Colors.grey,
                                                  lineWidth: 3.0,
                                                  size: 50.0,
                                                  duration: Duration(
                                                      milliseconds: 50),
                                                ),
                                            errorWidget: (context, url,
                                                error) =>
                                                Center(
                                                    child: Icon(Icons.error)),
                                          )
                                      ),
                                    ) : SizedBox(),
                                    SizedBox(height: 10,),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: IconButton(
                                              onPressed: () {
                                                if (cubit.checkLike(
                                                    postId: cubit.postsModel!
                                                        .data[index].postId!)) {
                                                  cubit.DeleteLike(
                                                      postId: cubit.postsModel!
                                                          .data[index].postId!);
                                                }
                                                else {
                                                  cubit.MakeLike(
                                                      postId: cubit.postsModel!
                                                          .data[index].postId!,
                                                      userName: cubit.userModel!
                                                          .name!,
                                                      email: cubit.userModel!
                                                          .email!
                                                  );
                                                }
                                              },
                                              icon: cubit.checkLike(
                                                  postId: cubit.postsModel!
                                                      .data[index].postId!) ?
                                              Icon(Icons.favorite,
                                                color: Colors.red,) : Icon(
                                                Icons.favorite_outline,)
                                          ),
                                        ),
                                        Text("|"),
                                        Expanded(
                                          child: IconButton(
                                              onPressed: () {
                                                DateTime dateTime = DateTime
                                                    .now();
                                                cubit.sharePost(
                                                  sharedPostId: cubit.postsModel!
                                                      .data[index].postId!,
                                                    content: cubit.postsModel!
                                                        .data[index].content!,
                                                    userName: cubit.postsModel!
                                                        .data[index].userName!,
                                                    dateTime: cubit.postsModel!
                                                        .data[index].dateTime!,
                                                    ownerImage: cubit
                                                        .postsModel!.data[index]
                                                        .userImage!,
                                                    postImage: cubit.postsModel!
                                                        .data[index].postImage,
                                                    currentDateTime: dateTime);
                                              },
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
                        itemCount: cubit.postsModel!.data.length),
                 ),
                

              ],
            ),
          ),
        );
      },
      listener: (BuildContext context, AppStates state) {  },

    );
  }
}
