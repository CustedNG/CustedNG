import 'package:custed2/res/constants.dart';
import 'package:custed2/core/open.dart';
import 'package:custed2/ui/theme.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class UrlText extends StatelessWidget {
  final String text;
  final String replace;
  final TextStyle style;

  UrlText(this.text, {this.replace, this.style = const TextStyle()});

  List<InlineSpan> _getTextSpans(bool isDarkMode) {
    List<InlineSpan> widgets = <InlineSpan>[];
    final reg = RegExp(regUrl);
    Iterable<Match> _matches = reg.allMatches(text);
    List<_ResultMatch> resultMatches = <_ResultMatch>[];
    int start = 0;

    for (Match match in _matches) {
      if (match.group(0).isNotEmpty) {
        if (start != match.start) {
          _ResultMatch result1 = _ResultMatch();
          result1.isUrl = false;
          result1.text = text.substring(start, match.start);
          resultMatches.add(result1);
        }

        _ResultMatch result2 = _ResultMatch();
        result2.isUrl = true;
        result2.text = match.group(0);
        resultMatches.add(result2);
        start = match.end;
      }
    }

    if (start < text.length) {
      _ResultMatch result1 = _ResultMatch();
      result1.isUrl = false;
      result1.text = text.substring(start);
      resultMatches.add(result1);
    }

    for (var result in resultMatches) {
      if (result.isUrl) {
        widgets.add(_LinkTextSpan(
            replace: replace ?? result.text,
            text: result.text,
            style: style.copyWith(color: Colors.blue)));
      } else {
        widgets.add(TextSpan(
            text: result.text,
            style: style.copyWith(
              color: isDarkMode ? Colors.white : Colors.black,
            )));
      }
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(children: _getTextSpans(isDark(context))),
    );
  }
}

class _LinkTextSpan extends TextSpan {
  _LinkTextSpan({TextStyle style, String text, String replace})
      : super(
            style: style,
            text: replace,
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                openUrl(text);
              });
}

class _ResultMatch {
  bool isUrl;
  String text;
}
