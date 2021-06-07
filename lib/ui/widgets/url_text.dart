import 'package:custed2/constants.dart';
import 'package:custed2/core/open.dart';
import 'package:custed2/core/utils.dart';
import 'package:custed2/ui/theme.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class UrlText extends StatelessWidget {

  final String text;
  final String replace;
  final TextStyle style;

  UrlText(this.text, {this.replace, this.style});

  List<InlineSpan> _getTextSpans(TextStyle textStyle, TextStyle urlStyle) {
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
          style: urlStyle
        ));
      } else {
        widgets.add(TextSpan(text: result.text, style: textStyle));
      }
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    final highLightColor = resolveWithBackground(context);
    final urlStyle = style?.copyWith(color: highLightColor) ?? TextStyle(
      color: highLightColor
    );
    final textStyle = style?.copyWith(
      color: isDark(context) ? Colors.white : Colors.black
    ) ?? Theme.of(context).textTheme.bodyText2;
    return RichText(
      text: TextSpan(children: _getTextSpans(textStyle, urlStyle)),
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