import 'package:custed2/core/lisp/lisp_keyword.dart';

class LispSym {
  final String name;

  /// Constructs a symbol that is not interned.
  LispSym.internal(this.name);

  @override String toString() => name;
  @override int get hashCode => name.hashCode; // Key to Speed for Dart

  /// The table of interned symbols
  static final Map<String, LispSym> table = {};

  /// Constructs an interned symbol.
  /// Constructs a [LispKeyword] if [isKeyword] holds.
  factory LispSym(String name, [bool isKeyword=false]) {
    var result = table[name];
    assert(result == null || ! isKeyword);
    if (result == null) {
      result = isKeyword ? new LispKeyword.internal(name) : new LispSym.internal(name);
      table[name] = result;
    }
    return result;
  }

  /// Is it interned?
  bool get isInterned => identical(this, table[name]);
}
