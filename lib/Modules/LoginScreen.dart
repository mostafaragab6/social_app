import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:social_app/App_LayOut.dart';
import 'package:social_app/Models/App_Cubit/Cubit.dart';
import 'package:social_app/Models/Login_Cubit/Cubit.dart';
import 'package:social_app/Modules/Register_Screen.dart';
import 'package:social_app/Shared/Cache_Helper.dart';

import '../Const/Consts.dart';
import '../Models/Login_Cubit/States.dart';

class LoginScreen extends StatelessWidget {

  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context)=>LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        builder: (BuildContext context, state) {
          var cubit = LoginCubit.Get(context);
          return Scaffold(
            //appBar: AppBar(),
            body: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Padding(
                    padding:  EdgeInsetsDirectional.symmetric(horizontal: 40.0,vertical: MediaQuery.sizeOf(context).height/6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Login",
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.w600
                        ),),
                        Text("Login to communicate with your friends",
                          style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.grey
                          ),),
                        SizedBox(height: 40.0,),
                        TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value){
                            if(value!.isEmpty){
                              return "Please write your email address";
                            }
                          },
                          decoration: InputDecoration(
                            label: Text('Email address'),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0)
                            ),
                            prefixIcon: Icon(Icons.email),

                          ),
                        ),
                        SizedBox(height: 20.0,),
                        TextFormField(
                          obscureText: cubit.isPass,
                          controller: passController,
                          keyboardType: TextInputType.text,
                          validator: (value){
                            if(value!.isEmpty){
                              return "Please write your password";
                            }
                          },
                          decoration: InputDecoration(
                            suffixIcon: IconButton(onPressed: (){
                              cubit.ChangePassVisibility();
                            }, icon: cubit.isPass? Icon(Icons.visibility_off_outlined):Icon(Icons.visibility_outlined)),
                            label: Text('Password'),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0)
                            ),
                            prefixIcon: Icon(Icons.password),

                          ),
                        ),
                        SizedBox(height: 20.0,),
                        ConditionalBuilder(
                          condition: state is! LoginLoadingState,
                          builder: (BuildContext context) {
                            return Container(
                              width: double.infinity,
                              height: 50.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                color: Colors.green[700],
                              ),
                              child: MaterialButton(
                                onPressed: (){
                                  if(formKey.currentState!.validate()){
                                    cubit.LoginUser(email: emailController.text, password: passController.text);

                                  }
                                },

                                child: Text('Login',
                                  style: TextStyle(
                                      color: Colors.white
                                  ),),
                              ),
                            );
                          },
                          fallback: (BuildContext context) {
                            return Center(child: SpinKitCircle(color: Colors.deepPurple,));
                          },

                        ),
                        Row(
                          children: [
                            Text('Do not have an account? '),
                            TextButton(
                                onPressed: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>RegisterScreen()));
                                },
                                child: Text('REGISTER',style: TextStyle(color: Colors.green)),)
                          ],
                        )
                      ],
                    ),
                  ),
                )
            ),
          );
        },
        listener: (BuildContext context, Object? state) {

          if(state is LoginSuccessState){

            AppCubit.get(context).GetUserData(uId!);
            AppCubit.get(context).GetPosts();
            Navigator.push(context, MaterialPageRoute(builder: (context)=>LayOut()));
          }
        },

      ),
    );
  }
}
