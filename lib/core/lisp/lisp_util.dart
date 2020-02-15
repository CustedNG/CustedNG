import 'package:custed2/core/lisp/lisp_arg.dart';
import 'package:custed2/core/lisp/lisp_cell.dart';
import 'package:custed2/core/lisp/lisp_exceptions.dart';
import 'package:custed2/core/lisp/lisp_sym.dart';
import 'package:custed2/core/lisp/symbols.dart';

class LispUtil {
  static const _intBits = 63; // 53 for dart2js

  /// Converts [a] into an int if possible.
  static normalize(BigInt a) => (a.bitLength <= _intBits) ? a.toInt() : a;

  /// Is [a] a number?
  static bool isNumber(a) => a is num || a is BigInt;

  /// Calculates [a] + [b].
  static add(a, b) {
    if (a is int) {
      if (b is int) {
        if (a.bitLength < _intBits && b.bitLength < _intBits) {
          return a + b;
        } else {
          return normalize(BigInt.from(a) + BigInt.from(b));
        }
      } else if (b is double) {
        return a + b;
      } else if (b is BigInt) {
        return normalize(BigInt.from(a) + b);
      }
    } else if (a is double) {
      if (b is num) {
        return a + b;
      } else if (b is BigInt) {
        return a + b.toDouble();
      }
    } else if (a is BigInt) {
      if (b is int) {
        return normalize(a + BigInt.from(b));
      } else if (b is double) {
        return a.toDouble() + b;
      } else if (b is BigInt) {
        return normalize(a + b);
      }
    }
    throw ArgumentError("$a, $b");
  }

  /// Calculates [a] - [b].
  static subtract(a, b) {
    if (a is int) {
      if (b is int) {
        if (a.bitLength < _intBits && b.bitLength < _intBits) {
          return a - b;
        } else {
          return normalize(BigInt.from(a) - BigInt.from(b));
        }
      } else if (b is double) {
        return a - b;
      } else if (b is BigInt) {
        return normalize(BigInt.from(a) - b);
      }
    } else if (a is double) {
      if (b is num) {
        return a - b;
      } else if (b is BigInt) {
        return a - b.toDouble();
      }
    } else if (a is BigInt) {
      if (b is int) {
        return normalize(a - BigInt.from(b));
      } else if (b is double) {
        return a.toDouble() - b;
      } else if (b is BigInt) {
        return normalize(a - b);
      }
    }
    throw ArgumentError("$a, $b");
  }

  /// Compares [a] and [b].
  /// Returns -1, 0 or 1 as [a] is less than, equal to, or greater than [b].
  static num compare(a, b) {
    if (a is int) {
      if (b is int) {
        if (a.bitLength < _intBits && b.bitLength < _intBits) {
          return (a - b).sign;
        } else {
          return (BigInt.from(a) - BigInt.from(b)).sign;
        }
      } else if (b is double) {
        return (a - b).sign;
      } else if (b is BigInt) {
        return (BigInt.from(a) - b).sign;
      }
    } else if (a is double) {
      if (b is num) {
        return (a - b).sign;
      } else if (b is BigInt) {
        return (a - b.toDouble()).sign;
      }
    } else if (a is BigInt) {
      if (b is int) {
        return (a - BigInt.from(b)).sign;
      } else if (b is double) {
        return (a.toDouble() - b).sign;
      } else if (b is BigInt) {
        return (a - b).sign;
      }
    }
    throw ArgumentError("$a, $b");
  }

  /// Calculates [a] * [b].
  static multiply(a, b) {
    if (a is int) {
      if (b is int) {
        if (a.bitLength + b.bitLength < _intBits) {
          return a * b;
        } else {
          return normalize(BigInt.from(a) * BigInt.from(b));
        }
      } else if (b is double) {
        return a * b;
      } else if (b is BigInt) {
        return BigInt.from(a) * b;
      }
    } else if (a is double) {
      if (b is num) {
        return a * b;
      } else if (b is BigInt) {
        return a * b.toDouble();
      }
    } else if (a is BigInt) {
      if (b is int) {
        return a * BigInt.from(b);
      } else if (b is double) {
        return a.toDouble() * b;
      } else if (b is BigInt) {
        return a * b;
      }
    }
    throw ArgumentError("$a, $b");
  }

