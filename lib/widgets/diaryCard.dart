import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../models/diary.dart';
import 'package:flutter/material.dart';

class diaryCard extends StatelessWidget {
  final Diary diary;
  final Function onDelete;

  const diaryCard({required this.diary, required this.onDelete, Key? key})
      : super(key: key);

  void openSlidable(BuildContext context) {
    final slidable = Slidable.of(context);
    final isClosed = slidable.renderingMode == SlidableRenderingMode.none;

    if (isClosed) {
      Future.delayed(Duration.zero, () {
        if (slidable.mounted) {
          slidable.open(actionType: SlideActionType.secondary);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
        actionPane: const SlidableDrawerActionPane(),
        secondaryActions: [
          IconSlideAction(
            caption: '삭제',
            color: Colors.red,
            icon: Icons.delete,
            onTap: () => onDelete(diary.id),
          ),
        ],
        child: Builder(
            builder: (context) => GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onLongPress: () {
                    openSlidable(context);
                  },
                  child: ListTile(
                    onTap: () {},
                    title: Text(diary.name),
                  ),
                )));
  }
}
