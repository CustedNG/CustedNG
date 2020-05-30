import 'package:custed2/ui/theme.dart';
import 'package:flutter/cupertino.dart';

class AddLessonField extends StatelessWidget {
  AddLessonField(
    this.icon, {
    this.placeholder,
    this.isPrimary = false,
    this.isReadonly = false,
    this.controller,
    this.onTap,
  });

  final IconData icon;
  final String placeholder;
  final bool isPrimary;
  final bool isReadonly;
  final TextEditingController controller;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final iconColor =
        isPrimary ? theme.primaryColor : CupertinoColors.inactiveGray;

    return CupertinoTextField(
      readOnly: isReadonly,
      controller: controller,
      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
      placeholder: placeholder,
      autocorrect: false,
      prefix: Padding(
        padding: EdgeInsets.only(left: 12.0),
        child: Icon(icon, size: 24.0, color: iconColor),
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: theme.textFieldBorderColor,
          ),
        ),
        color: theme.textFieldBackgroundColor,
      ),
      onTap: onTap,
    );
  }
}
