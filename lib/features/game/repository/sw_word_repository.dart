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

  static final List<String> _usedLabels = [];
  static const int _maxUsedLabels = 8;

  static String getRandomLabel() {
    // Shuffle the labels list to increase randomness
    labels.shuffle();

    String newLabel;

    do {
      newLabel = labels[Random().nextInt(labels.length)];
    } while (_usedLabels.contains(newLabel));

    _usedLabels.add(newLabel);
    if (_usedLabels.length > _maxUsedLabels) {
      _usedLabels.removeAt(0);
    }

    return newLabel;
  }
}
