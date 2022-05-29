import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:kakao_flutter_sdk_auth/kakao_flutter_sdk_auth.dart';

class Login extends StatelessWidget {
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

          Navigator.pushNamed(context, '/calendar',
              arguments: {'userId': user.id.toString()});
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
