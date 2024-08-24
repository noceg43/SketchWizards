import 'package:flutter/material.dart';
import 'package:sketch_wizards/features/game/widgets/wizard_widget.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(
          const Duration(seconds: 2), () => widget.onScreenClose(context));
    });
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.isCorrect ? 'Guessed!' : 'Failed!',
                style:  SWTheme.boldTextStyle.copyWith(
                  color: Colors.white,
                  fontSize: 80,
                  letterSpacing: 20,
                ),
              ),
              const SizedBox(height: 30),
              WizardWidget(isGuessed: widget.isCorrect),
            ],
          ),
        ),
      ),
    );
  }
}
