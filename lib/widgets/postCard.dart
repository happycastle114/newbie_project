import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:newbie_project/models/post.dart';
import 'package:newbie_project/widgets/playButton.dart';
import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {
  final Post post;
  final Function onDelete;

  const PostCard({required this.post, required this.onDelete, Key? key})
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
              onPressed: (context) => onDelete(post.id),
            )
          ],
        ),
        child: Builder(
          builder: (context) => ListTile(
            onTap: () {},
            title: Text(post.name),
            trailing: playButton(
              initState: false,
              offText: '듣기',
              onText: '중단',
              fileUrl: post.fileName,
            ),
          ),
        ));
  }
}
