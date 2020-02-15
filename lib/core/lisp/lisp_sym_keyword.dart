import 'package:custed2/core/lisp/lisp_keyword.dart';

/// Symbols that look like #:abc
class LispSymKeyword {
  final String name;

  /// Constructs a symbol that is not interned.
  LispSymKeyword.internal(this.name);

  @override
  String toString() => '#:$name';

  @override
  int get hashCode => name.hashCode; // Key to Speed for Dart

  /// The table of interned symbols
  static final Map<String, LispSymKeyword> table = {};

  /// Constructs an interned symbol.
  /// Constructs a [LispKeyword] if [isKeyword] holds.
  factory LispSymKeyword(String name) {
    var result = table[name];
    if (result == null) {
      result = LispSymKeyword.internal(name);
      table[name] = result;
    }
    return result;
  }

  /// Is it interned?
  bool get isInterned => identical(this, table[name]);
}
