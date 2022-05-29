import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:newbie_project/models/post.dart';
import 'package:newbie_project/utils/getPost.dart';
import 'package:newbie_project/widgets/BottomNavigator.dart';
import 'package:newbie_project/widgets/postCard.dart';

class Board extends HookWidget {
  Board({Key? key}) : super(key: key);

  Widget _listBuilder(content) {
    return ListView.builder(
      itemCount: content.length,
      itemBuilder: (context, index) {
        return PostCard(post: content[index], onDelete: () {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final _postList = useState<List<Post>>([]);

    final PostDatabase _postDatabase = PostDatabase();

    useEffect(() {
      _postDatabase.get().then((value) {
        _postList.value = value;
      });
      return;
    }, []);

    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text('Board'),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: _listBuilder(_postList.value),
      ),
    ));
  }
}
