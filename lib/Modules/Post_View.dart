import 'package:cached_network_image/cached_network_image.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:social_app/Models/App_Cubit/Cubit.dart';
import 'package:social_app/Models/App_Cubit/States.dart';

class PostView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      builder: (BuildContext context, AppStates state) {
        var cubit = AppCubit.get(context);
        return Scaffold(
          backgroundColor: Colors.grey[200],
          body:
          SafeArea(
            child: SingleChildScrollView(
              child: ConditionalBuilder(
                condition: cubit.postData != null,
                builder: (BuildContext context) {
                  return  Column(
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: IconButton(
                                onPressed: (){
                                  Navigator.pop(context);
                                },
                                icon: Icon(Icons.arrow_back_ios_new)),
                          ),
                          Text('Post',style: TextStyle(
                              fontSize: 20
                          ),)
                        ],
                      ),

                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Card(
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
                                              imageUrl: '${cubit.postData!.userImage!}',
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
                                            '${cubit.postData!
                                                .userName}',
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w700
                                            ),),
                                          Text(
                                            "${DateFormat('MMMM d, y').format(
                                                cubit.postData!
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
                                    '${cubit.postData!.content}'
                                    , style: TextStyle(
                                    fontSize: 17,

                                  ),),
                                  SizedBox(height: 20,),

                                  cubit.postData!.postImage!
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
                                          imageUrl: '${cubit.postData!.postImage}',
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
                                                  postId: cubit.postData!.postId!)) {
                                                cubit.DeleteLike(
                                                    postId: cubit.postData!.postId!);
                                              }
                                              else {
                                                cubit.MakeLike(
                                                    postId: cubit.postData!.postId!,
                                                    userName: cubit.userModel!
                                                        .name!,
                                                    email: cubit.userModel!
                                                        .email!
                                                );
                                              }
                                            },
                                            icon: cubit.checkLike(
                                                postId: cubit.postData!.postId!) ?
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
                                                  sharedPostId: cubit.postData!.postId!,
                                                  content: cubit.postData!.content!,
                                                  userName: cubit.postData!.userName!,
                                                  dateTime: cubit.postData!.dateTime!,
                                                  ownerImage: cubit.postData!
                                                      .userImage!,
                                                  postImage: cubit.postData!.postImage,
                                                  currentDateTime: dateTime);
                                            },
                                            icon: Icon(Icons.arrow_forward)),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                        ),
                      )
                    ],
                  );
                },
                fallback: (BuildContext context) {
                  return Center(child: SpinKitCircle(color: Colors.deepPurple,));

                },

              ),
            ),
          ),
        );
      },
      listener: (BuildContext context, AppStates state) {  },
    );
  }
}
