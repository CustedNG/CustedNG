import 'package:custed2/core/lisp/lisp_cell.dart';
import 'package:custed2/core/lisp/lisp_exceptions.dart';
import 'package:custed2/core/lisp/lisp_sym.dart';
import 'package:custed2/core/lisp/lisp_util.dart';
import 'package:custed2/core/lisp/symbols.dart';

/// Reader of Lisp expressions
class LispReaderSync {
  final Iterator<String> _rf;
  var _token;
  Iterator<String> _tokens = <String>[].iterator;
  int _lineNo = 0;
  bool _erred = false;

  /// Constructs a Reader which will read Lisp expressions from a given arg.
  LispReaderSync(this._rf);

  /// Reads a Lisp expression; returns #EOF if the input runs out normally.
  Object read() {
    try {
      _readToken();
      return _parseExpression();
    } on FormatException catch (ex) {
      _erred = true;
      throw LispEvalException(
          "syntax error", "${ex.message} -- $_lineNo: ${_rf.current}", false);
    }
  }

  Object _parseExpression() {
    if (_token == Symbols.leftParen) {
      // (a b c)
      _readToken();
      return _parseListBody();
    } else if (_token == Symbols.singleQuote) {
      // 'a => (quote a)
      _readToken();
      return LispCell(Symbols.quote, LispCell(_parseExpression(), null));
    } else if (_token == Symbols.backQuote) {
      // `a => (quasiquote a)
      _readToken();
      return LispCell(Symbols.quasiquote, LispCell(_parseExpression(), null));
    } else if (_token == Symbols.comma) {
      // ,a => (unquote a)
      _readToken();
      return LispCell(Symbols.unquote, LispCell(_parseExpression(), null));
    } else if (_token == Symbols.commaAt) {
      // ,@a => (unquote-splicing a)
      _readToken();
      return LispCell(
          Symbols.unquoteSplicing, LispCell(_parseExpression(), null));
    } else if (_token == Symbols.dot || _token == Symbols.rightParen) {
      throw FormatException('unexpected "$_token"');
    } else {
      return _token;
    }
  }

  LispCell _parseListBody() {
    if (_token == #EOF) {
      throw FormatException("unexpected EOF");
    } else if (_token == Symbols.rightParen) {
      return null;
    } else {
      var e1 = _parseExpression();
      _readToken();
      var e2;
      if (_token == Symbols.dot) {
        // (a . b)
        _readToken();
        e2 = _parseExpression();
        _readToken();
        if (_token != Symbols.rightParen) {
          throw FormatException('")" expected: $_token');
        }
      } else {
        e2 = _parseListBody();
      }
      return LispCell(e1, e2);
    }
  }

  /// Reads the next token and sets it to [_token].
  _readToken() {
    while (!_tokens.moveNext() || _erred) {
      // line ends or erred last time
      _erred = false;
      _lineNo++;
      if (!_rf.moveNext()) {
        _token = #EOF;
        return;
      }
      _tokens = _tokenPat
          .allMatches(_rf.current)
          .map((Match m) => m[1])
          .where((String s) => s != null)
          .iterator;
    }
    _token = _tokens.current;
    if (_token[0] == '"') {
      String s = _token;
      int n = s.length - 1;
      if (n < 1 || s[n] != '"') throw FormatException("bad string: '$s'");
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

  /// Tries to parse a string as an int, a BigInt or a double.
  /// Returns null if [s] was not parsed successfully.
  static _tryParse(String s) {
    var r = BigInt.tryParse(s);
    return (r == null) ? double.tryParse(s) : LispUtil.normalize(r);
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
    "n": "\n",
    "r": "\r",
    "f": "\f",
    "b": "\b",
    "t": "\t",
    "v": "\v"
  };
}
