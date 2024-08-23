import 'dart:math';

class SketchWizardsWordRepository {
  static final List<String> labels = [
    'apple',
    'boomerang',
    'bowl',
    'bus',
    'calculator',
    'camel',
    'computer monitor',
    'donut',
    'ear',
    'envelope',
    'eye',
    'eyeglasses',
    'fire hydrant',
    'foot',
    'giraffe',
    'grapes',
    'hand',
    'harp',
    'head-phones',
    'helicopter',
    'hourglass',
    'ladder',
    'laptop',
    'lightbulb',
    'nose',
    'pear',
    'potted plant',
    'power outlet',
    'present',
    'rainbow',
    'sailboat',
    'snail',
    'snowman',
    'sun',
    't-shirt',
    'table',
    'tomato',
    'trousers',
    'wine-bottle',
    'wineglass'
  ];

  static String? _latestLabel;

  static String getRandomLabel() {
    String newLabel = labels[Random().nextInt(labels.length)];

    if (newLabel == _latestLabel) {
      return getRandomLabel();
    }

    return newLabel;
  }
}
