import 'package:flutter/material.dart';

import '../constants.dart';

class DefaultButton extends StatelessWidget {
  const DefaultButton({
    Key? key,
    this.text,
    required this.press, required this.backcolor, required this.fontSize, required this.button_width, this.circle,
  }) : super(key: key);
  final String? text;
  final Widget? circle;
  final Function press;
  final Color backcolor;
   final double fontSize;
  final double button_width;



  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: button_width,
      height: 56,
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: Colors.white, shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: backcolor,
        ),
        onPressed: press as void Function()?,
        child: Text(
          text!,
          style: TextStyle(
              fontFamily: 'Cairo' ,
              fontSize: fontSize,
              color: Colors.white,
              fontWeight: FontWeight.w400
          ),
        ),
      ),
    );
  }
}
