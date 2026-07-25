import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:launcher/clock_controller.dart';
import 'package:launcher/home_controller.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.put(HomeController());
    final ClockController clockController = Get.put(ClockController());

    Widget showClock() {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(
              () => Text(
                clockController.currentTime.value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            Obx(
              () => Text(
                clockController.currentDate.value,
                style: const TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ),
          ],
        ),
      );
    }

    Widget showApp(){
      return Obx(() {
        if (homeController.isLoading.value) {
          return Center(
            child: Text(
              'Loading...',
              style: TextStyle(color: Colors.white),
            ),
          );
        }
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                autofocus: true,
                style: TextStyle(color: Colors.white, ),
                onChanged: (query){
                  homeController.filterApps(query);
                },
                decoration: InputDecoration(
                  hintText: "Search Apps",
                  hintStyle: TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white10

                ),
              ),
            ),                  


            Expanded(
              child: NotificationListener<OverscrollNotification>(
                onNotification: (notification){
                  if(notification.overscroll < -20){
                    homeController.closeAppList();
                  }
                  return true;
                },
                child: ListView.builder(
                  itemCount: homeController.filteredApps.length,
                  itemBuilder: (context, index) {
                    final app = homeController.filteredApps[index];
                    return ListTile(
                      title: Text(
                        app.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      onTap: () => homeController.launchApp(app.packageName),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      });
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onVerticalDragEnd: (details) {
            if(details.primaryVelocity == null){
              return;
            }
            if(details.primaryVelocity! < -200){
              homeController.openAppList(); // swipe up
            }else if(details.primaryVelocity! > 200){
              homeController.closeAppList(); // swipe down
            }
          },
          child: Obx((){
            return homeController.showAppList.value ? showApp() : showClock();
          }),
        )  
      ),
    );
  }
}
