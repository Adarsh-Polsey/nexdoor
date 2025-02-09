// Custom Button
import 'package:flutter/material.dart';
import 'package:nexdoor/widgets/c_container.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {super.key,
      required this.title,
      this.onTap,
      this.borderRadius = 10,
      this.height = 56,
      this.width = double.infinity,
      this.widget,
      this.fontSize,
      this.padding = const EdgeInsets.all(0),
      this.margin = const EdgeInsets.all(0),
      this.transparentbackgroundColor = false,
      this.border,
      this.enableAnimation = true,this.bgColor});
  final String title;
  final void Function()? onTap;
  final double borderRadius;
  final double? height;
  final double? fontSize;
  final double? width;
  final BoxBorder? border;
  final Color? bgColor;
  final Widget? widget;
  final bool transparentbackgroundColor;
  final bool enableAnimation;
  final EdgeInsets padding;
  final EdgeInsets margin;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: onTap,
      child: CustomContainer(
        bgColor:transparentbackgroundColor?null: bgColor,
        enableAnimation: enableAnimation,
        width: width,
        height: height,
        border: border ??
            Border.all(width: 1.3),
        borderRadius: BorderRadius.circular(borderRadius),
        padding: const EdgeInsets.all(0),
        margin: margin,
            child: Center(
              child: widget ??
                  Text(title,
                      style: TextStyle(
                        fontSize: fontSize,
                          fontWeight: FontWeight.w600)),
            )),
    );
  }
}
