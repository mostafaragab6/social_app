import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:social_app/Models/App_Cubit/Cubit.dart';

import '../Models/App_Cubit/States.dart';

class EditProfile extends StatelessWidget {

  var nameController = TextEditingController();
  var userNameController = TextEditingController();
  var phoneNumberController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      builder: (BuildContext context, AppStates state) {
        var cubit = AppCubit.get(context);
        nameController.text = cubit.userModel!.name!;
        userNameController.text = cubit.userModel!.userName!;
        phoneNumberController.text = cubit.userModel!.phone!;
        return  Scaffold(

          appBar: AppBar(
            title: Text('Edit',),
          ),
          body: Padding(
            padding: const EdgeInsets.all(15.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  if(state is UpdateUserLoading || state is UploadProfileImageToStorageLoading)
                    LinearProgressIndicator(color: Colors.blue,),

                  SizedBox(height: 20.0,),
                  Stack(
                    alignment: AlignmentDirectional.bottomEnd,
                    children: [
                      CircleAvatar(
                      radius: 70,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: NetworkImage('${cubit.userModel!.image}'),
                    ),
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.blue,
                        child: IconButton(
                            onPressed: (){
                              cubit.pickProfileImage();
                            },
                            icon: Icon(Icons.camera_alt_outlined,color: Colors.white,)
                        ),
                      ),
              
                    ],
                  ),
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
                    controller: phoneNumberController,
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
                    condition: state is! UpdateUserLoading,
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
                            if(cubit.profileImage != null){
                              cubit.uploadProfileImage(
                                  fullName: nameController.text,
                                  userName: userNameController.text,
                                  phone: phoneNumberController.text);
                              cubit.profileImage = null;
                              cubit.profileImageUrl='';
                            }
                            else {
                              cubit.updateUser(
                                  fullName: nameController.text,
                                  userName: userNameController.text,
                                  phone: phoneNumberController.text);
                              cubit.updateUserPosts(userName: nameController.text);
                            }
                          },
              
                          child: Text('Save',
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
          ),
        );
      },
      listener: (BuildContext context, AppStates state) {  },

    );
  }
}
