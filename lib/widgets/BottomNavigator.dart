import 'package:flutter/material.dart';

class BottomNavigator extends StatelessWidget {
  BottomNavigator();

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: '일기',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: '게시판',
          )
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.popAndPushNamed(
                context,
                '/calendar',
              );
              break;
            case 1:
              Navigator.popAndPushNamed(
                context,
                '/board',
              );
              break;
          }
        });
  }
}
