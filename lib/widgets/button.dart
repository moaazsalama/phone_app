import 'package:flutter/material.dart';
import 'package:phone_lap/helpers/size_config.dart';

class Button extends StatelessWidget {
  final String title;
  final Function() onPressed;
  final double? width;
  final double? height;
  final double? titleSize;
  final EdgeInsets? padding;
  final Color? color;
  const Button({
    Key? key,
    required this.title,
    required this.onPressed,
    this.width,
    this.height,
    this.titleSize,
    this.padding,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width == null ? null : getProportionateScreenWidth(width!),
      height: height == null ? null : getProportionateScreenWidth(height!),
      child: ElevatedButton(
          onPressed: onPressed,
          style: ButtonStyle(
              backgroundColor: color == null
                  ? null
                  : MaterialStateColor.resolveWith((states) => color!)),
          child: Padding(
            padding: padding ??
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: titleSize ?? 18, fontWeight: FontWeight.bold),
            ),
          )),
    );
  }
}
