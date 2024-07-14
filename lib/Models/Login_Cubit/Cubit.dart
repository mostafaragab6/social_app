import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/Models/App_Cubit/Cubit.dart';
import 'package:social_app/Models/Login_Cubit/States.dart';
import 'package:social_app/Shared/Cache_Helper.dart';

import '../../Const/Consts.dart';
import '../User_Model.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());

  static LoginCubit Get(context) => BlocProvider.of(context);



  void LoginUser({required String email , required String password}){
    emit(LoginLoadingState());
    FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password
    ).then((value) {
      print('Done!');

      uId = value.user!.uid;
      CacheHelper.saveData(key: 'uId', value: value.user!.uid);
      emit(LoginSuccessState());
    }).catchError((error){
      print(error.toString());
      emit(LoginErrorState());
    });
  }


  bool isPass = true;
  void ChangePassVisibility(){
    isPass = !isPass;
    emit(ChangePassVisibilityState());
  }
}