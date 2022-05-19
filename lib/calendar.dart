import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:newbie_project/models/diary.dart';
import 'package:newbie_project/widgets/diaryCard.dart';
import 'package:table_calendar/table_calendar.dart';
import './widgets/playButton.dart';

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
    final _focusedDay = useState(DateTime.now());
    final _selectedDay = useState(DateTime.now());

    final diaries = useState<List<Diary>>([
      Diary(id: '1', name: '제목1', date: DateTime.now(), fileName: 'you.m4a')
    ]);

    return Scaffold(
        floatingActionButton: FloatingActionButton(
            onPressed: () => {},
            tooltip: 'Add Diary',
            child: const Icon(Icons.add)),
        body: SafeArea(
            child: Column(
          children: [
            TableCalendar(
              eventLoader: (day) {
                if (day.day % 2 == 0) {
                  return ['hi'];
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
            playButton(initState: false, onText: '시작', offText: '중지'),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 100,
              child: _listBuilder(diaries.value),
            )
          ],
        )));
  }
}
