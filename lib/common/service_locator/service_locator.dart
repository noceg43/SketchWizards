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
  await wizard.startPca("");

  //Inserire qua il contenuto del file centroids.json
  await wizard.startClustering("");

  getIt.registerLazySingleton(
    () => wizard,
  );
}
