import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:ml_dart_wizard/wizard.dart';
import 'package:sketch_wizards/features/game/logic/sw_game_service_provider.dart';
import 'package:sketch_wizards/features/start_game/logic/sw_game_settings_provider.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupLocator() async {
  getIt.registerLazySingleton(
    () => SWGameSettingsProvider(),
  );
  getIt.registerLazySingleton(
    () => SWGameServiceProvider(),
  );

  Wizard wizard = Wizard();

  //Inserire qua il contenuto del file PCA.csv
  // read pca file
  String pcaContent = await rootBundle.loadString('assets/PCA100.csv');
  await wizard.startPca(pcaContent);

  String centroidsContent = await rootBundle.loadString('assets/centroids100.json');
  await wizard.startClustering(centroidsContent);

  getIt.registerLazySingleton(
    () => wizard,
  );
}
