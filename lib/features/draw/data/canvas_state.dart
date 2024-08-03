import 'dart:typed_data';
import 'dart:ui';

sealed class CanvasState {}

class EmptyCanvas extends CanvasState {
  EmptyCanvas();

  @override
  String toString() => 'EmptyCanvas()';

  @override
  bool operator ==(covariant CanvasState other) {
    if (identical(this, other)) return true;

    if (other is EmptyCanvas) {
      return true;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => 0;
}

class DrawCanvas extends CanvasState {
  final Uint8List imageBytes;
  final Size imageSize;
  DrawCanvas({
    required this.imageBytes,
    required this.imageSize,
  });

  DrawCanvas copyWith({
    Uint8List? imageBytes,
    Size? imageSize,
  }) {
    return DrawCanvas(
      imageBytes: imageBytes ?? this.imageBytes,
      imageSize: imageSize ?? this.imageSize,
    );
  }

  @override
  String toString() =>
      'DrawCanvas(imageBytes: $imageBytes, imageSize: $imageSize)';

  @override
  bool operator ==(covariant CanvasState other) {
    if (identical(this, other)) return true;

    if (other is DrawCanvas) {
      return other.imageBytes == imageBytes && other.imageSize == imageSize;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => imageBytes.hashCode ^ imageSize.hashCode;
}
