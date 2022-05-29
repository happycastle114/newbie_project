import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class playButton extends HookWidget {
  final bool initState;
  final String onText;
  final String offText;
  // final Function() onPressed;

  const playButton(
      {required this.initState,
      required this.offText,
      required this.onText,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _isRecording = useState<bool>(false);

    return TextButton(
      onPressed: () {
        _isRecording.value = !_isRecording.value;
      },
      child: Text(_isRecording.value ? onText : offText),
    );
  }
}
