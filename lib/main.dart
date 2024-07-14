import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/App_LayOut.dart';
import 'package:social_app/Const/Consts.dart';
import 'package:social_app/Models/App_Cubit/Cubit.dart';
import 'package:social_app/Models/App_Cubit/States.dart';
import 'package:social_app/Modules/LoginScreen.dart';

import 'Shared/Cache_Helper.dart';

void main() async{
 print(uId);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: "AIzaSyDnPJnKuqv1F36cOYXYA7Ni7wyPOArpAf0",
        appId: "1:209622388600:android:8e1ae49428350131bd828d",
        messagingSenderId: "209622388600",
        projectId: "social-app-71585",
        storageBucket: 'social-app-71585.appspot.com'
    )
  );
 await CacheHelper.init();

 uId = CacheHelper.GetData(key: 'uId');

 runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..GetUserData(uId!)..GetPosts(),
      child: BlocConsumer<AppCubit,AppStates>(
        builder: (BuildContext context, AppStates state) {
          return MaterialApp(

            debugShowCheckedModeBanner: false,
            home: uId != null ?LayOut(): LoginScreen(),
          );
        },
        listener: (BuildContext context, AppStates state) {  },

      ),
    );
  }
}

