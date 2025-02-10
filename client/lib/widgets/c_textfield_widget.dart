// Custom_TextField

import 'package:flutter/material.dart';

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
      this.enableBorder = true});
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
  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    ColorScheme color = Theme.of(context).colorScheme;
    return Container(
      padding: widget.padding,
      margin: widget.margin,
      child: TextField(
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
                          color: color.inversePrimary,
                        )
                      : Icon(
                          Icons.remove_red_eye_sharp,
                          color: color.inversePrimary,
                        ))
              : const SizedBox.shrink(),
          prefixIcon: widget.icon,
          prefixIconColor: color.inversePrimary,
          labelText: widget.labeltext,
          labelStyle: TextStyle(color: color.inversePrimary, fontSize: 20),
          hintText: widget.hinttext,
          hintStyle: TextStyle(
              fontWeight: FontWeight.w200),
        ),
      ),
    );
  }
}
