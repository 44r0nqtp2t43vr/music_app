import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:music_app/injection_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BLEService extends GetxController {
  final String targetDeviceName;
  final String characteristicUuid = "ffe2"; // Target characteristic UUID (partial match)
  String lastSentString = "";
  RxString serverIP = "".obs;

  BluetoothDevice? connectedDevice;
  BluetoothCharacteristic? _targetCharacteristic;

  final asyncPrefs = sl<SharedPreferencesAsync>();

  BLEService({required this.targetDeviceName});

  Future<void> loadInitialValues() async {
    final savedServerIP = await asyncPrefs.getString('serverIP');

    if (savedServerIP != null) {
      serverIP.value = savedServerIP;
    }
  }

  String getServerIP() {
    return serverIP.value;
  }

  Future<void> setServerIP(String newServerIP) async {
    serverIP.value = newServerIP;
    await asyncPrefs.setString('serverIP', newServerIP);
  }

  /// Scans for BLE devices and connects to the target device.
  Future<void> scanAndConnect() async {
    debugPrint("🔍 Scanning for BLE devices...");

    FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));

    await for (List<ScanResult> results in FlutterBluePlus.scanResults) {
      for (ScanResult scanResult in results) {
        if (scanResult.device.platformName == targetDeviceName) {
          debugPrint("✅ Found device: ${scanResult.device.platformName}");
          FlutterBluePlus.stopScan();

          connectedDevice = scanResult.device;
          await _connectToDevice();
          return;
        }
      }
    }

    debugPrint("❌ Device '$targetDeviceName' not found.");
  }

  /// Connects to the BLE device and discovers services.
  Future<void> _connectToDevice() async {
    if (connectedDevice == null) {
      debugPrint("❌ No device to connect.");
      return;
    }

    debugPrint("🔗 Connecting to ${connectedDevice!.platformName}...");
    await connectedDevice!.connect();
    debugPrint("✅ Connected to ${connectedDevice!.platformName}");

    await _discoverServices();
  }

  /// Discovers services and finds the target characteristic.
  Future<void> _discoverServices() async {
    if (connectedDevice == null) return;

    List<BluetoothService> services = await connectedDevice!.discoverServices();

    for (BluetoothService service in services) {
      for (BluetoothCharacteristic characteristic in service.characteristics) {
        debugPrint("🔍 Found characteristic: ${characteristic.uuid}");

        if (characteristic.uuid.toString().toLowerCase().contains(characteristicUuid)) {
          _targetCharacteristic = characteristic;
          debugPrint("✅ Found target characteristic: ${characteristic.uuid}");
          return;
        }
      }
    }

    debugPrint("❌ Target characteristic '$characteristicUuid' not found.");
  }

  /// Writes data to the target characteristic.
  Future<void> writeData(String data) async {
    if (_targetCharacteristic == null) {
      debugPrint("❌ Cannot write: Characteristic not found.");
      return;
    }

    List<int> bytes = data.codeUnits;
    lastSentString = data;
    await _targetCharacteristic!.write(bytes);
    debugPrint("✉️ Data sent: $data");
  }

  /// Disconnects from the BLE device.
  Future<void> disconnect() async {
    if (connectedDevice != null) {
      await connectedDevice!.disconnect();
      debugPrint("🔌 Disconnected from ${connectedDevice!.platformName}");
      connectedDevice = null;
      _targetCharacteristic = null;
    }
  }
}
