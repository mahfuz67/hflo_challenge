import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../themes/colors.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final double? borderRadius;
  final Widget? prefixIcon;
  final String labelText;
  final String? hintText;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? textInputType;
  final int? maxLine;
  final FocusNode? focusNode;
  final EdgeInsets? contentPadding;
  final FocusNode? nextNode;
  final TextInputAction? textInputAction;
  final String? Function(String? s)? validator;
  final bool isPhoneNumber;
  final Color? fillColor;
  final TextCapitalization capitalization;
  final AutovalidateMode? autovalidateMode;
  final void Function()? onTap;
  final void Function(String s)? onChanged;
  final int? minLines;
  final void Function(String)? onSubmit;
  final int? maxCharacters;
  final String? initialValue;
  final bool enabled;

  const CustomTextFormField({
    Key? key,
    this.onSubmit,
    this.initialValue,
    this.autovalidateMode,
    this.enabled = true,
    required this.controller,
    this.maxCharacters,
    required this.labelText,
    this.borderRadius,
    this.prefixIcon,
    this.hintText,
    this.suffixIcon,
    this.textInputType,
    this.maxLine,
    this.focusNode,
    this.nextNode,
    this.isPhoneNumber = false,
    this.textInputAction,
    this.obscureText = false,
    this.capitalization = TextCapitalization.none,
    this.fillColor,
    this.onChanged,
    this.onTap,
    this.validator,
    this.contentPadding,
    this.minLines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          labelText,
          textAlign: TextAlign.start,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: AppColors.primary),
        ),
        const SizedBox(
          height: 7,
        ),
        TextFormField(
          cursorColor: AppColors.blueGrey[200],
          controller: controller,
          maxLines: maxLine,
          enabled: enabled,
          style: const TextStyle(color: Color(0xff383366), fontSize: 17),
          minLines: minLines,
          cursorHeight: 23,
          cursorRadius: const Radius.circular(15),
          textCapitalization: capitalization,
          maxLength: isPhoneNumber ? 15 : maxCharacters,
          focusNode: focusNode,
          keyboardType: textInputType ?? TextInputType.text,
          onChanged: onChanged,
          onTap: onTap,
          initialValue: initialValue,
          textInputAction: textInputAction ?? TextInputAction.next,
          onFieldSubmitted: (v) {
            textInputAction == TextInputAction.done
                ? FocusScope.of(context).consumeKeyboardToken()
                : FocusScope.of(context).requestFocus(nextNode);
            if (onSubmit != null) {
              onSubmit!(v);
            }
          },
          inputFormatters: [
            isPhoneNumber ? FilteringTextInputFormatter.digitsOnly : FilteringTextInputFormatter.singleLineFormatter,
            maxCharacters == 1 ? LengthLimitingTextInputFormatter(1) : FilteringTextInputFormatter.singleLineFormatter,
          ],
          autovalidateMode: autovalidateMode ?? AutovalidateMode.onUserInteraction,
          obscureText: obscureText,
          validator: validator,
          decoration: InputDecoration(
            counterText: '',
            prefixIcon: prefixIcon,
            hintText: hintText,
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: AppColors.white,
            isCollapsed: true,
            contentPadding: contentPadding ?? const EdgeInsets.fromLTRB(13, 16, 13, 16),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.blueGrey[100]!, width: 1.5),
              borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 8)),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red, width: 1.5),
              borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 8)),
            ),
            hintStyle: const TextStyle(fontSize: 17, color: Colors.grey),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.blueGrey[100]!, width: 1),
              borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 8)),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red, width: 1),
              borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 8)),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.blueGrey[100]!, width: 1),
              borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 8)),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.blueGrey[100]!, width: 1),
              borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 8)),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
