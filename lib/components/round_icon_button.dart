import 'package:flutter/material.dart';

class RoundIconButton extends StatelessWidget {
  const RoundIconButton({Key? key, required this.icon, required this.onTap})
      : super(key: key);

  final IconData icon;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: () {
        onTap();
      },
      shape: const CircleBorder(),
      fillColor: const Color(0xFFFFFFFF),
      constraints: const BoxConstraints.tightFor(
        width: 46.0,
        height: 46.0,
      ),
      elevation: 6.0,
      child: Icon(
        icon,
        color: Color(0xFF184045),
        size: 20.0,
      ),
    );
  }
}
