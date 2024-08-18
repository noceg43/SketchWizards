import 'package:flutter/material.dart';
import 'package:sketch_wizards/theme/sw_theme.dart';

class SWDrawResultScreen extends StatefulWidget {
  const SWDrawResultScreen(
      {super.key, required this.isCorrect, required this.onScreenClose});

  final bool isCorrect;
  final Function(BuildContext context) onScreenClose;

  @override
  State<SWDrawResultScreen> createState() => _SWDrawResultScreenState();
}

class _SWDrawResultScreenState extends State<SWDrawResultScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
        const Duration(seconds: 2), () => widget.onScreenClose(context));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor:
            widget.isCorrect ? SWTheme.positiveColor : SWTheme.negativeColor,
        body: Center(
          child: Text(
            widget.isCorrect ? 'Guessed!' : 'Failed!',
            style: const TextStyle(
              fontSize: 50,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
