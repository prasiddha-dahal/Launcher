import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:launcher/clock_controller.dart';
import 'package:launcher/home_controller.dart';

class CustomWidgets {

  final HomeController homeController = Get.put(HomeController());
  final ClockController clockController = Get.put(ClockController());

  static Widget showTopApps() {
  final HomeController homeController = Get.put(HomeController());
    return Obx(() {
      if (homeController.topApps.isEmpty) {
        return const SizedBox.shrink();
      }
      return Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Text(
              'Top 3 apps you used today',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 22,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ...homeController.topApps.map((app) {
            final minutes = app.usage.inMinutes;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                '${app.appName} — ${(minutes / 60).floor()}hr and ${minutes % 60} mins',
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            );
          }),
        ],
      );
    });
  }

  static Widget showClock() {
  final ClockController clockController = Get.put(ClockController());
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
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          Gap(40),
          showTopApps(),
        ],
      ),
    );
  }

  static Widget showApp() {
  final HomeController homeController = Get.put(HomeController());
    return Obx(() {
      if (homeController.isLoading.value) {
        return Center(
          child: Text('Loading...', style: TextStyle(color: Colors.white)),
        );
      }
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              autofocus: true,
              style: TextStyle(color: Colors.white),
              onChanged: (query) {
                homeController.filterApps(query);
              },
              decoration: InputDecoration(
                hintText: "Search Apps",
                hintStyle: TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.white10,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          Expanded(
            child: NotificationListener<OverscrollNotification>(
              onNotification: (notification) {
                if (notification.overscroll < -20) {
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
                      style: const TextStyle(color: Colors.white, fontSize: 18),
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
}
