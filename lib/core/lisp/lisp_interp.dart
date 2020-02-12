import 'dart:io';

import 'package:custed2/core/lisp/lisp_arg.dart';
import 'package:custed2/core/lisp/lisp_builtin_func.dart';
import 'package:custed2/core/lisp/lisp_cell.dart';
import 'package:custed2/core/lisp/lisp_closure.dart';
import 'package:custed2/core/lisp/lisp_defined_func.dart';
import 'package:custed2/core/lisp/lisp_exceptions.dart';
import 'package:custed2/core/lisp/lisp_keyword.dart';
import 'package:custed2/core/lisp/lisp_lambda.dart';
import 'package:custed2/core/lisp/lisp_macro.dart';
import 'package:custed2/core/lisp/lisp_module.dart';
import 'package:custed2/core/lisp/lisp_output_sink.dart';
import 'package:custed2/core/lisp/lisp_reader_sync.dart';
import 'package:custed2/core/lisp/lisp_sym.dart';
import 'package:custed2/core/lisp/lisp_util.dart';
import 'package:custed2/core/lisp/symbols.dart';
import 'package:custed2/core/lisp_module/module.dart';

/// Common function type which represents any factory method of DefinedFunc
typedef LispDefinedFunc LispFuncFactory(int cariy, LispCell body, LispCell env);

/// Core of the interpreter
class LispInterp {
  /// Table of the global values of symbols
  final Map<LispSym, Object> globals = {};

  /// Table of registered modules
  final Map<String, LispModule> modules = {};

  /// Standard output of the interpreter
  StringSink cout = LispOutputSink(print);

  /// Sets built-in functions etc. as the global values of symbols.
  LispInterp() {
    def("car", 1, (List a) => (a[0] as LispCell)?.car);
    def("cdr", 1, (List a) => (a[0] as LispCell)?.cdr);
    def("cons", 2, (List a) => LispCell(a[0], a[1]));
    def("atom", 1, (List a) => (a[0] is LispCell) ? null : true);
    def("eq", 2, (List a) => identical(a[0], a[1]) ? true : null);

    def("list", -1, (List a) => a[0]);
    def("rplaca", 2, (List a) {
      a[0].car = a[1];
      return a[1];
    });
    def("rplacd", 2, (List a) {
      a[0].cdr = a[1];
      return a[1];
    });
    def("length", 1, (List a) => (a[0] == null) ? 0 : a[0].length);
    def("stringp", 1, (List a) => (a[0] is String) ? true : null);
    def("numberp", 1, (List a) => LispUtil.isNumber(a[0]) ? true : null);
    def("eql", 2, (List a) {
      var x = a[0];
      var y = a[1];
      return (x == y)
          ? true
          : (LispUtil.isNumber(x) &&
                  LispUtil.isNumber(y) &&
                  LispUtil.compare(x, y) == 0)
              ? true
              : null;
    });
    def("<", 2, (List a) => (LispUtil.compare(a[0], a[1]) < 0) ? true : null);
    def("%", 2, (List a) => LispUtil.remainder(a[0], a[1]));
    def("mod", 2, (List a) {
      var x = a[0];
      var y = a[1];
      var q = LispUtil.remainder(x, y);
      return (LispUtil.compare(LispUtil.multiply(x, y), 0) < 0)
          ? LispUtil.add(q, y)
          : q;
    });

    def("+", -1,
        (List a) => LispUtil.foldl(0, a[0], (i, j) => LispUtil.add(i, j)));
    def("*", -1,
        (List a) => LispUtil.foldl(1, a[0], (i, j) => LispUtil.multiply(i, j)));
    def("-", -2, (List a) {
      var x = a[0];
      LispCell y = a[1];
      return (y == null)
          ? -x
          : LispUtil.foldl(x, y, (i, j) => LispUtil.subtract(i, j));
    });
    def(
        "/",
        -3,
        (List a) => LispUtil.foldl(LispUtil.divide(a[0], a[1]), a[2],
            (i, j) => LispUtil.divide(i, j)));

    def("truncate", -2, (List a) {
      var x = a[0];
      LispCell y = a[1];
      return (y == null)
          ? LispUtil.quotient(x, 1)
          : (y.cdr == null)
              ? LispUtil.quotient(x, y.car)
              : throw "one or two arguments expected";
    });

    def("prin1", 1, (List a) {
      cout.write(LispUtil.str(a[0], true));
      return a[0];
    });
    def("princ", 1, (List a) {
      cout.write(LispUtil.str(a[0], false));
      return a[0];
    });
    def("terpri", 0, (List a) {
      cout.writeln();
      return true;
    });

    var gensymCounterSym = LispSym("*gensym-counter*");
    globals[gensymCounterSym] = 1;
    def("gensym", 0, (List a) {
      int i = globals[gensymCounterSym];
      globals[gensymCounterSym] = i + 1;
      return LispSym.internal("G$i");
    });

    def("make-symbol", 1, (List a) => LispSym.internal(a[0]));
    def("intern", 1, (List a) => LispSym(a[0]));
    def("symbol-name", 1, (List a) => (a[0] as LispSym).name);

    def("apply", 2, (List a) async {
      return eval(
          LispCell(a[0], await LispUtil.mapcar(a[1], LispUtil.qqQuote)), null);
    });

    def("exit", 1, (List a) => exit(a[0]));
    def("dump", 0,
        (List a) => globals.keys.fold(null, (x, y) => LispCell(y, x)));
    globals[LispSym("*version*")] =
        LispCell(2.000, LispCell("Dart", LispCell("Nukata Lisp", null)));
    // named after Tōkai-dō Mikawa-koku Nukata-gun (東海道 三河国 額田郡)
  }

