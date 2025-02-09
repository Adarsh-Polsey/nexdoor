// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class CustomContainer extends StatefulWidget {
  const CustomContainer(
      {super.key,
      required this.child,
      this.margin = const EdgeInsets.all(5),
      this.padding = const EdgeInsets.all(0),
      this.height,
      this.width,
      this.enableAnimation = true,
      this.border,
      this.borderRadius,
      this.alignment,
      this.shape,
      this.constraints,this.bgColor});
  final Widget child;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final double? height;
  final double? width;
  final Color?  bgColor;
  final bool enableAnimation;
  final BoxBorder? border;
  final BorderRadiusGeometry? borderRadius;
  final AlignmentGeometry? alignment;
  final BoxShape? shape;
  final BoxConstraints? constraints;
  @override
  State<CustomContainer> createState() => _CustomContainerState();
}

class _CustomContainerState extends State<CustomContainer> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    ColorScheme color = Theme.of(context).colorScheme;
    return MouseRegion(
      onEnter: (event) {
        setState(() {
          isHovered = true;
        });
      },
      onExit: (event) {
        setState(() {
          isHovered = false;
        });
      },
      child: AnimatedContainer(
        constraints: widget.constraints,
        alignment: widget.alignment,
        height: widget.height,
        width: widget.width,
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
            shape: widget.shape ?? BoxShape.rectangle,
            color:widget.bgColor?? color.primary.withValues(alpha: 0.8),
            border: widget.border ??
                Border.all(color: color.inversePrimary.withValues(alpha:0.1)),
            borderRadius: widget.shape != null
                ? null
                : widget.borderRadius ?? BorderRadius.circular(3),
            boxShadow: (isHovered && widget.enableAnimation)
                ? [
                    BoxShadow(
                        color: color.inversePrimary.withValues(alpha:0.06),
                        blurRadius: 5,
                        offset: Offset(5, -5)),
                        BoxShadow(
                        color: color.inversePrimary.withValues(alpha:0.06),
                        blurRadius: 5,
                        offset: Offset(-5, 5)),
                        BoxShadow(
                        color: color.inversePrimary.withValues(alpha:0.06),
                        blurRadius: 5,
                        offset: Offset(5, 5)),
                        BoxShadow(
                        color: color.inversePrimary.withValues(alpha:0.06),
                        blurRadius: 5,
                        offset: Offset(-5, -5)),
                  ]
                : null),
        margin: widget.margin,
        padding: widget.padding,
        child: widget.child,
      ),
    );
  }
}
