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

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),
            Obx(() => Text(
                  clockController.currentTime.value,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.w300),
                )),
            Obx(() => Text(
                  clockController.currentDate.value,
                  style: const TextStyle(color: Colors.grey, fontSize: 16),
                )),
            const SizedBox(height: 20),
            Expanded(
              child: Obx(() {
                if (homeController.isLoading.value) {
                  return const Center(
                    child: Text('Loading...',
                        style: TextStyle(color: Colors.white)),
                  );
                }
                return ListView.builder(
                  itemCount: homeController.apps.length,
                  itemBuilder: (context, index) {
                    final app = homeController.apps[index];
                    return ListTile(
                      title: Text(
                        app.name,
                        style: const TextStyle(
                            color: Colors.white, fontSize: 18),
                      ),
                      onTap: () => homeController.lauchApp(app.packageName),
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