import 'package:flutter/material.dart';
import 'package:sketch_wizards/common/service_locator/service_locator.dart';
import 'package:sketch_wizards/draw_test_app.dart';

//TODO localization
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();

  runApp(const DrawTestApp());
}
