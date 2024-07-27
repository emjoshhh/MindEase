import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioPlayerScreen extends StatefulWidget {
  final String audioPath;

  AudioPlayerScreen({
    required this.audioPath,
  });

  @override
  _AudioPlayerScreenState createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen>
    with SingleTickerProviderStateMixin {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _audioPlayer.onDurationChanged.listen((d) {
      setState(() {
        _duration = d;
      });
    });
    _audioPlayer.onPositionChanged.listen((p) {
      setState(() {
        _position = p;
      });
    });
    _audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        _isPlaying = false;
        _position = Duration.zero;
        _controller.stop();
      });
    });

    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat();
    _controller.stop();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _playPauseAudio() {
    try {
      if (_isPlaying) {
        _audioPlayer.pause();
        _controller.stop();
      } else {
        _audioPlayer.play(DeviceFileSource(widget.audioPath),
            position: _position);
        _controller.repeat();
      }
      setState(() {
        _isPlaying = !_isPlaying;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  void _stopAudio() {
    _audioPlayer.stop();
    _controller.stop();
    Navigator.pop(context);
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.deepPurple, Colors.black],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RotationTransition(
                turns: _controller,
                child: Image.asset('assets/images/flowers.png', height: 200),
              ),
              SizedBox(height: 20),
              Slider(
                activeColor: Colors.white,
                inactiveColor: Colors.white54,
                min: 0.0,
                max: _duration.inSeconds.toDouble(),
                value: _position.inSeconds.toDouble(),
                onChanged: (value) {
                  setState(() {
                    _audioPlayer.seek(Duration(seconds: value.toInt()));
                  });
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _formatDuration(_position),
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    ' / ',
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    _formatDuration(_duration),
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      _isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                      size: 64,
                    ),
                    onPressed: _playPauseAudio,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.stop,
                      color: Colors.white,
                      size: 64,
                    ),
                    onPressed: _stopAudio,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
