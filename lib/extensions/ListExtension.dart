List removeNullsFromList(List list) => list
  ..removeWhere((value) => value == null)
  ..map((e) => removeNulls(e)).toList();

removeNulls(e) => (e is List)
    ? removeNullsFromList(e)
    : (e is Map ? removeNullsFromMap(e as Map<String, dynamic>) : e);

Map<String, dynamic> removeNullsFromMap(Map<String, dynamic> json) => json
  ..removeWhere((String key, dynamic value) => value == null)
  ..map<String, dynamic>((key, value) => MapEntry(key, removeNulls(value)));

extension ListExtension on List {
  List removeNulls() => removeNullsFromList(this);
}
