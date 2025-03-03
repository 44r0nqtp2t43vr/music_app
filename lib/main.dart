import 'package:flutter/material.dart';
import 'package:music_app/ble_service.dart';
import 'package:music_app/injection_container.dart';
import 'package:music_app/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDependencies();
  await sl<BLEService>().loadInitialValues();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
