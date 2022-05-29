import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:newbie_project/models/diary.dart';
import 'package:newbie_project/utils/getDiary.dart';
import 'package:newbie_project/widgets/diaryCard.dart';
import 'package:table_calendar/table_calendar.dart';
import './widgets/playButton.dart';

class ScreenArguments {
  final String userId;

  ScreenArguments(this.userId);
}

class CalendarWidget extends HookWidget {
  const CalendarWidget({Key? key}) : super(key: key);

  Widget _listBuilder(content) {
    return ListView.builder(
      itemCount: content.length,
      itemBuilder: (context, index) {
        return diaryCard(diary: content[index], onDelete: () {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final arg =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    final args = ScreenArguments(arg['userId'] as String);

    if (arg['userId'] == null) {
      Navigator.pop(context);
    }

    final _focusedDay = useState(DateTime.now());
    final _selectedDay = useState(DateTime.now());

    final diaries = useState<List<Diary>>([
      Diary(id: '1', name: '제목1', date: DateTime.now(), fileName: 'you.m4a')
    ]);

    useEffect(() {
      getDiary(args.userId).then((value) => diaries.value = value);
      return;
    }, []);

    return Scaffold(
        floatingActionButton: FloatingActionButton(
            onPressed: () => {
                  Navigator.pushNamed(context, '/recordVoice', arguments: {
                    'userId': args.userId,
                    'dateTime': _selectedDay.value
                  })
                },
            tooltip: 'Add Diary',
            child: const Icon(Icons.add)),
        body: SafeArea(
            child: Column(
          children: [
            TableCalendar(
              eventLoader: (day) {
                for (Diary diary in diaries.value) {
                  if (day.day == diary.date.day &&
                      day.month == diary.date.month &&
                      day.year == diary.date.year) {
                    return ['Diaries available'];
                  }
                }
                return [];
              }, // 이벤트에 따라 마커를 표시해주는 것 => 녹음이 된 파일이 있는 목록에서 보여주면 될 듯
              focusedDay: _focusedDay.value,
              firstDay: DateTime(2022, 1, 1),
              lastDay: DateTime(2022, 5, 31),
              locale: 'ko-KR',
              daysOfWeekHeight: 30,
              selectedDayPredicate: (day) {
                return _selectedDay.value.day == day.day &&
                    _selectedDay.value.month == day.month &&
                    _selectedDay.value.year == day.year;
              },
              onDaySelected: (selectedDay, focusedDay) {
                _selectedDay.value = selectedDay;
                _focusedDay.value = focusedDay;
              },
              headerStyle: const HeaderStyle(
                  formatButtonVisible: false, titleCentered: true),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 100,
              child: _listBuilder(diaries.value),
            )
          ],
        )));
  }
}
