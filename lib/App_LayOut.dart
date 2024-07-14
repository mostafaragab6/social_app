import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:social_app/Models/App_Cubit/Cubit.dart';
import 'package:social_app/Models/App_Cubit/States.dart';
import 'package:social_app/Modules/Create_Post_Screen.dart';

class LayOut extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(

      builder: (BuildContext context, AppStates state) {
        var cubit = AppCubit.get(context);
        return  Scaffold(
              body:
            ConditionalBuilder(
            condition: cubit.userModel != null && cubit.postsModel != null,
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

                  cubit.Screens[cubit.currentIndex],
                  Padding(
                    padding: const EdgeInsetsDirectional.only(start: 15.0,end: 90.0,bottom: 20.0),
                    child: Align(
                      alignment: Alignment(0.0,1.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(40.0),
                        child: BottomNavigationBar(
                          type: BottomNavigationBarType.fixed,
                          showUnselectedLabels: false,
                          useLegacyColorScheme: false,
                          selectedLabelStyle: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.w900,
                              fontSize: 15
                          ),
                          backgroundColor: Colors.white,
                          currentIndex: cubit.currentIndex,
                          onTap: (int index){
                            cubit.ChangeIndex(index);
                          },
                          items: cubit.items,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment(0.9,0.941),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: FloatingActionButton(
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (builder)=>CreatePostScreen()));
                        },
                        child: Icon(Icons.add,
                          color: Colors.white,),
                        backgroundColor:MaterialColor(0xFF33DABE, {}),
                      ),
                    ),
                  )
                ],
              );
          },
          fallback: (BuildContext context) {
            return Center(child: SpinKitCircle(color: Colors.deepPurple,));
          },

        ));
      },

      listener: (BuildContext context, AppStates state) {  },

    );
  }
}
