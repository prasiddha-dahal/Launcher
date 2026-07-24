import 'package:get/get.dart';
import 'package:launcher/clock_controller.dart';
import 'package:launcher/home_controller.dart';

class ControllerBinding extends Bindings{
  @override
  void dependencies() {
    Get.put<HomeController>(HomeController(),permanent: true);
    Get.put<ClockController>(ClockController(),permanent: true);
  }
}