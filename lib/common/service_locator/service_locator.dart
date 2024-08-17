import 'package:get_it/get_it.dart';
import 'package:sketch_wizards/features/start_game/logic/sw_game_service.dart';

final GetIt getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton(
    () => SWGameService(),
  );
}
