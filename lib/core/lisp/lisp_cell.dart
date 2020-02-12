import 'package:custed2/core/lisp/lisp_util.dart';

class LispCell {
  var car;
  var cdr;

  LispCell(this.car, this.cdr);

  LispCell.from(List list) {
    car = list[0];
    cdr = list.length <= 2 ? list[1] : LispCell.from(list.sublist(1));
  }

  /// (x . (x . (x . (x . (x . null)))))
  /// -> [x, x, x, x, x]
  List flatten() {
    final result = [];
    var cell = this;
    while (cell != null) {
      result.add(cell.car);
      cell = LispUtil.cdrCell(cell);
    }
    return result;
  }

  @override
  String toString() => "($car . $cdr)";

  /// Length as a list
  int get length => LispUtil.foldl(0, this, (i, e) => i + 1);
}
