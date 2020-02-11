// Originally: https://github.com/nukata/lisp-in-dart
// Nukata Lisp 2.00.0 in Dart 2.5 (H27.03.16/R01.11.02) by SUZUKI Hisao

import "dart:async";
import "dart:convert";
import "dart:io";

const _intBits = 63;             // 53 for dart2js

/// Converts [a] into an int if possible.
_normalize(BigInt a) => (a.bitLength <= _intBits) ? a.toInt() : a;

/// Is [a] a number?
bool _isNumber(a) => a is num || a is BigInt;

/// Calculates [a] + [b].
_add(a, b) {
  if (a is int) {
    if (b is int) {
      if (a.bitLength < _intBits && b.bitLength < _intBits) {
        return a + b;
      } else {
        return _normalize(BigInt.from(a) + BigInt.from(b));
      }
    } else if (b is double) {
      return a + b;
    } else if (b is BigInt) {
      return _normalize(BigInt.from(a) + b);
    }
  } else if (a is double) {
    if (b is num) {
      return a + b;
    } else if (b is BigInt) {
      return a + b.toDouble();
    }
  } else if (a is BigInt) {
    if (b is int) {
      return _normalize(a + BigInt.from(b));
    } else if (b is double) {
      return a.toDouble() + b;
    } else if (b is BigInt) {
      return _normalize(a + b);
    }
  }
  throw ArgumentError("$a, $b");
}

/// Calculates [a] - [b].
_subtract(a, b) {
  if (a is int) {
    if (b is int) {
      if (a.bitLength < _intBits && b.bitLength < _intBits) {
        return a - b;
      } else {
        return _normalize(BigInt.from(a) - BigInt.from(b));
      }
    } else if (b is double) {
      return a - b;
    } else if (b is BigInt) {
      return _normalize(BigInt.from(a) - b);
    }
  } else if (a is double) {
    if (b is num) {
      return a - b;
    } else if (b is BigInt) {
      return a - b.toDouble();
    }
  } else if (a is BigInt) {
    if (b is int) {
      return _normalize(a - BigInt.from(b));
    } else if (b is double) {
      return a.toDouble() - b;
    } else if (b is BigInt) {
      return _normalize(a - b);
    }
  }
  throw ArgumentError("$a, $b");
}

