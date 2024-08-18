import 'package:get_it/get_it.dart';
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
