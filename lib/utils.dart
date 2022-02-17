import 'package:flutter/material.dart';

extension TimeOfDayExtensions on TimeOfDay {
  bool isValidTimeRange(TimeOfDay startTime, TimeOfDay endTime) {
    TimeOfDay now = this;
    return ((now.hour > startTime.hour) ||
            (now.hour == startTime.hour && now.minute >= startTime.minute)) &&
        ((now.hour < endTime.hour) ||
            (now.hour == endTime.hour && now.minute <= endTime.minute));
  }
}

class NewTimeOfDay extends TimeOfDay {
  NewTimeOfDay.fromDateTime(DateTime time) : super.fromDateTime(time);
  const NewTimeOfDay({required int hour, required int minute})
      : super(hour: hour, minute: minute);
}
