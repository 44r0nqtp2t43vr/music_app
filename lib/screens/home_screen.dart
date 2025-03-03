import 'package:flutter/material.dart';
import 'package:music_app/ble_service.dart';
import 'package:music_app/injection_container.dart';
import 'package:music_app/interface/database_repository.dart';
import 'package:music_app/widgets/audio_player_container.dart';
import 'package:music_app/widgets/station.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _serverIPController = TextEditingController();

  @override
  void initState() {
    _serverIPController.text = sl<BLEService>().getServerIP();
    super.initState();
  }

  void _toggleConnection() async {
    final bleService = sl<BLEService>();
    if (bleService.connectedDevice != null) {
      await bleService.disconnect();
      setState(() {});
    } else {
      await bleService.scanAndConnect();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final isConnected = sl<BLEService>().connectedDevice != null;
    final serverIP = sl<BLEService>().getServerIP();
    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 80.0),
              child: Station(data: "data"),
            ),
            AudioPlayerContainer(
              audioUrl: "http://$serverIP:8000/api/stream/forestofblocks.mp3",
            ),
            TextFormField(
              controller: _serverIPController,
              textAlign: TextAlign.center,
            ),
            ElevatedButton(
              onPressed: () {
                sl<BLEService>().setServerIP(_serverIPController.text);
              },
              child: Text("Set server IP"),
            ),
            ElevatedButton(
              onPressed: () async {
                await sl<DatabaseRepository>().getPatternString();
              },
              child: Text("Get pattern string"),
            ),
            ElevatedButton(
              onPressed: _toggleConnection,
              child: Text(isConnected ? "Disconnect" : "Connect to Bluetooth"),
            )
          ],
        ),
      ),
    );
  }
}
