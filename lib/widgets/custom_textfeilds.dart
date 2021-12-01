import 'package:flutter/material.dart';
import 'package:phone_lap/helpers/size_config.dart';

import '../theme.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final Widget? child;
  // ignore: avoid_field_initializers_in_const_classes
  final TextInputType? textInputType;
  final IconData? icon;
  const CustomTextField({
    Key? key,
    this.controller,
    this.labelText,
    this.hintText,
    this.textInputType,
    this.child,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(20),
          vertical: getProportionateScreenHeight(20)),
      child: TextField(
        keyboardType: textInputType ?? TextInputType.text,
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          prefixIcon: icon != null ? Icon(icon) : null,
          suffixIcon: child,
          enabled: child == null,
          labelStyle: const TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide:
                  const BorderSide(color: MyColors.primaryColor, width: 2)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide:
                  const BorderSide(color: MyColors.primaryColor, width: 2)),
          disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide:
                  const BorderSide(color: MyColors.primaryColor, width: 2)),
        ),
      ),
    );
  }
}
