import 'dart:io';
import 'package:uuid/uuid.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:newbie_project/models/diary.dart';
import 'package:newbie_project/utils/getDiary.dart';
import 'package:newbie_project/utils/storage.dart';
import 'package:record/record.dart';

class ScreenArguments {
  final String userId;
  final DateTime dateTime;

  ScreenArguments({required this.userId, required this.dateTime});
}

class RecordVoice extends HookWidget {
  RecordVoice({Key? key}) : super(key: key);

  final TitleTextController = TextEditingController();

  final record = Record();

  @override
  Widget build(BuildContext context) {
    final arg =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final args = ScreenArguments(
        userId: arg['userId'] as String, dateTime: arg['dateTime'] as DateTime);

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
                border: OutlineInputBorder(),
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
                  result = await audioPlayer.release();
                  print("오디오 플레이 종료");
                  print(result);
                  print('$isPlay.value');
                } else {
                  await audioPlayer.play(AudioPath.value);
                }
              },
            ),
            // TODO : 음성 파일 정지 오류 해결
            ElevatedButton(
                onPressed: () async {
                  await audioPlayer.release();
                },
                child: const Text("중단")),
            ElevatedButton(
                onPressed: () async {
                  if (TitleTextController.text == '' || AudioPath.value == '') {
                    Fluttertoast.showToast(msg: "제목과 음성 파일을 입력해주세요.");
                  } else {
                    var uuid = Uuid();
                    print("Plus Button Clicked!");
                    await addDiary(
                        args.userId,
                        Diary(
                            id: uuid.v1(),
                            date: args.dateTime,
                            name: TitleTextController.text,
                            fileName: await UploadFile(
                                File(AudioPath.value.split("file://")[1]))));
                    Fluttertoast.showToast(msg: "성공적으로 추가하였습니다.");

                    Navigator.pop(context);
                  }
                },
                child: const Text("추가하기"))
          ],
        ),
      ),
    );
  }
}
