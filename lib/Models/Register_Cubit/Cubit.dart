import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/Models/Register_Cubit/States.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitialState());

  static RegisterCubit Get(context) => BlocProvider.of(context);


  void CreateUser({required String userName,required String name,required String email, required String password, required String phone}){

    emit(RegisterLoadingState());
    FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password
    ).then((value){
      print(value.user!.email);
      print(value.user!.uid);

      FirebaseAuth.instance.currentUser!.sendEmailVerification();
      FirebaseFirestore.instance
          .collection('users').doc(value.user!.uid)
          .set({
              "userName":userName,
              "name" : name,
              "email" : email,
              "image" : "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRseRj5MjxLYtgPrmGHS01YBytPjIkGKk8Zaw&s",
              "phone" : phone,
              "uId" : value.user!.uid
           });
      emit(RegisterSuccessState());
    }).catchError((error){
      print(error.toString());
      emit(RegisterErrorState());
    });

  }





  bool isPass = true;
  void ChangePassVisibility(){
    isPass = !isPass;
    emit(ChangePassVisibilityState());
  }
}