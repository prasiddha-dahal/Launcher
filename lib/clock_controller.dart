// lib/controllers/clock_controller.dart
import 'dart:async';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ClockController extends GetxController {
  var currentTime = ''.obs;
  var currentDate = ''.obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateTime());
  }

  void _updateTime() {
    final now = DateTime.now();
    currentTime.value = DateFormat('hh:mm a').format(now);
    currentDate.value = DateFormat('EEEE, d MMMM').format(now);
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}