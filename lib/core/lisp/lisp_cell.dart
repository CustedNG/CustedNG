import 'package:custed2/core/lisp/lisp_util.dart';

class LispCell {
  var car;
  var cdr;

  LispCell(this.car, this.cdr);
  @override String toString() => "($car . $cdr)";

  /// Length as a list
  int get length => LispUtil.foldl(0, this, (i, e) => i + 1);
}
