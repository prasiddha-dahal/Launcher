// lib/controllers/clock_controller.dart
import 'dart:async';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nepali_utils/nepali_utils.dart';

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
    final nepaliDate = now.toNepaliDateTime();
    currentDate.value =
        '${nepaliDate.day}, ${_getNepaliMonth(nepaliDate.month)}';
  }

  String _getNepaliMonth(int month) {
    const months = [
      'Baisakh',
      'Jestha',
      'Ashadh',
      'Shrawan',
      'Bhadra',
      'Ashwin',
      'Kartik',
      'Mangsir',
      'Poush',
      'Magh',
      'Falgun',
      'Chaitra',
    ];

    return months[month - 1];
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
