import 'package:flutter/material.dart';
import 'package:sketch_wizards/features/draw/constants.dart';
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

                        // Image display
                        StreamBuilder(
                          stream: controller.asStream(
                            interval,
                            canvasKey,
                          ),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final CanvasState state =
                                  snapshot.data as CanvasState;
                              if (state is DrawCanvas) {
                                return _ImageFromDrawCanvas(canvasState: state);
                              }
                            }
                            return SizedBox(
                              height: canvasSize.height,
                              width: canvasSize.width,
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          },
                        )
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
