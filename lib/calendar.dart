import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:newbie_project/models/diary.dart';
import 'package:newbie_project/recordVoice.dart';
import 'package:newbie_project/utils/UserId.dart';
import 'package:newbie_project/utils/getDiary.dart';
import 'package:newbie_project/widgets/BottomNavigator.dart';
import 'package:newbie_project/widgets/diaryCard.dart';
import 'package:table_calendar/table_calendar.dart';
import './widgets/playButton.dart';
import 'package:newbie_project/extensions/ListExtension.dart';

class CalendarWidget extends HookWidget {
  const CalendarWidget({Key? key}) : super(key: key);

  Widget _listBuilder(content, _isSuccessful) {
    return ListView.builder(
      itemCount: content.length,
      itemBuilder: (context, index) {
        return diaryCard(
            diary: content[index],
            onDelete: (Diary diary) {
              removeDiary(UserId().userId as String, diary);
              _isSuccessful.value = true;
              Fluttertoast.showToast(msg: "성공적으로 삭제되었습니다");
            });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (UserId().userId == null) {
      Navigator.pop(context);
    }

    final _focusedDay = useState(DateTime.now());
    final _selectedDay = useState(DateTime.now());

    final _isSuccessful = useState(false);

    final diaries = useState<List<Diary>>([]);

    useEffect(() {
      if (_isSuccessful.value) {
        _isSuccessful.value = false;
      }
      print("Refreshed");
      getDiary(UserId().userId as String)
          .then((value) => diaries.value = value);
      return;
    }, [_isSuccessful.value]);

    // TODO: ShowBottomSheet 사용해보기
    return Scaffold(
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return RecordVoice(
                      dateTime: _selectedDay.value,
                      isSuccessful: _isSuccessful,
                    );
                  });
              // Navigator.pushNamed(context, '/recordVoice', arguments: {
              //   'dateTime': _selectedDay.value,
              //   'isSuccessful': _isSuccessful
              // });
            },
            tooltip: 'Add Diary',
            child: const Icon(Icons.add)),
        body: SafeArea(
            child: Column(
          children: [
            Padding(
                padding: EdgeInsets.all(30),
                child: SizedBox(
                    width: MediaQuery.of(context).size.width - 40,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("음성 일기",
                            style: TextStyle(
                                fontFamily: 'NanumSquare',
                                fontSize: 35,
                                fontWeight: FontWeight.w700)),
                        Text(
                          "목소리로 오늘 하루를 기록해요 :)",
                          style: TextStyle(
                              fontSize: 15, fontFamily: 'NanumSquare'),
                        )
                      ],
                    ))),
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
            Expanded(
              child: _listBuilder(
                  diaries.value
                      .map((diary) {
                        if (diary.date.day == _selectedDay.value.day &&
                            diary.date.month == _selectedDay.value.month &&
                            diary.date.year == _selectedDay.value.year) {
                          return diary;
                        }
                      })
                      .toList()
                      .removeNulls(),
                  _isSuccessful),
            )
          ],
        )));
  }
}