  /// Calculates [a] / [b] (rounded quotient).
  static double divide(a, b) {
    if (a is int) {
      if (b is num) {
        return a / b;
      } else if (b is BigInt) {
        return BigInt.from(a) / b;
      }
    } else if (a is double) {
      if (b is num) {
        return a / b;
      } else if (b is BigInt) {
        return a / b.toDouble();
      }
    } else if (a is BigInt) {
      if (b is int) {
        return a / BigInt.from(b);
      } else if (b is double) {
        return a.toDouble() / b;
      } else if (b is BigInt) {
        return a / b;
      }
    }
    throw ArgumentError("$a, $b");
  }

  /// Calculates the quotient of [a] and [b].
  static quotient(a, b) {
    if (a is int) {
      if (b is num) {
        return a ~/ b;
      } else if (b is BigInt) {
        return normalize(BigInt.from(a) ~/ b);
      }
    } else if (a is double) {
      if (b is num) {
        return a ~/ b;
      } else if (b is BigInt) {
        return a ~/ b.toDouble();
      }
    } else if (a is BigInt) {
      if (b is int) {
        return normalize(a ~/ BigInt.from(b));
      } else if (b is double) {
        return a.toDouble() ~/ b;
      } else if (b is BigInt) {
        return normalize(a ~/ b);
      }
    }
    throw ArgumentError("$a, $b");
  }

  /// Calculates the remainder of the quotient of [a] and [b].
  static remainder(a, b) {
    if (a is int) {
      if (b is num) {
        return a.remainder(b);
      } else if (b is BigInt) {
        return normalize(BigInt.from(a).remainder(b));
      }
    } else if (a is double) {
      if (b is num) {
        return a.remainder(b);
      } else if (b is BigInt) {
        return a.remainder(b.toDouble());
      }
    } else if (a is BigInt) {
      if (b is int) {
        return normalize(a.remainder(BigInt.from(b)));
      } else if (b is double) {
        return a.toDouble().remainder(b);
      } else if (b is BigInt) {
        return normalize(a.remainder(b));
      }
    }
    throw ArgumentError("$a, $b");
  }

  /// Mapping from a quote symbol to its string representation
  static final Map<LispSym, String> _quotes = <LispSym, String>{
    Symbols.quote: "'",
    Symbols.quasiquote: "`",
    Symbols.unquote: ",",
    Symbols.unquoteSplicing: ",@"
  };

  /// Makes a string representation of a Lisp expression
  static String str(x,
      [bool quoteString = true, int count, Set<LispCell> printed]) {
    if (x == null) {
      return "nil";
    } else if (x == true) {
      return "t";
    } else if (x is LispCell) {
      if (_quotes.containsKey(x.car) && x.cdr is LispCell) {
        if (x.cdr.cdr == null) {
          return _quotes[x.car] + str(x.cdr.car, true, count, printed);
        }
      }
      return "(" + strListBody(x, count, printed) + ")";
    } else if (x is String) {
      if (!quoteString) return x;
      var bf = StringBuffer('"');
      for (int ch in x.runes) {
        switch (ch) {
          case 0x08:
            bf.write(r"\b");
            break;
          case 0x09:
            bf.write(r"\t");
            break;
          case 0x0A:
            bf.write(r"\n");
            break;
          case 0x0B:
            bf.write(r"\v");
            break;
          case 0x0C:
            bf.write(r"\f");
            break;
          case 0x0D:
            bf.write(r"\r");
            break;
          case 0x22:
            bf.write(r'\"');
            break;
          case 0x5C:
            bf.write(r"\\");
            break;
          default:
            bf.writeCharCode(ch);
            break;
        }
      }
      bf.write('"');
      return bf.toString();
    } else if (x is List) {
      var s = x.map((e) => str(e, true, count, printed)).join(", ");
      return "[$s]";
    } else if (x is LispSym) {
      if (x.isInterned) return x.name;
      return "#$x";
    } else {
      return "$x";
    }
  }

