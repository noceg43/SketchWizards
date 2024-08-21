import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:ml_dart_wizard/models/guess_result.dart';
import 'package:ml_dart_wizard/wizard.dart';
import 'package:sketch_wizards/features/draw/constants.dart';
import 'package:sketch_wizards/features/draw/data/canvas_state.dart';
import 'package:sketch_wizards/features/draw/logic/canvas_controller.dart';

class SWWizardGuessProvider {
  final GlobalKey canvasKey;
  final VoidCallback onGuessed;

  SWWizardGuessProvider({required this.canvasKey, required this.onGuessed});

  late CanvasController controller = CanvasController(canvasKey: canvasKey);

  late Stream<CanvasState> asStream = controller.asStream(
    canvasKey,
  );

  ValueNotifier<GuessState> guessResult =
      ValueNotifier<GuessState>(EmptyGuessResult());

  Future<void> startGuessing(String label) async {
    Wizard wizard = GetIt.instance.get<Wizard>();
    bool isGuessed = false;

    await for (var event in asStream) {
      if (event is DrawCanvas) {
        var result = await wizard.guess(event.imageBytes, label);
        guessResult.value = result;

        print("Guess result: $result");

        if (result is GuessResult &&
            result.confidence <= confidenceThreshold &&
            !isGuessed) {
          isGuessed = true;
          onGuessed();
        }
      }
    }
  }
}
