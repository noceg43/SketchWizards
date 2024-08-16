import 'package:flutter/material.dart';
import 'package:sketch_wizards/common/widgets/player_widget.dart';
import 'package:sketch_wizards/common/widgets/sw_icon_button.dart';
import 'package:sketch_wizards/common/widgets/sw_scaffold.dart';
import 'package:sketch_wizards/common/widgets/sw_text_button.dart';
import 'package:sketch_wizards/common/widgets/sw_text_field.dart';

class SWHome extends StatefulWidget {
  const SWHome({super.key});

  @override
  State<SWHome> createState() => _SWHomeState();
}

class _SWHomeState extends State<SWHome> {
  //TODO logic for home screen
  final TextEditingController controller = TextEditingController();

  void onAddPressed() {
    print('Add pressed');
  }

  void onStartGamePressed() {
    print('Start Game pressed');
  }

  @override
  Widget build(BuildContext context) {
    return SWScaffold(
      title: 'Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet',
      bottomWidget: Center(
        child: SWTextButton(
          text: 'Start Game',
          onPressed: onStartGamePressed,
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: SizedBox(
            width: 800,
            child: Row(
              children: [
                Expanded(
                  child: SWTextField(
                    controller: controller,
                    hintText: 'Enter here the player name',
                  ),
                ),
                const SizedBox(width: 20),
                SWIconButton(icon: Icons.add, onPressed: onAddPressed),
              ],
            ),
          ),
        ),
        /*
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: FittedBox(
            child: Text(
              "Sketch Wizards",
              style: TextStyle(
                fontSize: 1000,
                color: SWTheme.primaryColor,
              ),
            ),
          ),
        ),
        */
        const SizedBox(height: 50),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 100,
          children: List.generate(
            8,
            (index) => Padding(
              padding: const EdgeInsets.all(10),
              child: PlayerWidget(
                text:
                    [for (int i = 0; i < index; i++) 'Player $index'].join(' '),
                onDelete: () => print('Delete pressed'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
