import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:newbie_project/board.dart';
import 'package:newbie_project/calendar.dart';

class routerPage extends HookWidget {
  List<dynamic> views = [CalendarWidget(), Board()];

  @override
  Widget build(BuildContext context) {
    final pageNum = useState(0);

    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: '일기',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: '게시판',
            )
          ],
          currentIndex: pageNum.value,
          onTap: (index) {
            pageNum.value = index;
          },
        ),
        body: views[pageNum.value]);
  }
}
