import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nexdoor/common/core/theme/color_pallete.dart';

class CustomField extends StatelessWidget {
  const CustomField(
      {super.key,
      this.onSaved,
      this.validator,
      this.title = "",
      this.initialValue = "",
      this.prefixIcon,
      this.readOnly = false,
      this.subtitle = "",
      this.maxLines,
      this.minLines,
      this.maxLength});
  final void Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final String title;
  final String subtitle;
  final String initialValue;
  final Widget? prefixIcon;
  final bool readOnly;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        const SizedBox(height: 5),
        TextFormField(
            maxLines: maxLines,
            maxLength: maxLength,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            minLines: minLines,
            readOnly: readOnly,
            initialValue: initialValue,
            decoration: InputDecoration(
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                      color: readOnly
                          ? ColorPalette.secondaryColor.withValues(alpha:0.4)
                          : ColorPalette.secondaryColor.withValues(alpha:0.3)
                          )),
              focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: ColorPalette.secondaryColor)),
              hintText: subtitle,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              prefixIcon: prefixIcon,
              labelStyle: const TextStyle(fontSize: 20),
              hintStyle:
                  TextStyle(color: ColorPalette.primaryText.withValues(alpha:0.3)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                      color: readOnly
                          ? ColorPalette.secondaryColor.withValues(alpha:0.4)
                          : ColorPalette.secondaryColor.withValues(alpha:0.3)
                          )),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:  const BorderSide(color: ColorPalette.secondaryColor)),
            ),
            validator: validator,
            onSaved: onSaved),
      ],
    );
  }
}
