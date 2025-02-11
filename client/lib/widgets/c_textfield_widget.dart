// Custom_TextField

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nexdoor/core/theme/color_pallete.dart';

// ignore: must_be_immutable
class CustomTextField extends StatefulWidget {
  CustomTextField(
      {super.key,
      this.isPassword = false,
      required this.controller,
      this.labeltext = "",
      this.hinttext = "",
      this.icon,
      this.textInputAction,
      this.padding = const EdgeInsets.all(0),
      this.margin = const EdgeInsets.all(0),
      this.isobscure = false,
      this.editMode = true,
      this.enableBorder = true, this.keyboardType, this.maxLength});
  final String labeltext;
  final String hinttext;
  bool isPassword;
  bool isobscure;
  bool enableBorder;
  bool editMode;
  TextInputAction? textInputAction;
  final TextEditingController controller;
  final Icon? icon;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final TextInputType? keyboardType;
  final int? maxLength;
  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: widget.padding,
      margin: widget.margin,
      child: TextField(
        maxLength: widget.maxLength,
        maxLengthEnforcement:MaxLengthEnforcement.enforced,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction ?? TextInputAction.next,
        readOnly: !widget.editMode,
        controller: widget.controller,
        obscureText: widget.isobscure,
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: widget.isPassword
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      widget.isobscure = !widget.isobscure;
                    });
                  },
                  icon: widget.isobscure
                      ? Icon(
                          Icons.remove_red_eye_outlined,
                        )
                      : Icon(
                          Icons.remove_red_eye_sharp,
                        ))
              : const SizedBox.shrink(),
          prefixIcon: widget.icon,
          labelText: widget.labeltext,
          labelStyle: TextStyle( fontSize: 20),
          hintText: widget.hinttext,
          hintStyle: TextStyle(fontSize: 14,
              fontWeight: FontWeight.w100,color: ColorPalette.accentColor.withAlpha(100)),
        ),
      ),
    );
  }
}
