import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:newbie_project/models/post.dart';
import 'package:newbie_project/utils/getPost.dart';
import 'package:newbie_project/widgets/BottomNavigator.dart';
import 'package:newbie_project/widgets/postCard.dart';

class Board extends HookWidget {
  Board({Key? key}) : super(key: key);

  Widget _listBuilder(content) {
    return ListView.builder(
      itemCount: content.value.length,
      itemBuilder: (context, index) {
        return PostCard(
            post: content.value[index],
            onDelete: (Post post) async {
              await PostDatabase().remove(post);
              content.value = await PostDatabase().get();
              Fluttertoast.showToast(msg: "성공적으로 삭제되었습니다!");
              return;
            });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final _postList = useState<List<Post>>([]);

    useEffect(() {
      PostDatabase().get().then((value) {
        _postList.value = value;
      });
      return;
    }, []);

    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white70,
      body: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Padding(
                  padding: EdgeInsets.all(30),
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width - 40,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("목소리 게시판",
                              style: TextStyle(
                                  fontFamily: 'NanumSquare',
                                  fontSize: 35,
                                  fontWeight: FontWeight.w700)),
                          Text(
                            "다른 사람의 이야기를 들어요 :)",
                            style: TextStyle(
                                fontSize: 15, fontFamily: 'NanumSquare'),
                          )
                        ],
                      ))),
              Expanded(
                child: _listBuilder(_postList),
              )
            ],
          )),
    ));
  }
}
