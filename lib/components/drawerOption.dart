import 'package:flutter/material.dart';

class DrawerOption extends StatelessWidget {
  const DrawerOption({Key? key, this.text, this.icon, this.onTap,})
      : super(key: key);

  final text;
  final icon;
  final onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      textColor: Color(0xFF184045),
      leading: Icon(
        icon,
        color: Color(0xFF184045),
      ),
      title: Text('$text'),
      onTap: onTap,
    );
  }
}
