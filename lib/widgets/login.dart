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
      }

      // TODO : 중간에 화면 사사삭 넘어가는 이유 알아내기
      isLoading.value = true;
    });

    return !isLoading.value
        ? Container()
        : Scaffold(
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
                      onPressed: () => signInWithKakao(context),
                      color: Colors.yellow,
                      child: Text('카카오톡 로그인',
                          style: const TextStyle(
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
