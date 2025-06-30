import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Datetimepicker extends GetxController {
  final Rx<DateTime?> visibleAt = Rx<DateTime?>(null);

  /// Show date & time picker and update `visibleAt`
  Future<void> pickVisibleTime() async {
    final ctx = Get.context!; // ✅ Safe GetX context

    final pickedDate = await showDatePicker(
      context: ctx,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate == null) return;

    final pickedTime = await showTimePicker(
      context: ctx,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime == null) return;

    visibleAt.value = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );
  }
}
