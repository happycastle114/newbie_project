import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:newbie_project/models/post.dart';

class Board extends HookWidget {
  Board({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _postList = useState<List<Post>>([]);

    return SafeArea(child: Scaffold(
      appBar: ,
      body: ,
    ));
  }
}
