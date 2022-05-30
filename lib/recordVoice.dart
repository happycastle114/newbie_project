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
  RecordVoice({required this.dateTime, required this.isSuccessful, Key? key})
      : super(key: key);
  final DateTime dateTime;
  final ValueNotifier<bool> isSuccessful;

  final TitleTextController = TextEditingController();

  final record = Record();

  @override
  Widget build(BuildContext context) {
    // final arg =
    //    ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final args = ScreenArguments(
        dateTime: dateTime, // arg['dateTime'] as DateTime,
        isSuccessful:
            isSuccessful // arg['isSuccessful'] as ValueNotifier<bool>);
        );

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

    return Container(
        width: MediaQuery.of(context).size.width,
        height: 400,
        decoration: BoxDecoration(color: Colors.black.withOpacity(0.55)),
        child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30))),
            child: Padding(
                padding: EdgeInsets.all(20),
                child: SafeArea(
                  child: Column(
                    children: [
                      TextField(
                        controller: TitleTextController,
                        decoration: const InputDecoration(
                          labelText: '일기 제목',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          "선택한 날짜 : ${dateTime.toString().split(" ").first}",
                          style: TextStyle(
                              fontFamily: 'NanumSquare', fontSize: 15),
                        ),
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          "목소리 녹음하기",
                          style: TextStyle(
                              fontFamily: 'NanumSquare', fontSize: 15),
                        ),
                      ),
                      ElevatedButton(
                        style: ButtonStyle(),
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Text(
                                textAlign: TextAlign.center,
                                isRecord.value ? '정지' : '녹음')),
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
                      SizedBox(height: 20),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          "녹음한 목소리 들어보기",
                          style: TextStyle(
                              fontFamily: 'NanumSquare', fontSize: 15),
                        ),
                      ),
                      ElevatedButton(
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Text(
                                textAlign: TextAlign.center,
                                isPlay.value == PlayerState.PLAYING
                                    ? 'Stop'
                                    : 'Play')),
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
                            if (TitleTextController.text == '' ||
                                AudioPath.value == '') {
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
                                      fileName: await UploadFile(File(AudioPath
                                          .value
                                          .split("file://")[1]))));
                              Fluttertoast.showToast(msg: "성공적으로 추가하였습니다.");
                              args.isSuccessful.value = true;

                              Navigator.pop(context);
                            }
                          },
                          child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Text(textAlign: TextAlign.center, "저장하기")))
                    ],
                  ),
                ))));
  }
}
