import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:newbie_project/models/post.dart';
import 'package:newbie_project/utils/UserId.dart';
import 'package:newbie_project/widgets/playButton.dart';
import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {
  final Post post;
  final Function onDelete;

  const PostCard({required this.post, required this.onDelete, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.all(10),
                  ),
                  Text(
                    post.name,
                    textAlign: TextAlign.center,
                  ),
                  (UserId().userId == post.writer
                      ? IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.delete, color: Colors.red))
                      : Padding(
                          padding: EdgeInsets.all(10),
                        ))
                ],
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("익명"),
                  Padding(padding: EdgeInsets.all(10)),
                  Text(post.date.toString().split(" ").first)
                ],
              ),
              SizedBox(height: 15),
              playButton(
                  initState: false,
                  offText: "재생",
                  onText: "정지",
                  fileUrl: post.fileName)
            ],
          ),
        ));
  }
}
