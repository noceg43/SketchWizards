import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sketch_wizards/features/draw/constants.dart';
import 'package:sketch_wizards/features/draw/data/canvas_state.dart';
import 'dart:ui' as ui;

class CanvasController {
  final GlobalKey canvasKey;

  CanvasController({required this.canvasKey});

  ValueNotifier<CanvasState> get state => _state;

  final ValueNotifier<CanvasState> _state =
      ValueNotifier<CanvasState>(EmptyCanvas());

  Future<void> _updateState({required GlobalKey globalKey}) async {
    RenderRepaintBoundary boundary =
        globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

    // Save the image with a fixed size
    double size = globalKey.currentContext!.size!.width;
    double pixelRatio = canvasSize.width / size;
    ui.Image image = await boundary.toImage(pixelRatio: pixelRatio);

    //TODO change the format to rawRgba
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    Uint8List rawBytes = byteData!.buffer.asUint8List();

    _state.value = DrawCanvas(
      imageBytes: rawBytes,
      imageSize: Size(image.width.toDouble(), image.height.toDouble()),
    );
  }

  Stream<CanvasState> asStream(Duration interval, GlobalKey globalKey) async* {
    while (true) {
      await Future.delayed(interval);
      await _updateState(globalKey: globalKey);
      yield _state.value;
    }
  }
}
