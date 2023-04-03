import 'package:flutter/material.dart';

class ReusableCard extends StatelessWidget {
  const ReusableCard({Key? key, required this.child, required this.onTap})
      : super(key: key);

  /*final IconData icon;
  final String text;*/
  final Function onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      enableFeedback: true,
      onTap: () {
        onTap();
      },
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          margin: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: Color(0xE8184045),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: child),
    );
  }
}
/*Column(
          children: [
            Icon(
              icon,
              size: 50.0,
              color: Colors.white,
            ),
            const SizedBox(
              height: 20.0,
            ),
            Text(
              /*'Calculate BMI'*/
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),*/
