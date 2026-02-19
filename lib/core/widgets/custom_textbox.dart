import 'package:ausy/core/themes/app_colors.dart';
import 'package:flutter/material.dart';

class CustomTextBox extends StatelessWidget {
  const CustomTextBox({
    super.key,
    this.hint = "",
    this.prefix,
    this.suffix,
    this.controller,
    this.onSubmitted,
    this.onTap,
    this.readOnly = false,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.validator,
  });

  final String hint;
  final Widget? prefix;
  final Widget? suffix;
  final bool readOnly;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final TextEditingController? controller;
  final Function(String)? onSubmitted;
  final Function()? onTap;


  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(bottom: 4, top: 4),
      decoration: BoxDecoration(
        color: AppColor.textBoxColor,
        border: Border.all(color: AppColor.textBoxColor),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: AppColor.shadowColor.withValues(alpha: 0.1),
            spreadRadius: .5,
            blurRadius: .5,
          ),
        ],
      ),
      child: TextFormField(
        textInputAction: textInputAction,
        keyboardType: keyboardType,
        obscureText: obscureText,
        readOnly: readOnly,
        controller: controller,
        validator: validator,
        onFieldSubmitted: onSubmitted,
        onTap: onTap,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(top: 4),
          prefixIcon: prefix,
          suffixIcon: suffix,
          border: InputBorder.none,
          hintText: hint,
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