  /// Makes a string representation of a list omitting its "(" and ")".
  static String strListBody(LispCell x, int count, Set<LispCell> printed) {
    printed ??= <LispCell>{};
    count ??= 4; // threshold of ellipsis for circular lists
    var s = <String>[];
    var y;
    for (y = x; y is LispCell; y = y.cdr) {
      if (printed.add(y)) {
        count = 4;
      } else {
        count--;
        if (count < 0) {
          s.add("..."); //  an ellipsis for a circular list
          return s.join(" ");
        }
      }
      s.add(str(y.car, true, count, printed));
    }
    if (y != null) {
      s.add(".");
      s.add(str(y, true, count, printed));
    }
    for (y = x; y is LispCell; y = y.cdr) {
      printed.remove(y);
    }
    return s.join(" ");
  }

  /// mapcar((a b c), fn) => (fn(a) fn(b) fn(c))
  static Future<LispCell> mapcar(LispCell j, fn(x)) async {
    if (j == null) return null;
    var a = await Future.sync(() => fn(j.car));
    var d = j.cdr;
    if (d is LispCell) d = await mapcar(d, fn);
    if (identical(j.car, a) && identical(j.cdr, d)) return j;
    return LispCell(a, d);
  }

  /// foldl(x, (a b c), fn) => fn(fn(fn(x, a), b), c)
  static foldl(x, LispCell j, fn(y, z)) {
    while (j != null) {
      x = fn(x, j.car);
      j = j.cdr;
    }
    return x;
  }

  /// Gets cdr of list [x] as a Cell or null.
  static LispCell cdrCell(LispCell x) {
    var k = x.cdr;
    if (k is LispCell) {
      return k;
    } else if (k == null) {
      return null;
    } else {
      throw LispEvalException("proper list expected", x);
    }
  }

  /// Expands [x] of any quasi-quotation `x into the equivalent S-expression.
  static qqExpand(x) {
    return qqExpand0(x, 0); // Begins with the nesting level 0.
  }

  static qqExpand0(x, int level) {
    if (x is LispCell) {
      if (x.car == Symbols.unquote) {
        // ,a
        if (level == 0) return x.cdr.car; // ,a => a
      }
      LispCell t = qqExpand1(x, level);
      if (t.car is LispCell && t.cdr == null) {
        LispCell k = t.car;
        if (k.car == Symbols.list || k.car == Symbols.cons) return k;
      }
      return LispCell(Symbols.append, t);
    } else {
      return qqQuote(x);
    }
  }

  /// Quotes [x] so that the result evaluates to [x].
  static qqQuote(x) => (x is LispSym || x is LispCell)
      ? LispCell(Symbols.quote, LispCell(x, null))
      : x;

// Expands [x] of `x so that the result can be used as an argument of append.
// Example 1: (,a b) => h=(list a) t=((list 'b)) => ((list a 'b))
// Example 2: (,a ,@(cons 2 3)) => h=(list a) t=((cons 2 3))
//                              => ((cons a (cons 2 3)))
  static LispCell qqExpand1(x, int level) {
    if (x is LispCell) {
      if (x.car == Symbols.unquote) {
        // ,a
        if (level == 0) return x.cdr; // ,a => (a)
        level--;
      } else if (x.car == Symbols.quasiquote) {
        // `a
        level++;
      }
      var h = qqExpand2(x.car, level);
      LispCell t = qqExpand1(x.cdr, level); // != null
      if (t.car == null && t.cdr == null) {
        return LispCell(h, null);
      } else if (h is LispCell) {
        if (h.car == Symbols.list) {
          if (t.car is LispCell) {
            LispCell tcar = t.car;
            if (tcar.car == Symbols.list) {
              var hh = qqConcat(h, tcar.cdr);
              return LispCell(hh, t.cdr);
            }
          }
          if (h.cdr is LispCell) {
            var hh = qqConsCons(h.cdr, t.car);
            return LispCell(hh, t.cdr);
          }
        }
      }
      return LispCell(h, t);
    } else {
      return LispCell(qqQuote(x), null);
    }
  }

// (1 2), (3 4) => (1 2 3 4)
  static qqConcat(LispCell x, Object y) =>
      (x == null) ? y : LispCell(x.car, qqConcat(x.cdr, y));

// (1 2 3), "a" => (cons 1 (cons 2 (cons 3 "a")))
  static qqConsCons(LispCell x, Object y) => (x == null)
      ? y
      : LispCell(
          Symbols.cons, LispCell(x.car, LispCell(qqConsCons(x.cdr, y), null)));

// Expands [y] = x.car of `x so that result can be used as an arg of append.
// Example: ,a => (list a); ,@(foo 1 2) => (foo 1 2); b => (list 'b)
  static qqExpand2(y, int level) {
    if (y is LispCell) {
      if (y.car == Symbols.unquote) {
        // ,a
        if (level == 0) return LispCell(Symbols.list, y.cdr); // ,a => (list a)
        level--;
      } else if (y.car == Symbols.unquoteSplicing) {
        // ,@a
        if (level == 0) return y.cdr.car; // ,@a => a
        level--;
      } else if (y.car == Symbols.quasiquote) {
        // `a
        level++;
      }
    }
    return LispCell(Symbols.list, LispCell(qqExpand0(y, level), null));
  }

