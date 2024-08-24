import 'package:flutter/material.dart';

class WizardWidget extends StatelessWidget {
  const WizardWidget({super.key, required this.isGuessed});

  final bool? isGuessed;

  @override
  Widget build(BuildContext context) {
    String wizard = "assets/images/wizard_guessing.png";

    if (isGuessed == true) {
      wizard = "assets/images/wizard_guessed.png";
    } else if (isGuessed == false) {
      wizard = "assets/images/wizard_not_guessed.png";
    }

    return Image(
      height: 500,
      image: AssetImage(wizard),
    );
  }
}
