import 'package:custed2/config/theme.dart';
import 'package:flutter/cupertino.dart';

class PlaceholderWidget extends StatelessWidget {
  PlaceholderWidget([this.message = '施工中...']);

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Container(
      child: Center(
        child: Text(
          message,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: theme.lightTextColor,
          ),
        ),
      ),
    );
  }
}