/// Compares [a] and [b].
/// Returns -1, 0 or 1 as [a] is less than, equal to, or greater than [b].
num _compare(a, b) {
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
_multiply(a, b) {
  if (a is int) {
    if (b is int) {
      if (a.bitLength + b.bitLength < _intBits) {
        return a * b;
      } else {
        return _normalize(BigInt.from(a) * BigInt.from(b));
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
double _divide(a, b) {
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
_quotient(a, b) {
  if (a is int) {
    if (b is num) {
      return a ~/ b;
    } else if (b is BigInt) {
      return _normalize(BigInt.from(a) ~/ b);
    }
  } else if (a is double) {
    if (b is num) {
      return a ~/ b;
    } else if (b is BigInt) {
      return a ~/ b.toDouble();
    }
  } else if (a is BigInt) {
    if (b is int) {
      return _normalize(a ~/ BigInt.from(b));
    } else if (b is double) {
      return a.toDouble() ~/ b;
    } else if (b is BigInt) {
      return _normalize(a ~/ b);
    }
  }
  throw ArgumentError("$a, $b");
}

/// Calculates the remainder of the quotient of [a] and [b].
_remainder(a, b) {
  if (a is int) {
    if (b is num) {
      return a.remainder(b);
    } else if (b is BigInt) {
      return _normalize(BigInt.from(a).remainder(b));
    }
  } else if (a is double) {
    if (b is num) {
      return a.remainder(b);
    } else if (b is BigInt) {
      return a.remainder(b.toDouble());
    }
  } else if (a is BigInt) {
    if (b is int) {
      return _normalize(a.remainder(BigInt.from(b)));
    } else if (b is double) {
      return a.toDouble().remainder(b);
    } else if (b is BigInt) {
      return _normalize(a.remainder(b));
    }
  }
  throw ArgumentError("$a, $b");
}

/// Tries to parse a string as an int, a BigInt or a double.
/// Returns null if [s] was not parsed successfully.
_tryParse(String s) {
  var r = BigInt.tryParse(s);
  return (r == null) ? double.tryParse(s) : _normalize(r);
}

//----------------------------------------------------------------------

/// Cons cell
class LispCell {
  var car;
  var cdr;

  LispCell(this.car, this.cdr);
  @override String toString() => "($car . $cdr)";

  /// Length as a list
  int get length => foldl(0, this, (i, e) => i + 1);
}


/// mapcar((a b c), fn) => (fn(a) fn(b) fn(c))
LispCell mapcar(LispCell j, fn(x)) {
  if (j == null)
    return null;
  var a = fn(j.car);
  var d = j.cdr;
  if (d is LispCell)
    d = mapcar(d, fn);
  if (identical(j.car, a) && identical(j.cdr, d))
    return j;
  return LispCell(a, d);
}

/// foldl(x, (a b c), fn) => fn(fn(fn(x, a), b), c)
foldl(x, LispCell j, fn(y, z)) {
  while (j != null) {
    x = fn(x, j.car);
    j = j.cdr;
  }
  return x;
}


/// Lisp symbol
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


/// Expression keyword
class LispKeyword extends LispSym {
  LispKeyword.internal(String name): super.internal(name);
  factory LispKeyword(String name) => LispSym(name, true);
}


final LispSym backQuoteSym = LispSym("`");
final LispSym commaAtSym = LispSym(",@");
final LispSym commaSym = LispSym(",");
final LispSym dotSym = LispSym(".");
final LispSym leftParenSym = LispSym("(");
final LispSym rightParenSym = LispSym(")");
final LispSym singleQuoteSym = LispSym("'");

final LispSym appendSym = LispSym("append");
final LispSym consSym = LispSym("cons");
final LispSym listSym = LispSym("list");
final LispSym restSym = LispSym("&rest");
final LispSym unquoteSym = LispSym("unquote");
final LispSym unquoteSplicingSym = LispSym("unquote-splicing");

//----------------------------------------------------------------------

/// Common base class of Lisp functions
abstract class LispFunc {
  /// Number of arguments, made negative if the function has &rest
  final int carity;

  int get arity => (carity < 0) ? -carity : carity;
  bool get hasRest => (carity < 0);
  int get fixedArgs => (carity < 0) ? -carity - 1 : carity; // # of fixed args.

  LispFunc(this.carity);

  /// Makes a frame for local variables from a list of actual arguments.
  List makeFrame(LispCell arg) {
    List frame = List(arity);
    int n = fixedArgs;
    int i;
    for (i = 0; i < n && arg != null; i++) { // Sets the list of fixed args.
      frame[i] = arg.car;
      arg = cdrCell(arg);
    }
    if (i != n || (arg != null && !hasRest))
      throw LispEvalException("arity not matched", this);
    if (hasRest)
      frame[n] = arg;
    return frame;
  }

  /// Evaluates each expression in a frame.
  void evalFrame(List frame, LispInterp interp, LispCell env) {
    int n = fixedArgs;
    for (int i = 0; i < n; i++)
      frame[i] = interp.eval(frame[i], env);
    if (hasRest && frame[n] is LispCell) {
      LispCell z = null;
      LispCell y = null;
      for (LispCell j = frame[n]; j != null; j = cdrCell(j)) {
        var e = interp.eval(j.car, env);
        LispCell x = LispCell(e, null);
        if (z == null)
          z = x;
        else
          y.cdr = x;
        y = x;
      }
      frame[n] = z;
    }
  }
}


/// Common base class of functions which are defined with Lisp expressions
abstract class LispDefinedFunc extends LispFunc {
  /// Lisp list as the function body
  final LispCell body;

  LispDefinedFunc(int carity, this.body): super(carity);
}


/// Common function type which represents any factory method of DefinedFunc
typedef LispDefinedFunc FuncFactory(int cariy, LispCell body, LispCell env);


/// Compiled macro expression
class LispMacro extends LispDefinedFunc {
  LispMacro(int carity, LispCell body): super(carity, body);
  @override String toString() => "#<macro:$carity:${_str(body)}>";

  /// Expands the macro with a list of actual arguments.
  expandWith(LispInterp interp, LispCell arg) {
    List frame = makeFrame(arg);
    LispCell env = LispCell(frame, null);
    var x = null;
    for (LispCell j = body; j != null; j = cdrCell(j))
      x = interp.eval(j.car, env);
    return x;
  }

  static LispDefinedFunc make(int carity, LispCell body, LispCell env) {
    assert(env == null);
    return LispMacro(carity, body);
  }
}


/// Compiled lambda expression (Within another function)
class LispLambda extends LispDefinedFunc {
  LispLambda(int carity, LispCell body): super(carity, body);
  @override String toString() => "#<lambda:$carity:${_str(body)}>";

  static LispDefinedFunc make(int carity, LispCell body, LispCell env) {
    assert(env == null);
    return LispLambda(carity, body);
  }
}


/// Compiled lambda expresssion (Closure with environment)
class LispClosure extends LispDefinedFunc {
  /// The environment of the closure
  final LispCell env;

  LispClosure(int carity, LispCell body, this.env): super(carity, body);
  LispClosure.from(LispLambda x, LispCell env): this(x.carity, x.body, env);
  @override String toString() => "#<closure:$carity:${_str(env)}:${_str(body)}>";

  /// Makes an environment to evaluate the body from a list of actual args.
  LispCell makeEnv(LispInterp interp, LispCell arg, LispCell interpEnv) {
    List frame = makeFrame(arg);
    evalFrame(frame, interp, interpEnv);
    return LispCell(frame, env);    // Prepends the frame to the closure's env.
  }

  static LispDefinedFunc make(int carity, LispCell body, LispCell env) =>
    LispClosure(carity, body, env);
}


/// Function type which represents any built-in function body
typedef LispBuiltInFuncBody(List frame);

/// Built-in function
class LispBuiltInFunc extends LispFunc {
  final String name;
  final LispBuiltInFuncBody body;

  LispBuiltInFunc(this.name, int carity, this.body): super(carity);
  @override String toString() => "#<$name:$carity>";

  /// Invokes the built-in function with a list of actual arguments.
  evalWith(LispInterp interp, LispCell arg, LispCell interpEnv) {
    List frame = makeFrame(arg);
    evalFrame(frame, interp, interpEnv);
    try {
      return body(frame);
    } on LispEvalException catch (ex) {
      throw ex;
    } catch (ex) {
      throw LispEvalException("$ex -- $name", frame);
    }
  }
}


/// Bound variable in a compiled lambda/macro expression
class LispArg {
  final int level;
  final int offset;
  final LispSym symbol;

  LispArg(this.level, this.offset, this.symbol);
  @override String toString() => "#$level:$offset:$symbol";

  /// Sets a value [x] to the location corresponding to the variable in [env].
  void setValue(x, LispCell env) {
    for (int i = 0; i < level; i++)
      env = env.cdr;
    env.car[offset] = x;
  }

  /// Gets a value from the location corresponding to the variable in [env].
  getValue(LispCell env) {
    for (int i = 0; i < level; i++)
      env = env.cdr;
    return env.car[offset];
  }
}


/// Exception in evaluation
class LispEvalException implements Exception {
  final String message;
  final List<String> trace = [];

  LispEvalException(String msg, Object x, [bool quoteString=true])
    : message = msg + ": " + _str(x, quoteString);

  @override String toString() {
    var s = "EvalException: $message";
    for (String line in trace)
      s += "\n\t$line";
    return s;
  }
}


/// Exception which indicates an absence of a variable
class LispNotVariableException extends LispEvalException {
  LispNotVariableException(x): super("variable expected", x);
}

//----------------------------------------------------------------------

/// Core of the interpreter
class LispInterp {
  /// Table of the global values of symbols
  final Map<LispSym, Object> globals = {};

  /// Standard output of the interpreter
  StringSink cout = stdout;

  /// Sets built-in functions etc. as the global values of symbols.
  LispInterp() {
    def("car", 1, (List a) => (a[0] as LispCell)?.car);
    def("cdr", 1, (List a) => (a[0] as LispCell)?.cdr);
    def("cons", 2, (List a) => LispCell(a[0], a[1]));
    def("atom", 1, (List a) => (a[0] is LispCell) ? null : true);
    def("eq", 2, (List a) => identical(a[0], a[1]) ? true : null);

    def("list", -1, (List a) => a[0]);
    def("rplaca", 2, (List a) { a[0].car = a[1]; return a[1]; });
    def("rplacd", 2, (List a) { a[0].cdr = a[1]; return a[1]; });
    def("length", 1, (List a) => (a[0] == null) ? 0 : a[0].length);
    def("stringp", 1, (List a) => (a[0] is String) ? true : null);
    def("numberp", 1, (List a) => _isNumber(a[0]) ? true : null);
    def("eql", 2, (List a) {
      var x = a[0];
      var y = a[1];
      return (x == y) ? true :
        (_isNumber(x) && _isNumber(y) && _compare(x, y) == 0) ? true : null;
    });
    def("<", 2, (List a) => (_compare(a[0], a[1]) < 0) ? true : null);
    def("%", 2, (List a) => _remainder(a[0], a[1]));
    def("mod", 2, (List a) {
      var x = a[0];
      var y = a[1];
      var q = _remainder(x, y);
      return (_compare(_multiply(x, y), 0) < 0) ? _add(q, y) : q;
    });

    def("+", -1, (List a) => foldl(0, a[0], (i, j) => _add(i, j)));
    def("*", -1, (List a) => foldl(1, a[0], (i, j) => _multiply(i, j)));
    def("-", -2, (List a) {
      var x = a[0];
      LispCell y = a[1];
      return (y == null) ? -x : foldl(x, y, (i, j) => _subtract(i, j));
    });
    def("/", -3, (List a) =>
        foldl(_divide(a[0], a[1]), a[2], (i, j) => _divide(i, j)));

    def("truncate", -2, (List a) {
      var x = a[0];
      LispCell y = a[1];
      return (y == null) ? _quotient(x, 1) :
        (y.cdr == null) ? _quotient(x, y.car) :
        throw "one or two arguments expected";
    });

    def("prin1", 1, (List a) { cout.write(_str(a[0], true)); return a[0]; });
    def("princ", 1, (List a) { cout.write(_str(a[0], false)); return a[0]; });
    def("terpri", 0, (List a) { cout.writeln(); return true; });

    var gensymCounterSym = LispSym("*gensym-counter*");
    globals[gensymCounterSym] = 1;
    def("gensym", 0, (List a) {
      int i = globals[gensymCounterSym];
      globals[gensymCounterSym] = i + 1;
      return new LispSym.internal("G$i");
    });

    def("make-symbol", 1, (List a) => new LispSym.internal(a[0]));
    def("intern", 1, (List a) => LispSym(a[0]));
    def("symbol-name", 1, (List a) => (a[0] as LispSym).name);

    def("apply", 2, (List a) => eval(LispCell(a[0], mapcar(a[1], qqQuote)), null));

    def("exit", 1, (List a) => exit(a[0]));
    def("dump", 0, (List a) => globals.keys.fold(null, (x, y) => LispCell(y, x)));
    globals[LispSym("*version*")] =
      LispCell(2.000, LispCell("Dart", LispCell("Nukata Lisp", null)));
    // named after Tōkai-dō Mikawa-koku Nukata-gun (東海道 三河国 額田郡)
  }

  /// Defines a built-in function by giving a name, an arity, and a body.
  void def(String name, int carity, LispBuiltInFuncBody body) {
    globals[LispSym(name)] = LispBuiltInFunc(name, carity, body);
  }

  /// Evaluates a Lisp expression in an environment.
  eval(x, LispCell env) {
    try {
      for (;;) {
        if (x is LispArg) {
          return x.getValue(env);
        } else if (x is LispSym) {
          if (globals.containsKey(x))
            return globals[x];
          throw LispEvalException("void variable", x);
        } else if (x is LispCell) {
          var fn = x.car;
          LispCell arg = cdrCell(x);
          if (fn is LispKeyword) {
            if (fn == _quoteSym) {
              if (arg != null && arg.cdr == null)
                return arg.car;
              throw LispEvalException("bad quote", x);
            } else if (fn == _prognSym) {
              x = _evalProgN(arg, env);
            } else if (fn == _condSym) {
              x = _evalCond(arg, env);
            } else if (fn == _setqSym) {
              return _evalSetQ(arg, env);
            } else if (fn == _lambdaSym) {
              return _compile(arg, env, LispClosure.make);
            } else if (fn == _macroSym) {
              if (env != null)
                throw LispEvalException("nested macro", x);
              return _compile(arg, null, LispMacro.make);
            } else if (fn == _quasiquoteSym) {
              if (arg != null && arg.cdr == null)
                x = qqExpand(arg.car);
              else
                throw LispEvalException("bad quasiquote", x);
            } else {
              throw LispEvalException("bad keyword", fn);
            }
          } else {      // Application of a function
            // Expands fn = eval(fn, env) here on Sym for speed.
            if (fn is LispSym) {
              fn = globals[fn];
              if (fn == null)
                throw LispEvalException("undefined", x.car);
            } else {
              fn = eval(fn, env);
            }

            if (fn is LispClosure) {
              env = fn.makeEnv(this, arg, env);
              x = _evalProgN(fn.body, env);
            } else if (fn is LispMacro) {
              x = fn.expandWith(this, arg);
            } else if (fn is LispBuiltInFunc) {
              return fn.evalWith(this, arg, env);
            } else {
              throw LispEvalException("not applicable", fn);
            }
          }
        } else if (x is LispLambda) {
          return new LispClosure.from(x, env);
        } else {
          return x;             // numbers, strings, null etc.
        }
      }
    } on LispEvalException catch (ex) {
      if (ex.trace.length < 10)
        ex.trace.add(_str(x));
      throw ex;
    }
  }

  /// (progn E1 E2.. En) => Evaluates E1, E2, .. except for En and returns it.
  _evalProgN(LispCell j, LispCell env) {
    if (j == null)
      return null;
    for (;;) {
      var x = j.car;
      j = cdrCell(j);
      if (j == null)
        return x;       // The tail expression will be evaluated at the caller.
      eval(x, env);
    }
  }

  /// Evaluates a conditional expression and returns the selection unevaluated.
  _evalCond(LispCell j, LispCell env) {
    for (; j != null; j = cdrCell(j)) {
      var clause = j.car;
      if (clause is LispCell) {
        var result = eval(clause.car, env);
        if (result != null) {   // If the condition holds
          LispCell body = cdrCell(clause);
          if (body == null)
            return qqQuote(result);
          else
            return _evalProgN(body, env);
        }
      } else if (clause != null) {
        throw LispEvalException("cond test expected", clause);
      }
    }
    return null;                // No clause holds.
  }

  /// (setq V1 E1 ..) => Evaluates Ei and assigns it to Vi; returns the last.
  _evalSetQ(LispCell j, LispCell env) {
    var result = null;
    for (; j != null; j = cdrCell(j)) {
      var lval = j.car;
      j = cdrCell(j);
      if (j == null)
        throw LispEvalException("right value expected", lval);
      result = eval(j.car, env);
      if (lval is LispArg)
        lval.setValue(result, env);
      else if (lval is LispSym && lval is! LispKeyword)
        globals[lval] = result;
      else
        throw LispNotVariableException(lval);
    }
    return result;
  }

  /// Compiles a Lisp list (macro ...) or (lambda ...).
  LispDefinedFunc _compile(LispCell arg, LispCell env, FuncFactory make) {
    if (arg == null)
      throw LispEvalException("arglist and body expected", arg);
    Map<LispSym, LispArg> table = {};
    bool hasRest = _makeArgTable(arg.car, table);
    int arity = table.length;
    LispCell body = cdrCell(arg);
    body = _scanForArgs(body, table);
    body = _expandMacros(body, 20); // Expands ms statically up to 20 nestings.
    body = _compileInners(body);
    return make((hasRest) ? -arity : arity, body, env);
  }

  /// Expands macros and quasi-quotations in an expression.
  _expandMacros(j, int count) {
    if (count > 0 && j is LispCell) {
      var k = j.car;
      if (k == _quoteSym || k == _lambdaSym || k == _macroSym) {
        return j;
      } else if (k == _quasiquoteSym) {
        LispCell d = cdrCell(j);
        if (d != null && d.cdr == null) {
          var z = qqExpand(d.car);
          return _expandMacros(z, count);
        }
        throw LispEvalException("bad quasiquote", j);
      } else {
        if (k is LispSym)
          k = globals[k];       // null if k does not have a value
        if (k is LispMacro) {
          LispCell d = cdrCell(j);
          var z = k.expandWith(this, d);
          return _expandMacros(z, count - 1);
        } else {
          return mapcar(j, (x) => _expandMacros(x, count));
        }
      }
    } else {
      return j;
    }
  }

  /// Replaces inner lambda-expressions with Lambda instances.
  _compileInners(j) {
    if (j is LispCell) {
      var k = j.car;
      if (k == _quoteSym) {
        return j;
      } else if (k == _lambdaSym) {
        LispCell d = cdrCell(j);
        return _compile(d, null, LispLambda.make);
      } else if (k == _macroSym) {
        throw LispEvalException("nested macro", j);
      } else {
        return mapcar(j, (x) => _compileInners(x));
      }
    } else {
      return j;
    }
  }
}

//----------------------------------------------------------------------

/// Makes an argument-table; returns true if there is a rest argument.
bool _makeArgTable(arg, Map<LispSym, LispArg> table) {
  if (arg == null) {
    return false;
  } else if (arg is LispCell) {
    int offset = 0;             // offset value within the call-frame
    bool hasRest = false;
    for (; arg != null; arg = cdrCell(arg)) {
      var j = arg.car;
      if (hasRest)
        throw LispEvalException("2nd rest", j);
      if (j == restSym) {       // &rest var
        arg = cdrCell(arg);
        if (arg == null)
          throw LispNotVariableException(arg);
        j = arg.car;
        if (j == restSym)
          throw LispNotVariableException(j);
        hasRest = true;
      }
      LispSym sym =
        (j is LispSym) ? j :
        (j is LispArg) ? j.symbol : throw LispNotVariableException(j);
      if (table.containsKey(sym))
        throw LispEvalException("duplicated argument name", sym);
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
_scanForArgs(j, Map<LispSym, LispArg> table) {
  if (j is LispSym) {
    return table[j] ?? j;
  } else if (j is LispArg) {
    return table[j.symbol] ?? LispArg(j.level + 1, j.offset, j.symbol);
  } else if (j is LispCell) {
    if (j.car == _quoteSym) {
      return j;
    } else if (j.car == _quasiquoteSym) {
      return LispCell(_quasiquoteSym, _scanForQQ(j.cdr, table, 0));
    } else {
      return mapcar(j, (x) => _scanForArgs(x, table));
    }
  } else {
    return j;
  }
}

/// Scans for quasi-quotes.
/// And does [_scanForArgs] them depending on the nesting level.
_scanForQQ(j, Map<LispSym, LispArg> table, int level) {
  if (j is LispCell) {
    var k = j.car;
    if (k == _quasiquoteSym) {
      return LispCell(k, _scanForQQ(j.cdr, table, level + 1));
    } else if (k == unquoteSym || k == unquoteSplicingSym) {
      var d = (level == 0) ? _scanForArgs(j.cdr, table) :
                             _scanForQQ(j.cdr, table, level - 1);
      if (identical(d, j.cdr))
        return j;
      return LispCell(k, d);
    } else {
      return mapcar(j, (x) => _scanForQQ(x, table, level));
    }
  } else {
    return j;
  }
}

/// Gets cdr of list [x] as a Cell or null.
LispCell cdrCell(LispCell x) {
  var k = x.cdr;
  if (k is LispCell)
    return k;
  else if (k == null)
    return null;
  else
    throw LispEvalException("proper list expected", x);
}

//----------------------------------------------------------------------
// Quasi-Quotation

/// Expands [x] of any quasi-quotation `x into the equivalent S-expression.
qqExpand(x) {
  return _qqExpand0(x, 0);      // Begins with the nesting level 0.
}

_qqExpand0(x, int level) {
  if (x is LispCell) {
    if (x.car == unquoteSym) {  // ,a
      if (level == 0)
        return x.cdr.car;       // ,a => a
    }
    LispCell t = _qqExpand1(x, level);
    if (t.car is LispCell && t.cdr == null) {
      LispCell k = t.car;
      if (k.car == listSym || k.car == consSym)
        return k;
    }
    return LispCell(appendSym, t);
  } else {
    return qqQuote(x);
  }
}

/// Quotes [x] so that the result evaluates to [x].
qqQuote(x) =>
  (x is LispSym || x is LispCell) ? LispCell(_quoteSym, LispCell(x, null)) : x;

// Expands [x] of `x so that the result can be used as an argument of append.
// Example 1: (,a b) => h=(list a) t=((list 'b)) => ((list a 'b))
// Example 2: (,a ,@(cons 2 3)) => h=(list a) t=((cons 2 3))
//                              => ((cons a (cons 2 3)))
LispCell _qqExpand1(x, int level) {
  if (x is LispCell) {
    if (x.car == unquoteSym) {  // ,a
      if (level == 0)
        return x.cdr;           // ,a => (a)
      level--;
    } else if (x.car == _quasiquoteSym) { // `a
      level++;
    }
    var h = _qqExpand2(x.car, level);
    LispCell t = _qqExpand1(x.cdr, level); // != null
    if (t.car == null && t.cdr == null) {
      return LispCell(h, null);
    } else if (h is LispCell) {
      if (h.car == listSym) {
        if (t.car is LispCell) {
          LispCell tcar = t.car;
          if (tcar.car == listSym) {
            var hh = _qqConcat(h, tcar.cdr);
            return LispCell(hh, t.cdr);
          }
        }
        if (h.cdr is LispCell) {
          var hh = _qqConsCons(h.cdr, t.car);
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
_qqConcat(LispCell x, Object y) =>
  (x == null) ? y : LispCell(x.car, _qqConcat(x.cdr, y));

// (1 2 3), "a" => (cons 1 (cons 2 (cons 3 "a")))
_qqConsCons(LispCell x, Object y) =>
  (x == null) ? y :
  LispCell(consSym, LispCell(x.car, LispCell(_qqConsCons(x.cdr, y), null)));

// Expands [y] = x.car of `x so that result can be used as an arg of append.
// Example: ,a => (list a); ,@(foo 1 2) => (foo 1 2); b => (list 'b)
_qqExpand2(y, int level) {
  if (y is LispCell) {
    if (y.car == unquoteSym) {  // ,a
      if (level == 0)
        return LispCell(listSym, y.cdr); // ,a => (list a)
      level--;
    } else if (y.car == unquoteSplicingSym) { // ,@a
      if (level == 0)
        return y.cdr.car;       // ,@a => a
      level--;
    } else if (y.car == _quasiquoteSym) { // `a
      level++;
    }
  }
  return LispCell(listSym, LispCell(_qqExpand0(y, level), null));
}

//----------------------------------------------------------------------

/// Reader of Lisp expressions
class LispReader {
  final StreamIterator<String> _rf;
  var _token;
  Iterator<String> _tokens = <String>[].iterator;
  int _lineNo = 0;
  bool _erred = false;

  /// Constructs a Reader which will read Lisp expressions from a given arg.
  LispReader(this._rf);

  /// Reads a Lisp expression; returns #EOF if the input runs out normally.
  Future<Object> read() async {
    try {
      await _readToken();
      return await _parseExpression();
    } on FormatException catch (ex) {
      _erred = true;
      throw LispEvalException("syntax error",
          "${ex.message} -- $_lineNo: ${_rf.current}", false);
    }
  }

  Future<Object> _parseExpression() async {
    if (_token == leftParenSym) { // (a b c)
      await _readToken();
      return await _parseListBody();
    } else if (_token == singleQuoteSym) { // 'a => (quote a)
      await _readToken();
      return LispCell(_quoteSym, LispCell(await _parseExpression(), null));
    } else if (_token == backQuoteSym) { // `a => (quasiquote a)
      await _readToken();
      return LispCell(_quasiquoteSym, LispCell(await _parseExpression(), null));
    } else if (_token == commaSym) { // ,a => (unquote a)
      await _readToken();
      return LispCell(unquoteSym, LispCell(await _parseExpression(), null));
    } else if (_token == commaAtSym) { // ,@a => (unquote-splicing a)
      await _readToken();
      return LispCell(unquoteSplicingSym, LispCell(await _parseExpression(), null));
    } else if (_token == dotSym || _token == rightParenSym) {
      throw FormatException('unexpected "$_token"');
    } else {
      return _token;
    }
  }

  Future<LispCell> _parseListBody() async {
    if (_token == #EOF) {
      throw FormatException("unexpected EOF");
    } else if (_token == rightParenSym) {
      return null;
    } else {
      var e1 = await _parseExpression();
      await _readToken();
      var e2;
      if (_token == dotSym) {   // (a . b)
        await _readToken();
        e2 = await _parseExpression();
        await _readToken();
        if (_token != rightParenSym)
          throw FormatException('")" expected: $_token');
      } else {
        e2 = await _parseListBody();
      }
      return LispCell(e1, e2);
    }
  }

  /// Reads the next token and sets it to [_token].
  Future _readToken() async {
    while (! _tokens.moveNext() || _erred) { // line ends or erred last time
      _erred = false;
      _lineNo++;
      if (! await _rf.moveNext()) {
        _token = #EOF;
        return;
      }
      _tokens = _tokenPat.allMatches(_rf.current)
        .map((Match m) => m[1])
        .where((String s) => s != null)
        .iterator;
    }
    _token = _tokens.current;
    if (_token[0] == '"') {
      String s = _token;
      int n = s.length - 1;
      if (n < 1 || s[n] != '"')
        throw FormatException("bad string: '$s'");
      s = s.substring(1, n);
      s = s.replaceAllMapped(_escapePat, (Match m) {
        String key = m[1];
        return _escapes[key] ?? "\\$key";
      });
      _token = s;
      return;
    }
    var n = _tryParse(_token);
    if (n != null) {
      _token = n;
    } else if (_token == "nil") {
      _token = null;
    } else if (_token == "t") {
      _token = true;
    } else {
      _token = LispSym(_token);
    }
  }

  /// Regular expression to split a line into Lisp tokens
  static final _tokenPat =
    RegExp('\\s+|;.*\$|("(\\\\.?|.)*?"|,@?|[^()\'`~"; \t]+|.)');

  /// Regular expression to take an escape sequence out of a string
  static final _escapePat = RegExp(r'\\(.)');

  /// Mapping from a character of escape sequence to its string value
  static final Map<String, String> _escapes = <String, String>{
    "\\": "\\",
    '"': '"',
    "n": "\n", "r": "\r", "f": "\f", "b": "\b", "t": "\t", "v": "\v"
  };
}

//----------------------------------------------------------------------

/// Mapping from a quote symbol to its string representation
final Map<LispSym, String> _quotes = <LispSym, String>{
  _quoteSym: "'", _quasiquoteSym: "`", unquoteSym: ",", unquoteSplicingSym: ",@"
};

/// Makes a string representation of a Lisp expression
String _str(x, [bool quoteString=true, int count, Set<LispCell> printed]) {
  if (x == null) {
    return "nil";
  } else if (x == true) {
    return "t";
  } else if (x is LispCell) {
    if (_quotes.containsKey(x.car) && x.cdr is LispCell) {
      if (x.cdr.cdr == null)
        return _quotes[x.car] + _str(x.cdr.car, true, count, printed);
    }
    return "(" + _strListBody(x, count, printed) + ")";
  } else if (x is String) {
    if (! quoteString)
      return x;
    var bf = StringBuffer('"');
    for (int ch in x.runes)
      switch (ch) {
        case 0x08: bf.write(r"\b"); break;
        case 0x09: bf.write(r"\t"); break;
        case 0x0A: bf.write(r"\n"); break;
        case 0x0B: bf.write(r"\v"); break;
        case 0x0C: bf.write(r"\f"); break;
        case 0x0D: bf.write(r"\r"); break;
        case 0x22: bf.write(r'\"'); break;
        case 0x5C: bf.write(r"\\"); break;
        default: bf.writeCharCode(ch); break;
      }
    bf.write('"');
    return bf.toString();
  } else if (x is List) {
    var s = x.map((e) => _str(e, true, count, printed)).join(", ");
    return "[$s]";
  } else if (x is LispSym) {
    if (x.isInterned)
      return x.name;
    return "#:$x";
  } else {
    return "$x";
  }
}

/// Makes a string representation of a list omitting its "(" and ")".
String _strListBody(LispCell x, int count, Set<LispCell> printed) {
  printed ??= Set<LispCell>();
  count ??= 4;                  // threshold of ellipsis for circular lists
  var s = List<String>();
  var y;
  for (y = x; y is LispCell; y = y.cdr) {
    if (printed.add(y)) {
      count = 4;
    } else {
      count--;
      if (count < 0) {
        s.add("...");           //  an ellipsis for a circular list
        return s.join(" ");
      }
    }
    s.add(_str(y.car, true, count, printed));
  }
  if (y != null) {
    s.add(".");
    s.add(_str(y, true, count, printed));
  }
  for (y = x; y is LispCell; y = y.cdr)
    printed.remove(y);
  return s.join(" ");
}

//----------------------------------------------------------------------

/// Runs REPL (Read-Eval-Print Loop).
Future lispRepl(LispInterp interp, Stream<String> input) async {
  bool interactive = (input == null);
  input ??= stdin.transform(const Utf8Codec().decoder);
  input = input.transform(const LineSplitter());
  var lines = StreamIterator(input);
  var reader = LispReader(lines);
  for (;;) {
    if (interactive) {
      stdout.write("> ");
      try {
        var sExp = await reader.read();
        if (sExp == #EOF)
          return;
        var x = interp.eval(sExp, null);
        print(_str(x));
      } on Exception catch (ex) {
        print(ex);
      }
    } else {
      var sExp = await reader.read();
      if (sExp == #EOF)
        return;
      interp.eval(sExp, null);
    }
  }
}

// Keywords
final LispSym _condSym = LispKeyword("cond");
final LispSym _lambdaSym = LispKeyword("lambda");
final LispSym _macroSym = LispKeyword("macro");
final LispSym _prognSym = LispKeyword("progn");
final LispSym _quasiquoteSym = LispKeyword("quasiquote");
final LispSym _quoteSym = LispKeyword("quote");
final LispSym _setqSym = LispKeyword("setq");

/// Makes a Lisp interpreter initialized with [prelude].
Future<LispInterp> lispMakeInterp() async {
  // Dart initializes static variables lazily.  Therefore, all keywords are
  // referred explicitly here so that they are initialized as keywords
  // before any occurrences of symbols of their names.
  [_condSym, _lambdaSym, _macroSym, _prognSym, _quasiquoteSym, _quoteSym, _setqSym];

  var interp = LispInterp();
  Future<String> fs = new Future.value(prelude);
  Stream<String> ss = new Stream.fromFuture(fs);
  await lispRepl(interp, ss);
  return interp;
}

/// Runs each arg as a Lisp script in order.
/// Runs interactively for no arg or -.
main(List<String> args) async {
  try {
    LispInterp interp = await lispMakeInterp();
    for (String fileName in (args.isEmpty) ? ["-"] : args) {
      if (fileName == "-") {
        await lispRepl(interp, null);
        print("Goodbye");
      } else {
        var file = File(fileName);
        Stream<List<int>> bytes = file.openRead();
        Stream<String> input = bytes.transform(const Utf8Codec().decoder);
        await lispRepl(interp, input);
      }
    }
    exit(0);
  } on Exception catch (ex) {
    print(ex);
    exit(1);
  }
}

/// Lisp initialization script
const String prelude = """
(setq defmacro
      (macro (name args &rest body)
             `(progn (setq ,name (macro ,args ,@body))
                     ',name)))
(defmacro defun (name args &rest body)
  `(progn (setq ,name (lambda ,args ,@body))
          ',name))
(defun caar (x) (car (car x)))
(defun cadr (x) (car (cdr x)))
(defun cdar (x) (cdr (car x)))
(defun cddr (x) (cdr (cdr x)))
(defun caaar (x) (car (car (car x))))
(defun caadr (x) (car (car (cdr x))))
(defun cadar (x) (car (cdr (car x))))
(defun caddr (x) (car (cdr (cdr x))))
(defun cdaar (x) (cdr (car (car x))))
(defun cdadr (x) (cdr (car (cdr x))))
(defun cddar (x) (cdr (cdr (car x))))
(defun cdddr (x) (cdr (cdr (cdr x))))
(defun not (x) (eq x nil))
(defun consp (x) (not (atom x)))
(defun print (x) (prin1 x) (terpri) x)
(defun identity (x) x)
(setq
 = eql
 rem %
 null not
 setcar rplaca
 setcdr rplacd)
(defun > (x y) (< y x))
(defun >= (x y) (not (< x y)))
(defun <= (x y) (not (< y x)))
(defun /= (x y) (not (= x y)))
(defun equal (x y)
  (cond ((atom x) (eql x y))
        ((atom y) nil)
        ((equal (car x) (car y)) (equal (cdr x) (cdr y)))))
(defmacro if (test then &rest else)
  `(cond (,test ,then)
         ,@(cond (else `((t ,@else))))))
(defmacro when (test &rest body)
  `(cond (,test ,@body)))
(defmacro let (args &rest body)
  ((lambda (vars vals)
     (defun vars (x)
       (cond (x (cons (if (atom (car x))
                          (car x)
                        (caar x))
                      (vars (cdr x))))))
     (defun vals (x)
       (cond (x (cons (if (atom (car x))
                          nil
                        (cadar x))
                      (vals (cdr x))))))
     `((lambda ,(vars args) ,@body) ,@(vals args)))
   nil nil))
(defmacro letrec (args &rest body)      ; (letrec ((v e) ...) body...)
  (let (vars setqs)
    (defun vars (x)
      (cond (x (cons (caar x)
                     (vars (cdr x))))))
    (defun sets (x)
      (cond (x (cons `(setq ,(caar x) ,(cadar x))
                     (sets (cdr x))))))
    `(let ,(vars args) ,@(sets args) ,@body)))
(defun _append (x y)
  (if (null x)
      y
    (cons (car x) (_append (cdr x) y))))
(defmacro append (x &rest y)
  (if (null y)
      x
    `(_append ,x (append ,@y))))
(defmacro and (x &rest y)
  (if (null y)
      x
    `(cond (,x (and ,@y)))))
(defun mapcar (f x)
  (and x (cons (f (car x)) (mapcar f (cdr x)))))
(defmacro or (x &rest y)
  (if (null y)
      x
    `(cond (,x)
           ((or ,@y)))))
(defun listp (x)
  (or (null x) (consp x)))    ; NB (listp (lambda (x) (+ x 1))) => nil
(defun memq (key x)
  (cond ((null x) nil)
        ((eq key (car x)) x)
        (t (memq key (cdr x)))))
(defun member (key x)
  (cond ((null x) nil)
        ((equal key (car x)) x)
        (t (member key (cdr x)))))
(defun assq (key alist)
  (cond (alist (let ((e (car alist)))
                 (if (and (consp e) (eq key (car e)))
                     e
                   (assq key (cdr alist)))))))
(defun assoc (key alist)
  (cond (alist (let ((e (car alist)))
                 (if (and (consp e) (equal key (car e)))
                     e
                   (assoc key (cdr alist)))))))
(defun _nreverse (x prev)
  (let ((next (cdr x)))
    (setcdr x prev)
    (if (null next)
        x
      (_nreverse next x))))
(defun nreverse (list)            ; (nreverse '(a b c d)) => (d c b a)
  (cond (list (_nreverse list nil))))
(defun last (list)
  (if (atom (cdr list))
      list
    (last (cdr list))))
(defun nconc (&rest lists)
  (if (null (cdr lists))
      (car lists)
    (if (null (car lists))
        (apply nconc (cdr lists))
      (setcdr (last (car lists))
              (apply nconc (cdr lists)))
      (car lists))))
(defmacro while (test &rest body)
  (let ((loop (gensym)))
    `(letrec ((,loop (lambda () (cond (,test ,@body (,loop))))))
       (,loop))))
(defmacro dolist (spec &rest body) ; (dolist (name list [result]) body...)
  (let ((name (car spec))
        (list (gensym)))
    `(let (,name
           (,list ,(cadr spec)))
       (while ,list
         (setq ,name (car ,list))
         ,@body
         (setq ,list (cdr ,list)))
       ,@(if (cddr spec)
             `((setq ,name nil)
               ,(caddr spec))))))
(defmacro dotimes (spec &rest body) ; (dotimes (name count [result]) body...)
  (let ((name (car spec))
        (count (gensym)))
    `(let ((,name 0)
           (,count ,(cadr spec)))
       (while (< ,name ,count)
         ,@body
         (setq ,name (+ ,name 1)))
       ,@(if (cddr spec)
             `(,(caddr spec))))))
""";

/*
  Copyright (c) 2015, 2016 OKI Software Co., Ltd.
  Copyright (c) 2018, 2019 SUZUKI Hisao
  Permission is hereby granted, free of charge, to any person obtaining a
  copy of this software and associated documentation files (the "Software"),
  to deal in the Software without restriction, including without limitation
  the rights to use, copy, modify, merge, publish, distribute, sublicense,
  and/or sell copies of the Software, and to permit persons to whom the
  Software is furnished to do so, subject to the following conditions:
  The above copyright notice and this permission notice shall be included in
  all copies or substantial portions of the Software.
  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
  THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
  DEALINGS IN THE SOFTWARE.
*/