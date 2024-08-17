import 'package:flutter/material.dart';
import 'package:sketch_wizards/common/service_locator/service_locator.dart';
import 'package:sketch_wizards/sketch_wizards_app.dart';

//TODO localization
void main() {
  setupLocator();

  runApp(const SketchWizardsApp());
}
