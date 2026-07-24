import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:launcher/home_controller.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
      var homeController = Get.find<HomeController>();
    return Scaffold(
      body: SafeArea(
        child: Obx((){
          if(homeController.isLoading == true){
            return Center(
              child: Text("loading..."),
            );
          }else {
            return ListView.builder(
              itemCount: homeController.apps.length, 
              itemBuilder:(BuildContext context, int index){
                final app = homeController.apps[index];
                return ListTile(
                  title: Text("${app.name}"),
                  onTap: (){
                    homeController.lauchApp("${app.packageName}");
                  },
                );
              } 
              );
          }
        }),
        
      ),
    );
  }
}