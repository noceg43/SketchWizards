import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:ml_dart_wizard/wizard.dart';
import 'package:sketch_wizards/features/game/logic/sw_game_service_provider.dart';
import 'package:sketch_wizards/features/start_game/logic/sw_game_settings_provider.dart';

final GetIt getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton(
    () => SWGameSettingsProvider(),
  );
  getIt.registerLazySingleton(
    () => SWGameServiceProvider(),
  );
}

Future<void> setupWizard() async {
  Wizard wizard = Wizard();

  String pcaContent = await rootBundle.loadString('assets/PCA.csv');
  await wizard.startPca(pcaContent);

  String points = await rootBundle.loadString('assets/points.json');
  await wizard.startPointFinder(points);

  String imagecontent = await rootBundle.loadString('assets/image.csv');
  wizard.test(imagecontent);

  getIt.registerLazySingleton(
    () => wizard,
  );
}
