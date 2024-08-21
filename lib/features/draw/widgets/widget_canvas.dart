import 'package:flutter/material.dart';
import 'package:sketch_wizards/common/widgets/sw_icon_button.dart';
import 'package:sketch_wizards/features/draw/constants.dart';

class WidgetCanvas extends StatefulWidget {
  const WidgetCanvas({super.key, required this.canvasKey});
  final GlobalKey canvasKey;

  @override
  State<WidgetCanvas> createState() => _WidgetCanvasState();
}

class _WidgetCanvasState extends State<WidgetCanvas> {
  Size? imageSize;
  List<Offset> points = [];
  bool isDragging = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        imageSize = constraints.biggest;
        return Stack(
          children: [
            Positioned.fill(
                child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 5,
                  ),
                ],
              ),
            )),
            GestureDetector(
              onTapDown: (details) {
                if (!isDragging) {
                  setState(
                    () {
                      RenderBox renderBox =
                          context.findRenderObject() as RenderBox;
                      points
                          .add(renderBox.globalToLocal(details.globalPosition));
                      points.add(
                          Offset.zero); // Add a zero offset to separate dots
                    },
                  );
                }
              },
              onPanStart: (details) {
                setState(() {
                  isDragging = true;
                  RenderBox renderBox = context.findRenderObject() as RenderBox;
                  points.add(renderBox.globalToLocal(details.globalPosition));
                });
              },
              onPanUpdate: (details) {
                setState(() {
                  RenderBox renderBox = context.findRenderObject() as RenderBox;
                  points.add(renderBox.globalToLocal(details.globalPosition));
                });
              },
              onPanEnd: (details) {
                setState(() {
                  isDragging = false;
                  points
                      .add(Offset.zero); // Add a zero offset to separate lines
                });
              },
              child: RepaintBoundary(
                key: widget.canvasKey,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: ClipRect(
                    child: CustomPaint(
                      painter: _CanvasPainter(points),
                    ),
                  ),
                ),
              ),
            ), //Clear button
            Positioned(
              top: 10,
              right: 10,
              child: SWIconButton(
                smallIcon: true,
                  icon: Icons.clear,
                  onPressed: () {
                    setState(() {
                      points.clear();
                    });
                  }),
            ),
          ],
        );
      },
    );
  }
}

class _CanvasPainter extends CustomPainter {
  final List<Offset> points;

  _CanvasPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = brushSize;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != Offset.zero && points[i + 1] != Offset.zero) {
        canvas.drawLine(points[i], points[i + 1], paint);
      } else if (points[i] != Offset.zero && points[i + 1] == Offset.zero) {
        canvas.drawCircle(points[i], 2.5, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
