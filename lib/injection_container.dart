import 'package:get_it/get_it.dart';
import 'package:music_app/ble_service.dart';
import 'package:music_app/interface/database_repository.dart';
import 'package:music_app/repository/database_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // Dependencies
  sl.registerSingleton<SharedPreferencesAsync>(SharedPreferencesAsync());

  sl.registerSingleton<BLEService>(BLEService(targetDeviceName: "Gloves_BLE_B04"));

  sl.registerSingleton<DatabaseRepository>(DatabaseRepositoryImpl());

  // UseCases
  // sl.registerSingleton<ScanDevicesUseCase>(ScanDevicesUseCase(sl()));

  // Blocs
  // sl.registerFactory<BluetoothBloc>(() => BluetoothBloc(sl(), sl(), sl(), sl(), sl()));
}
