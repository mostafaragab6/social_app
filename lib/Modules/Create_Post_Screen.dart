import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:social_app/App_LayOut.dart';
import 'package:social_app/Models/App_Cubit/Cubit.dart';
import 'package:social_app/Models/App_Cubit/States.dart';
import 'package:social_app/Models/Login_Cubit/Cubit.dart';
import 'package:social_app/Models/User_Model.dart';
import 'package:social_app/Modules/Home_Screen.dart';

class CreatePostScreen extends StatelessWidget {

  var contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      builder: (BuildContext context, AppStates state) {
        var cubit = AppCubit.get(context);
        return ConditionalBuilder(
          condition: cubit.userModel != null,
          builder: (BuildContext context) {
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  "Create",style: TextStyle(
                    fontSize: 25.0,
                    color: Colors.black
                ),
                ),
                actions: [
                  IconButton(
                      onPressed: (){
                        DateTime dateTime = DateTime.now();
                        if(cubit.image != null) {
                          cubit.uploadPostImage(
                            content: contentController.text,
                            userName: cubit.userModel!.name!,
                            dateTime: dateTime,
                          );
                          cubit.image = null;
                          cubit.postImageUrl = '';
                        }
                        else {
                          cubit.CreatePost(
                            content: contentController.text,
                            userName: cubit.userModel!.name!,
                            dateTime: dateTime,
                          );
                        }
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder)=>LayOut()));
                      },
                      icon: Icon(Icons.add_box))
                ],
              ),
              body: Column(
                children: [
                  TextFormField(
                      controller: contentController,
                      maxLines: 7,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          hintText: 'Write what you want to share',
                          hintStyle: TextStyle(
                              color: Colors.grey[400]
                          ),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)
                          )
                      )
                  ),

                  IconButton(
                      onPressed: (){
                        cubit.pickImage();

                      },
                      icon: Icon(Icons.image_rounded,size: 50,))

                ],
              ),
            );
          },
          fallback: (BuildContext context) {
            return Center(child: SpinKitCircle(color: Colors.deepPurple,));
          },

        );
      },
      listener: (BuildContext context, AppStates state) {  },

    );
  }
}
