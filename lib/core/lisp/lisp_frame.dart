import 'dart:collection';

class LispFrame with ListMixin {
  LispFrame({
    this.positioned,
    this.keyword = const {},
  });

  List positioned;
  Map<String, dynamic> keyword;

  @override
  operator [](int index) => positioned[index];

  @override
  operator []=(int index, value) => positioned[index] = value;

  @override
  int get length => positioned.length;

  @override
  set length(_) => throw UnimplementedError();
}