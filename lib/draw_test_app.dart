import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:ml_dart_wizard/models/guess_result.dart';
import 'package:ml_dart_wizard/wizard.dart';
import 'package:sketch_wizards/features/draw/data/canvas_state.dart';
import 'package:sketch_wizards/features/draw/logic/canvas_controller.dart';
import 'package:sketch_wizards/features/draw/widgets/widget_canvas.dart';

class DrawTestApp extends StatefulWidget {
  const DrawTestApp({super.key});

  @override
  State<DrawTestApp> createState() => _DrawTestAppState();
}

class _DrawTestAppState extends State<DrawTestApp> {
  GlobalKey canvasKey = GlobalKey();

  late CanvasController controller = CanvasController(canvasKey: canvasKey);

  Duration interval = const Duration(seconds: 1);

  late Stream<CanvasState> asStream = controller.asStream(
    canvasKey,
  );

  ValueNotifier<GuessState> guessResult =
      ValueNotifier<GuessState>(EmptyGuessResult());

  @override
  void initState() {
    super.initState();
    Wizard wizard = GetIt.instance.get<Wizard>();
    asStream.listen((event) async {
      if (event is DrawCanvas) {
        var result = await wizard.guess(event.imageBytes, "apple");
        guessResult.value = result;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Column(
          children: [
            Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // App's Size
                        Text(
                            "Window size: ${MediaQuery.of(context).size.width} x ${MediaQuery.of(context).size.height}"),
                        const SizedBox(height: 20),

                        // Interval control
                        _IntervalSlider(
                          interval: interval,
                          onIntervalChanged: (Duration value) {
                            setState(() {
                              interval = value;
                            });
                          },
                        ),
                        const SizedBox(height: 20),

                        // Guess result
                        ValueListenableBuilder<GuessState>(
                          valueListenable: guessResult,
                          builder: (context, value, child) {
                            String guess = (value is EmptyGuessResult)
                                ? "Empty"
                                : value is GuessResult
                                    ? value.topGuess()
                                    : "Loading...";

                            return Column(
                              children: [
                                const Text("Guess:"),
                                Text(guess),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  // Drawing canvas
                  WidgetCanvas(
                    canvasKey: canvasKey,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IntervalSlider extends StatelessWidget {
  const _IntervalSlider(
      {required this.interval, required this.onIntervalChanged});
  final Duration interval;
  final Function(Duration) onIntervalChanged;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Interval: ${interval.inSeconds} seconds"),
        Slider(
          value: interval.inSeconds.toDouble(),
          min: 1,
          max: 10,
          divisions: 9,
          label: interval.inSeconds.toString(),
          onChanged: (double value) {
            onIntervalChanged(Duration(seconds: value.toInt()));
          },
        ),
      ],
    );
  }
}

class _ImageFromDrawCanvas extends StatelessWidget {
  const _ImageFromDrawCanvas({required this.canvasState});
  final DrawCanvas canvasState;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
            "Image size: ${canvasState.imageSize.width} x ${canvasState.imageSize.height}"),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
              width: 1,
            ),
          ),
          child: Image.memory(canvasState.imageBytes),
        ),
      ],
    );
  }
}
