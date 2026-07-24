import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:launcher/clock_controller.dart';
import 'package:launcher/home_controller.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

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
        return NotificationListener<OverscrollNotification>(
          onNotification: (notification){
            if(notification.overscroll < -20){
              homeController.closeAppList();
            }
            return true;
          },
          child: ListView.builder(
            itemCount: homeController.apps.length,
            itemBuilder: (context, index) {
              final app = homeController.apps[index];
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
        );
      });
    }
return Scaffold(
  backgroundColor: Colors.transparent,
  body: SafeArea(
    child: SlidingUpPanel(
      minHeight: 40,   // small visible strip instead of 0
      maxHeight: MediaQuery.of(context).size.height * 0.9,
      panel: showApp(),
      body: showClock(),
      backdropEnabled: true,
      panelBuilder: (scrollController) => showApp(),
      collapsed: Container(
        decoration: const BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Center(
          child: Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ),
    ),
  ),
);
  }
}
