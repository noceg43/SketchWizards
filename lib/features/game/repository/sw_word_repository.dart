import 'dart:math';

class SketchWizardsWordRepository {
  static final List<String> labels = [
    'apple',
    'boomerang',
    'bowl',
    'bus',
    'camel',
    'computer monitor',
    'ear',
    'eyeglasses',
    'fire hydrant',
    'foot',
    'giraffe',
    'hand',
    'harp',
    'head-phones',
    'helicopter',
    'hourglass',
    'ladder',
    'laptop',
    'lightbulb',
    'pear',
    'potted plant',
    'present',
    'sailboat',
    'snail',
    'snowman',
    't-shirt',
    'tomato',
    'trousers',
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
