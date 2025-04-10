import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeProvider with ChangeNotifier {
  DateTime _startTime;
  Duration _timeUnit = const Duration(hours: 1, minutes: 30);
  final List<TimeCard> _timeCards = [];

  TimeProvider() : _startTime = _getInitialTime();

  static DateTime _getInitialTime() {
    final now = DateTime.now();
    debugPrint('현재 시간: ${DateFormat('HH:mm').format(now)}');
    final minutes = now.minute;
    final roundedMinutes = ((minutes + 4) ~/ 5) * 5;
    if (roundedMinutes >= 60) {
      final nextTime = DateTime(
        now.year,
        now.month,
        now.day,
        now.hour + 1,
        0,
      );
      debugPrint('올림된 시간: ${DateFormat('HH:mm').format(nextTime)}');
      return nextTime;
    }
    final roundedTime = DateTime(
      now.year,
      now.month,
      now.day,
      now.hour,
      roundedMinutes,
    );
    debugPrint('올림된 시간: ${DateFormat('HH:mm').format(roundedTime)}');
    return roundedTime;
  }

  DateTime get startTime => _startTime;
  Duration get timeUnit => _timeUnit;
  List<TimeCard> get timeCards => _timeCards;

  void setStartTime(DateTime time) {
    _startTime = time;
    notifyListeners();
  }

  void setTimeUnit(Duration duration) {
    _timeUnit = duration;
    notifyListeners();
  }

  void addTimeCard() {
    DateTime nextStartTime;
    if (_timeCards.isEmpty) {
      nextStartTime = _startTime;
    } else {
      final lastCard = _timeCards.last;
      nextStartTime = lastCard.startTime.add(lastCard.duration);
    }

    _timeCards.add(TimeCard(
      startTime: nextStartTime,
      duration: _timeUnit,
    ));
    notifyListeners();
  }

  String formatTime(DateTime time) {
    return DateFormat('HH:mm').format(time);
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}

class TimeCard {
  final DateTime startTime;
  final Duration duration;

  TimeCard({
    required this.startTime,
    required this.duration,
  });

  bool isExpired() {
    final now = DateTime.now();
    final endTime = startTime.add(duration);
    return now.isAfter(endTime);
  }

  bool isCurrent() {
    final now = DateTime.now();
    return now.isAfter(startTime) && !isExpired();
  }

  Duration getRemainingTime() {
    final now = DateTime.now();
    if (isExpired()) {
      return Duration.zero;
    }
    if (!isCurrent()) {
      return duration;
    }
    final endTime = startTime.add(duration);
    return endTime.difference(now);
  }
} 