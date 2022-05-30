import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class playButton extends HookWidget {
  final bool initState;
  final String onText;
  final String offText;
  // final Function() onPressed;
  final String fileUrl;

  const playButton(
      {required this.initState,
      required this.offText,
      required this.onText,
      required this.fileUrl,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _isRecording = useState<bool>(false);
    final audioPlayer = useState(AudioPlayer());

    useEffect(() {
      print("EFFECT 실행");
      audioPlayer.value.onPlayerCompletion.listen((event) {
        print("오디오 플레이 완료");
        _isRecording.value = false;
      });
    }, []);

    return TextButton(
      onPressed: () async {
        if (_isRecording.value) {
          await audioPlayer.value.stop();
        } else {
          await audioPlayer.value.play(fileUrl);
        }
        _isRecording.value = !_isRecording.value;
      },
      child: Text(_isRecording.value ? onText : offText),
    );
  }
}
