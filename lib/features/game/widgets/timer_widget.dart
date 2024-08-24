import 'package:flutter/material.dart';
import 'dart:async';

import 'package:sketch_wizards/theme/sw_theme.dart';

class TimerWidget extends StatefulWidget {
  final int duration; // Duration in seconds

  const TimerWidget({super.key, required this.duration});

  @override
  // ignore: library_private_types_in_public_api
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  late Timer _timer;
  double _progress = 1.0;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _progress -= 1 / widget.duration;
        if (_progress <= 0.0) {
          _progress = 0.0;
          _timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 1.0, end: _progress),
      duration: const Duration(milliseconds: 500),
      builder: (context, value, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 300,
              height: 300,
              child: CircularProgressIndicator(
                value: value,
                strokeWidth: 30,
                backgroundColor: Colors.transparent,
                valueColor:
                    const AlwaysStoppedAnimation<Color>(SWTheme.primaryColor),
              ),
            ),
            Text(
              '${(widget.duration * value).round()}s',
              style: SWTheme.boldTextStyle.copyWith(fontSize: 80),
            ),
          ],
        );
      },
    );
  }
}
