import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:social_app/Models/App_Cubit/Cubit.dart';
import 'package:social_app/Models/App_Cubit/States.dart';
import 'package:social_app/Modules/Searched_User.dart';

class SearchScreen extends StatelessWidget {

  var searchController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {

    return BlocConsumer<AppCubit,AppStates>(
        builder: (BuildContext context, state) {
          var cubit = AppCubit.get(context);

          return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: searchController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    label: Text('Search for someone...'),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0)
                    ),
                    prefixIcon: Icon(Icons.search),
            
                    
                  ),
                  onChanged: (value){
                      cubit.Search(userName: searchController.text);
                  },
                ),
                
                SizedBox(height: 20.0,),
                
                ListView.separated(
                  shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context,index){
                    return
                      cubit.allUsersData![index].email == cubit.userModel!.email?
                        SizedBox()
                     :
                      InkWell(
                      onTap: (){
                          cubit.getSpecificUserData(cubit.allUsersData![index]);
                          cubit.GetPosts(
                              email: cubit.allUsersData![index].email);
                          //cubit.getSpecificUserFollowers(cubit.allUsersData![index].uId!);

                          Navigator.push(context, MaterialPageRoute(
                              builder: (builder) =>
                                  SearchedUser(userModel: cubit.allUsersData![index],)));

                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                  imageUrl: '${cubit.allUsersData![index].image}',
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

                          Padding(
                            padding: const EdgeInsetsDirectional.only(top: 5.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${cubit.allUsersData![index].name}'),
                                Text('${cubit.allUsersData![index].userName}',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[700]
                                ),)
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                    },
                    separatorBuilder: (context,index)=>SizedBox(height: 20.0,),
                    itemCount: cubit.allUsersData!.length)
              ],
            ),
          ),
        ),
      );
    },
    listener: (BuildContext context, Object? state) {  });
  }
}
