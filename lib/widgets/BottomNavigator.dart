import 'package:flutter/material.dart';

class BottomNavigator extends StatelessWidget {
  final String userId;
  BottomNavigator({required this.userId});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            title: Text('Calendar'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            title: Text('Diary'),
          )
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/calendar',
                  arguments: {'userId': userId});
              break;
            case 1:
              Navigator.pushNamed(context, '/diary',
                  arguments: {'userId': userId});
              break;
          }
        });
  }
}
