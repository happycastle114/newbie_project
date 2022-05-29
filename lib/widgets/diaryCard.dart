import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:newbie_project/models/post.dart';
import 'package:newbie_project/utils/UserId.dart';
import 'package:newbie_project/utils/getPost.dart';
import 'package:newbie_project/widgets/playButton.dart';
import '../models/diary.dart';
import 'package:flutter/material.dart';

class diaryCard extends StatelessWidget {
  final Diary diary;
  final Function onDelete;

  const diaryCard({required this.diary, required this.onDelete, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Slidable(
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          children: [
            SlidableAction(
              autoClose: true,
              label: '게시물 등록',
              backgroundColor: Colors.blue,
              icon: Icons.upload,
              onPressed: (context) => PostDatabase()
                  .add(Post.fromDiary(UserId().userId as String, diary))
                  .then((value) {
                if (!value) {
                  Fluttertoast.showToast(msg: "이미 등록된 게시물입니다!");
                } else {
                  Fluttertoast.showToast(msg: "성공적으로 등록되었습니다!");
                }
              }),
            ),
            SlidableAction(
              autoClose: true,
              label: '삭제',
              backgroundColor: Colors.red,
              icon: Icons.delete,
              onPressed: (context) => onDelete(diary),
            ),
          ],
        ),
        child: Builder(
          builder: (context) => ListTile(
            onTap: () {},
            title: Text(diary.name),
            trailing: playButton(
              initState: false,
              offText: '듣기',
              onText: '중단',
              fileUrl: diary.fileName,
            ),
          ),
        ));
  }
}
