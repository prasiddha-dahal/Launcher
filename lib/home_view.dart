import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:launcher/clock_controller.dart';
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