  /// Makes an argument-table; returns true if there is a rest argument.
  static bool makeArgTable(arg, Map<LispSym, LispArg> table) {
    if (arg == null) {
      return false;
    } else if (arg is LispCell) {
      int offset = 0; // offset value within the call-frame
      bool hasRest = false;
      for (; arg != null; arg = cdrCell(arg)) {
        var j = arg.car;
        if (hasRest) throw LispEvalException("2nd rest", j);
        if (j == Symbols.rest) {
          // &rest var
          arg = cdrCell(arg);
          if (arg == null) throw LispNotVariableException(arg);
          j = arg.car;
          if (j == Symbols.rest) throw LispNotVariableException(j);
          hasRest = true;
        }
        LispSym sym = (j is LispSym)
            ? j
            : (j is LispArg) ? j.symbol : throw LispNotVariableException(j);
        if (table.containsKey(sym)) {
          throw LispEvalException("duplicated argument name", sym);
        }
        table[sym] = LispArg(0, offset, sym);
        offset++;
      }
      return hasRest;
    } else {
      throw LispEvalException("arglist expected", arg);
    }
  }

  /// Scans [j] for formal arguments in [table] and replaces them with Args.
  /// And scans [j] for free Args not in [table] and promotes their levels.
  static scanForArgs(j, Map<LispSym, LispArg> table) async {
    if (j is LispSym) {
      return table[j] ?? j;
    } else if (j is LispArg) {
      return table[j.symbol] ?? LispArg(j.level + 1, j.offset, j.symbol);
    } else if (j is LispCell) {
      if (j.car == Symbols.quote) {
        return j;
      } else if (j.car == Symbols.quasiquote) {
        return LispCell(Symbols.quasiquote, await scanForQQ(j.cdr, table, 0));
      } else {
        return mapcar(j, (x) => scanForArgs(x, table));
      }
    } else {
      return j;
    }
  }

  /// Scans for quasi-quotes.
  /// And does [scanForArgs] them depending on the nesting level.
  static Future scanForQQ(j, Map<LispSym, LispArg> table, int level) async {
    if (j is LispCell) {
      var k = j.car;
      if (k == Symbols.quasiquote) {
        return LispCell(k, await scanForQQ(j.cdr, table, level + 1));
      } else if (k == Symbols.unquote || k == Symbols.unquoteSplicing) {
        var d = (level == 0)
            ? await scanForArgs(j.cdr, table)
            : await scanForQQ(j.cdr, table, level - 1);
        if (identical(d, j.cdr)) return j;
        return LispCell(k, d);
      } else {
        return mapcar(j, (x) => scanForQQ(x, table, level));
      }
    } else {
      return j;
    }
  }
}
