import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:music_app/ble_service.dart';
import 'package:music_app/injection_container.dart';

class LocalAudioPlayerContainer extends StatefulWidget {
  final String audioAssetPath; // Path to local MP3 file
  final Map<String, String> metadataMap; // Path to JSON metadata file

  const LocalAudioPlayerContainer({
    super.key,
    required this.audioAssetPath,
    required this.metadataMap,
  });

  @override
  LocalAudioPlayerContainerState createState() => LocalAudioPlayerContainerState();
}

class LocalAudioPlayerContainerState extends State<LocalAudioPlayerContainer> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();

    // Listen for audio duration
    _audioPlayer.onDurationChanged.listen((duration) {
      setState(() => _duration = duration);
    });

    // Listen for position updates
    _audioPlayer.onPositionChanged.listen((position) {
      setState(() => _position = position);
      _checkAndSendMetadata(position);
    });

    // Reset state when song ends
    _audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        _position = Duration.zero;
        isPlaying = false;
      });
    });
  }

  /// Check & send BLE data at the correct timestamp
  void _checkAndSendMetadata(Duration currentPosition) {
    String currentTime = (currentPosition.inMilliseconds / 1000).toStringAsFixed(1);
    if (widget.metadataMap.containsKey(currentTime)) {
      // print(widget.metadataMap[currentTime]);
      sl<BLEService>().writeData(widget.metadataMap[currentTime]!);
      // _sendBLEData(_metadataMap[currentTime]!);
    }
  }

  /// Send BLE data
  // void _sendBLEData(String data) async {
  //   if (widget.bleCharacteristic != null) {
  //     List<int> bytes = data.codeUnits; // Convert string to bytes
  //     await widget.bleCharacteristic!.write(bytes);
  //     print("🔵 Sent BLE Data: $data");
  //   } else {
  //     print("❌ No BLE device connected!");
  //   }
  // }

  /// Toggle Play/Pause functionality
  void _togglePlayPause() async {
    if (isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play(AssetSource(widget.audioAssetPath));
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  /// Seek to a specific time in the audio
  void _seekAudio(double value) async {
    await _audioPlayer.seek(Duration(seconds: value.toInt()));
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  /// Format Duration into mm:ss
  String _formatDuration(Duration duration) {
    return "${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Song Progress
          Slider(
            min: 0,
            max: _duration.inSeconds.toDouble(),
            value: _position.inSeconds.toDouble(),
            onChanged: _seekAudio,
          ),

          // Time Display
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_formatDuration(_position)),
              Text(_formatDuration(_duration)),
            ],
          ),

          // Play/Pause Button
          IconButton(
            icon: Icon(isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled),
            iconSize: 50,
            color: Colors.blueAccent,
            onPressed: _togglePlayPause,
          ),
        ],
      ),
    );
  }
}
