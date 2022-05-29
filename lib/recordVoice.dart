import 'dart:io';
import 'package:newbie_project/utils/UserId.dart';
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
  final DateTime dateTime;
  final ValueNotifier<bool> isSuccessful;
  ScreenArguments({required this.dateTime, required this.isSuccessful});
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
        dateTime: arg['dateTime'] as DateTime,
        isSuccessful: arg['isSuccessful'] as ValueNotifier<bool>);

    final isRecord = useState(false);
    final isPlay = useState(PlayerState.STOPPED);
    final audioPlayer = useState(AudioPlayer());
    final AudioPath = useState('');
    useEffect(() {
      // audioPlayer.value.onPlayerStateChanged.listen((PlayerState s) {
      //   isPlay.value = s;
      //   print('$s');
      // });

      audioPlayer.value.onPlayerCompletion
          .listen((event) => {print("오디오 플레이 완료")});
    }, []);

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
              style: ButtonStyle(),
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
                  await audioPlayer.value.stop();
                  print("오디오 플레이 종료");
                  isPlay.value = PlayerState.STOPPED;
                } else {
                  await audioPlayer.value.play(AudioPath.value);
                  isPlay.value = PlayerState.PLAYING;
                }
              },
            ),
            ElevatedButton(
                onPressed: () async {
                  if (TitleTextController.text == '' || AudioPath.value == '') {
                    Fluttertoast.showToast(msg: "제목과 음성 파일을 입력해주세요.");
                  } else {
                    var uuid = Uuid();
                    print("Plus Button Clicked!");
                    await addDiary(
                        UserId().userId as String,
                        Diary(
                            id: uuid.v1(),
                            date: args.dateTime,
                            name: TitleTextController.text,
                            fileName: await UploadFile(
                                File(AudioPath.value.split("file://")[1]))));
                    Fluttertoast.showToast(msg: "성공적으로 추가하였습니다.");
                    args.isSuccessful.value = true;

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
