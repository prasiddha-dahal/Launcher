import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:launcher/clock_controller.dart';
import 'package:launcher/home_controller.dart';

class CustomWidgets {
  final HomeController homeController = Get.put(HomeController());
  final ClockController clockController = Get.put(ClockController());

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
                    onLongPress: () {
                      Get.bottomSheet(
                        Container(
                          color: Colors.grey[900],
                          child: Wrap(
                            children: [
                              ListTile(
                                leading: const Icon(
                                  Icons.visibility_off,
                                  color: Colors.white,
                                ),
                                title: const Text(
                                  'Hide app',
                                  style: TextStyle(color: Colors.white),
                                ),
                                onTap: () {
                                  homeController.hideApp(app.packageName);
                                  Get.back(); // close bottom sheet
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      );
    });
  }

  static void showHiddenAppsSheet(BuildContext context, HomeController homeController) {
  Get.bottomSheet(
    Container(
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.6),
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 24, 23, 23),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Hidden apps',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Flexible(
            child: Obx(() {
              final hiddenPackages = homeController.hiddenApps;
              if (hiddenPackages.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(24),
                  child: Text(
                    'No hidden apps',
                    style: TextStyle(color: Colors.white70),
                  ),
                );
              }
              // Match package names back to their AppInfo for display names
              final hiddenAppInfos = homeController.apps
                  .where((app) => hiddenPackages.contains(app.packageName))
                  .toList();

              return ListView.builder(
                shrinkWrap: true,
                itemCount: hiddenAppInfos.length,
                itemBuilder: (context, index) {
                  final app = hiddenAppInfos[index];
                  int i = index + 1;
                  return ListTile(
                    title: Text("$i. ${app.name}", style: const TextStyle(color: Colors.white)),
                    trailing: ElevatedButton(
                      onPressed: () => homeController.unhideApp(app.packageName),
                      child: const Text('Unhide', style: TextStyle(color: Colors.black),),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    ),
  );
}
}
