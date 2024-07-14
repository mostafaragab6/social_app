import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:social_app/Models/Register_Cubit/Cubit.dart';

import '../Models/Register_Cubit/States.dart';

class RegisterScreen extends StatelessWidget {

  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var emailController = TextEditingController();
  var passController = TextEditingController();
  var userNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context)=>RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterStates>(
        builder: (BuildContext context, state) {
          var cubit = RegisterCubit.Get(context);
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
                        Text("Register",
                          style: TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.w600
                          ),),
                        Text("Register to communicate with your friends",
                          style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.grey
                          ),),
                        SizedBox(height: 40.0,),
                        TextFormField(
                          controller: userNameController,
                          keyboardType: TextInputType.text,
                          validator: (value){
                            if(value!.isEmpty){
                              return "Please write your user name";
                            }
                          },
                          decoration: InputDecoration(
                            label: Text('User name'),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0)
                            ),
                            prefixIcon: Icon(Icons.person),

                          ),
                        ),
                        SizedBox(height: 20.0,),
                        TextFormField(
                          controller: nameController,
                          keyboardType: TextInputType.text,
                          validator: (value){
                            if(value!.isEmpty){
                              return "Please write your Full name";
                            }
                          },
                          decoration: InputDecoration(
                            label: Text('Full name'),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0)
                            ),
                            prefixIcon: Icon(Icons.person),

                          ),
                        ),
                        SizedBox(height: 20.0,),
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
                        TextFormField(
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          validator: (value){
                            if(value!.isEmpty){
                              return "Please write your phone number";
                            }
                          },
                          decoration: InputDecoration(
                            label: Text('Phone'),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0)
                            ),
                            prefixIcon: Icon(Icons.phone),

                          ),
                        ),
                        SizedBox(height: 20.0,),
                        ConditionalBuilder(
                          condition: state is! RegisterLoadingState,
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
                                   cubit.CreateUser(userName:userNameController.text,email: emailController.text, password: passController.text,name: nameController.text,phone: phoneController.text);
                                  }
                                },

                                child: Text('Register',
                                  style: TextStyle(
                                      color: Colors.white
                                  ),),
                              ),
                            );
                          },
                          fallback: (BuildContext context) {
                            return Center(child: SpinKitCircle(color: Colors.deepPurple,));
                          },

                        )
                      ],
                    ),
                  ),
                )
            ),
          );
        },
        listener: (BuildContext context, Object? state) {  },

      ),
    );
  }
}
