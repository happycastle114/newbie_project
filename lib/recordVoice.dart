import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:record/record.dart';

class RecordVoice extends HookWidget {
  RecordVoice({Key? key}) : super(key: key);

  final TitleTextController = TextEditingController();

  final record = Record();

  @override
  Widget build(BuildContext context) {
    final isRecord = useState(false);
    final isPlay = useState(PlayerState.STOPPED);
    final AudioPlayer audioPlayer = AudioPlayer();
    final AudioPath = useState('');

    audioPlayer.onPlayerStateChanged
        .listen((PlayerState s) => {isPlay.value = s, print('$s')});

    audioPlayer.onPlayerCompletion.listen((event) => {print("오디오 플레이 완료")});

    return Scaffold(
      appBar: AppBar(
        title: Text('Record Voice'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            TextField(
              controller: TitleTextController,
              decoration: const InputDecoration(
                labelText: 'Title',
              ),
            ),
            ElevatedButton(
              child: Text(isRecord.value ? 'Stop' : 'Record'),
              onPressed: () async {
                if (await record.isRecording()) {
                  String? path = await record.stop();

                  if (path != null) {
                    AudioPath.value = path;
                    print('저장된 파일 경로: $path');
                  }
                  print("Recording Stopped!");
                  isRecord.value = false;
                } else {
                  if (await record.hasPermission()) {
                    isRecord.value = true;
                    await record.start(
                      encoder: AudioEncoder.aacLc,
                      bitRate: 128000,
                      samplingRate: 44100,
                    );
                  }
                }
              },
            ),
            ElevatedButton(
              child:
                  Text(isPlay.value == PlayerState.PLAYING ? 'Stop' : 'Play'),
              onPressed: () async {
                late int result;
                if (isPlay.value == PlayerState.PLAYING) {
                  result = await audioPlayer.stop();
                  print("오디오 플레이 종료");
                  print(result);
                  print('$isPlay.value');
                } else {
                  await audioPlayer.play(AudioPath.value);
                }
              },
            ),
            ElevatedButton(
                onPressed: () async {
                  await audioPlayer.stop();
                },
                child: const Text("중단"))
          ],
        ),
      ),
    );
  }
}
