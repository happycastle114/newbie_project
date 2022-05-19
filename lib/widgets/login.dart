import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:kakao_flutter_sdk_auth/kakao_flutter_sdk_auth.dart';
import 'package:record/record.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  Future<void> recordVoice() async {
    final record = Record();

    if (await record.hasPermission()) {
      await record.start(
        path: 'aFullPath/myFile.m4a',
        encoder: AudioEncoder.aacLc,
        bitRate: 128000,
        samplingRate: 44100,
      );
    }

    bool isRecording = await record.isRecording();

    await record.stop();
  }

  Future<void> signInWithKakao() async {
    if (await isKakaoTalkInstalled()) {
      try {
        await UserApi.instance.loginWithKakaoTalk();

        print('카카오톡으로 로그인 성공');
      } catch (error) {
        print('카카오톡으로 로그인 실패 $error');

        if (error is PlatformException && error.code == 'CANCELED') {
          return;
        }

        try {
          await UserApi.instance.loginWithKakaoTalk();
        } catch (error) {
          print('카카오톡으로 로그인 실패 $error');
        }
      }
    } else {
      try {
        await UserApi.instance.loginWithKakaoAccount();
      } catch (error) {
        print('카카오계정으로 로그인 실패 $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Login'),
        ),
        body: SafeArea(
          minimum: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: CupertinoButton(
                  onPressed: signInWithKakao,
                  color: Colors.yellow,
                  child: Text('카카오톡 로그인',
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                      )),
                ),
              ),
              TextButton(
                child: Text('Record!'),
                onPressed: recordVoice,
              )
            ],
          ),
        ));
  }
}
