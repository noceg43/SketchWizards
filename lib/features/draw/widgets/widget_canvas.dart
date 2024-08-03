import 'package:flutter/material.dart';

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
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 1,
                  ),
                ),
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
              ),
            ), //Clear button
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                icon: const Icon(Icons.clear_outlined),
                onPressed: () {
                  setState(() {
                    points.clear();
                  });
                },
              ),
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
      ..strokeWidth = 5.0;

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
