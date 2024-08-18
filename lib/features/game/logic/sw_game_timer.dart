import 'dart:async';

import 'package:flutter/material.dart';

class SWGameTimerController extends ValueNotifier<Duration> {
  Timer? _timer;
  final Duration duration;
  final VoidCallback onFinished;
  bool isDisposed = false;

  SWGameTimerController(this.duration, {required this.onFinished})
      : super(duration);

  void start() {
    // Optional: Reset value to duration before starting
    value = duration;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (value.inSeconds > 0) {
        value = value - const Duration(seconds: 1);
      } else {
        stop();
        if (!isDisposed) {
          onFinished();
        }
      }
    });
  }

  void stop() {
    _timer?.cancel();
  }

  void reset() {
    value = duration;
    stop();
  }

  @override
  void dispose() {
    isDisposed = true;
    stop();
    super.dispose();
  }
}
