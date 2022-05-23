import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
              label: '삭제',
              backgroundColor: Colors.red,
              icon: Icons.delete,
              onPressed: (context) => onDelete(diary.id),
            )
          ],
        ),
        child: Builder(
          builder: (context) => ListTile(
            onTap: () {},
            title: Text(diary.name),
            trailing:
                const playButton(initState: false, offText: '듣기', onText: '중단'),
          ),
        ));
  }
}
