import 'package:custed2/core/lisp/lisp_keyword.dart';
import 'package:custed2/core/lisp/lisp_sym.dart';

class Symbols {
  // Keywords
  static final LispSym cond = LispKeyword("cond");
  static final LispSym lambda = LispKeyword("lambda");
  static final LispSym macro = LispKeyword("macro");
  static final LispSym progn = LispKeyword("progn");
  static final LispSym quasiquote = LispKeyword("quasiquote");
  static final LispSym quote = LispKeyword("quote");
  static final LispSym setq = LispKeyword("setq");
  static final LispSym require = LispKeyword("require");
  
  static final LispSym backQuote = LispSym("`");
  static final LispSym commaAt = LispSym(",@");
  static final LispSym comma = LispSym(",");
  static final LispSym dot = LispSym(".");
  static final LispSym leftParen = LispSym("(");
  static final LispSym rightParen = LispSym(")");
  static final LispSym singleQuote = LispSym("'");
  static final LispSym append = LispSym("append");
  static final LispSym cons = LispSym("cons");
  static final LispSym list = LispSym("list");
  static final LispSym rest = LispSym("&rest");
  static final LispSym unquote = LispSym("unquote");
  static final LispSym unquoteSplicing = LispSym("unquote-splicing");

}