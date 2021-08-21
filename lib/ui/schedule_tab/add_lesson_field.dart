import 'package:flutter/material.dart';

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
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: TextField(
        readOnly: isReadonly,
        controller: controller,
        autocorrect: false,
        decoration:
            InputDecoration(labelText: placeholder, prefixIcon: Icon(icon)),
        onTap: onTap,
      ),
    );
  }
}
