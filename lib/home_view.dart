import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:launcher/home_controller.dart';
import 'widgets/custom_widgets.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.put(HomeController());

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onVerticalDragEnd: (details) {
            if (details.primaryVelocity == null) {
              return;
            }
            if (details.primaryVelocity! < -200) {
              homeController.openAppList(); // swipe up
            } else if (details.primaryVelocity! > 200) {
              homeController.closeAppList(); // swipe down
            }
          },
          onHorizontalDragEnd: (details) {
            if (homeController.showAppList.value) return; 
            if (details.primaryVelocity == null) return;

            if (details.primaryVelocity! < -200) {
              // swiped left
              if (homeController.swipeLeftApp.value.isNotEmpty) {
                homeController.launchApp(homeController.swipeLeftApp.value);
              }
            } else if (details.primaryVelocity! > 200) {
              // swiped right
              if (homeController.swipeRightApp.value.isNotEmpty) {
                homeController.launchApp(homeController.swipeRightApp.value);
              }
            }
          },
          onLongPress: () {
            if (!homeController.showAppList.value) {
              CustomWidgets.showHiddenAppsSheet(context, homeController);
            }
          },
          child: Obx(() {
            return homeController.showAppList.value
                ? CustomWidgets.showApp()
                : CustomWidgets.showClock();
          }),
        ),
      ),
    );
  }
}
