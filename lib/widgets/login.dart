import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:kakao_flutter_sdk_auth/kakao_flutter_sdk_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:newbie_project/utils/UserId.dart';

class Login extends HookWidget {
  const Login({Key? key}) : super(key: key);

  Future<void> signInWithKakao(BuildContext context) async {
    print("Button Clicked!");

    if (await isKakaoTalkInstalled()) {
      try {
        await UserApi.instance.loginWithKakaoTalk();
        print("Login Success");
        Fluttertoast.showToast(msg: '카카오톡으로 로그인 성공');
      } catch (error) {
        print('카카오톡으로 로그인 실패 $error');

        if (error is PlatformException && error.code == 'CANCELED') {
          return;
        }

        try {
          await UserApi.instance.loginWithKakaoTalk();
          Fluttertoast.showToast(msg: '카카오톡으로 로그인 성공');
        } catch (error) {
          print('카카오톡으로 로그인 실패 $error');
        }
      }
    } else {
      try {
        await UserApi.instance.loginWithKakaoAccount();
        Fluttertoast.showToast(msg: '카카오톡으로 로그인 성공');
        try {
          User user = await UserApi.instance.me();
          print('사용자 정보 요청 성공'
              '\n회원번호: ${user.id}'
              '\n닉네임: ${user.kakaoAccount?.profile?.nickname}'
              '\n이메일: ${user.kakaoAccount?.email}');
          await UserId().set(user.id.toString());
          Navigator.pushNamed(context, '/routerPage');
        } catch (error) {
          print('사용자 정보 요청 실패 $error');
        }
      } catch (error) {
        print('카카오계정으로 로그인 실패 $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = useState(false);

    UserId().get().then((value) {
      if (value) {
        Navigator.pushNamed(context, '/routerPage', arguments: {});
      } else {
        isLoading.value = true;
      }
    });

    return !isLoading.value
        ? Container()
        : Scaffold(
            body: SafeArea(
            minimum: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.width * 0.3),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: const Text("음성 일기",
                          style: TextStyle(
                              fontFamily: 'NanumSquare',
                              fontSize: 55,
                              fontWeight: FontWeight.w700)),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      "글이 아닌 목소리로 기록하는 일기장",
                      style: TextStyle(fontSize: 20, fontFamily: 'NanumSquare'),
                    ),
                  ],
                )),
                const Text(
                  "서비스를 이용하시려면 아래 버튼을 눌러 로그인 해주세요.",
                  style: TextStyle(fontSize: 15, fontFamily: 'NanumSquare'),
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: CupertinoButton(
                    onPressed: () => signInWithKakao(context),
                    color: Colors.yellow,
                    child: const Text('카카오톡 로그인',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black87,
                        )),
                  ),
                ),
              ],
            ),
          ));
  }
}