  /// Defines a built-in function by giving a name, an arity, and a body.
  void def(String name, int carity, LispBuiltInFuncBody body) {
    if (globals.containsKey(LispSym(name))) {
      cout.writeln('[warning] duplicated define: $name');
    }
    globals[LispSym(name)] = LispBuiltInFunc(name, carity, body);
  }

  /// Register a module referred as [name].
  /// if [autoLoad] is true the module will be immidiately avaliable
  /// without explicit require
  LispModule register(String name, LModule Function(LispInterp) builder) {
    return modules[name] = LispModule(this, builder);
  }

  Future<bool> require(String name) async {
    if (name == null) throw LispEvalException('name expected', name);
    final module = modules[name];
    if (module == null) throw LispEvalException('no such module', name);
    return await module.load();
  }

  Future evalString(String str, LispCell env) async {
    var reader = LispReaderSync(str.split('\n').iterator);
    var result;
    for (;;) {
      var sExp = reader.read();
      if (sExp == #EOF) return result;
      result = await eval(sExp, null);
    }
  }

  /// Evaluates a Lisp expression in an environment.
  Future eval(x, LispCell env) async {
    try {
      for (;;) {
        if (x is LispArg) {
          return x.getValue(env);
        } else if (x is LispSym) {
          if (globals.containsKey(x)) return globals[x];
          throw LispEvalException("void variable", x);
        } else if (x is LispCell) {
          var fn = x.car;
          LispCell arg = LispUtil.cdrCell(x);
          if (fn is LispKeyword) {
            if (fn == Symbols.quote) {
              if (arg != null && arg.cdr == null) return arg.car;
              throw LispEvalException("bad quote", x);
            } else if (fn == Symbols.progn) {
              x = await _evalProgN(arg, env);
            } else if (fn == Symbols.cond) {
              x = await _evalCond(arg, env);
            } else if (fn == Symbols.setq) {
              return await _evalSetQ(arg, env);
            } else if (fn == Symbols.lambda) {
              return _compile(arg, env, LispClosure.make);
            } else if (fn == Symbols.macro) {
              if (env != null) throw LispEvalException("nested macro", x);
              return _compile(arg, null, LispMacro.make);
            } else if (fn == Symbols.require) {
              return await _handleRequire(arg, env);
            } else if (fn == Symbols.quasiquote) {
              if (arg != null && arg.cdr == null) {
                x = LispUtil.qqExpand(arg.car);
              } else {
                throw LispEvalException("bad quasiquote", x);
              }
            } else {
              throw LispEvalException("bad keyword", fn);
            }
          } else {
            // Application of a function
            // Expands fn = eval(fn, env) here on Sym for speed.
            if (fn is LispSym) {
              fn = globals[fn];
              if (fn == null) throw LispEvalException("undefined", x.car);
            } else {
              fn = await eval(fn, env);
            }

            if (fn is LispClosure) {
              env = await fn.makeEnv(this, arg, env);
              x = await _evalProgN(fn.body, env);
            } else if (fn is LispMacro) {
              x = await fn.expandWith(this, arg);
            } else if (fn is LispBuiltInFunc) {
              return await fn.evalWith(this, arg, env);
            } else {
              throw LispEvalException("not applicable", fn);
            }
          }
        } else if (x is LispLambda) {
          return LispClosure.from(x, env);
        } else {
          return x; // numbers, strings, null etc.
        }
      }
    } on LispEvalException catch (ex) {
      if (ex.trace.length < 10) ex.trace.add(LispUtil.str(x));
      rethrow;
    }
  }

  /// (progn E1 E2.. En) => Evaluates E1, E2, .. except for En and returns it.
  Future _evalProgN(LispCell j, LispCell env) async {
    if (j == null) return null;
    for (;;) {
      var x = j.car;
      j = LispUtil.cdrCell(j);
      if (j == null) {
        return x; // The tail expression will be evaluated at the caller.
      }
      await eval(x, env);
    }
  }

  /// Evaluates a conditional expression and returns the selection unevaluated.
  Future _evalCond(LispCell j, LispCell env) async {
    for (; j != null; j = LispUtil.cdrCell(j)) {
      var clause = j.car;
      if (clause is LispCell) {
        var result = await eval(clause.car, env);
        if (result != null) {
          // If the condition holds
          LispCell body = LispUtil.cdrCell(clause);
          if (body == null) {
            return LispUtil.qqQuote(result);
          } else {
            return await _evalProgN(body, env);
          }
        }
      } else if (clause != null) {
        throw LispEvalException("cond test expected", clause);
      }
    }
    return null; // No clause holds.
  }

  /// (setq V1 E1 ..) => Evaluates Ei and assigns it to Vi; returns the last.
  Future _evalSetQ(LispCell j, LispCell env) async {
    var result;
    for (; j != null; j = LispUtil.cdrCell(j)) {
      var lval = j.car;
      j = LispUtil.cdrCell(j);
      if (j == null) throw LispEvalException("right value expected", lval);
      result = await eval(j.car, env);
      if (lval is LispArg) {
        lval.setValue(result, env);
      } else if (lval is LispSym && lval is! LispKeyword) {
        globals[lval] = result;
      } else {
        throw LispNotVariableException(lval);
      }
    }
    return result;
  }

  /// Compiles a Lisp list (macro ...) or (lambda ...).
  Future<LispDefinedFunc> _compile(
      LispCell arg, LispCell env, LispFuncFactory make) async {
    if (arg == null) throw LispEvalException("arglist and body expected", arg);
    Map<LispSym, LispArg> table = {};
    bool hasRest = LispUtil.makeArgTable(arg.car, table);
    int arity = table.length;
    LispCell body = LispUtil.cdrCell(arg);
    body = await LispUtil.scanForArgs(body, table);
    body = await _expandMacros(
        body, 20); // Expands ms statically up to 20 nestings.
    body = await _compileInners(body);
    return make((hasRest) ? -arity : arity, body, env);
  }

  /// Expands macros and quasi-quotations in an expression.
  _expandMacros(j, int count) async {
    if (count > 0 && j is LispCell) {
      var k = j.car;
      if (k == Symbols.quote || k == Symbols.lambda || k == Symbols.macro) {
        return j;
      } else if (k == Symbols.quasiquote) {
        LispCell d = LispUtil.cdrCell(j);
        if (d != null && d.cdr == null) {
          var z = LispUtil.qqExpand(d.car);
          return _expandMacros(z, count);
        }
        throw LispEvalException("bad quasiquote", j);
      } else {
        if (k is LispSym) k = globals[k]; // null if k does not have a value
        if (k is LispMacro) {
          LispCell d = LispUtil.cdrCell(j);
          var z = await k.expandWith(this, d);
          return _expandMacros(z, count - 1);
        } else {
          return await LispUtil.mapcar(j, (x) => _expandMacros(x, count));
        }
      }
    } else {
      return j;
    }
  }

  /// Replaces inner lambda-expressions with Lambda instances.
  _compileInners(j) async {
    if (j is LispCell) {
      var k = j.car;
      if (k == Symbols.quote) {
        return j;
      } else if (k == Symbols.lambda) {
        LispCell d = LispUtil.cdrCell(j);
        return _compile(d, null, LispLambda.make);
      } else if (k == Symbols.macro) {
        throw LispEvalException("nested macro", j);
      } else {
        return await LispUtil.mapcar(j, (x) => _compileInners(x));
      }
    } else {
      return j;
    }
  }

  _handleRequire(LispCell j, LispCell env) async {
    final name = j?.car?.toString();
    return require(name);
  }
}
