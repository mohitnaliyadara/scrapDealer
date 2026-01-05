import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/app_colors.dart';
import '../utils/app_style.dart';

Widget customTextFiled({
  required String hintText,
  IconData? icon,
  String? label,
  bool isPassword = false,
  VoidCallback? passwordVisible,
  bool obscureText = false,
  required TextEditingController controller,
  TextInputType? textInputType,
  List<TextInputFormatter>? inputFormatters,
  int? maxChar,
  FormFieldValidator<String>? validation,
  int? maxLines,
  int ? errorMaxLine,
  bool? enable,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 15),
    child: TextFormField(
      enabled: enable ?? true,

      validator: validation,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller,
      maxLines: maxLines ?? 1,

      obscureText: obscureText,
      keyboardType: textInputType,
      maxLength: maxChar,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
              helper: Text(label ?? "",style: AppTextStyle.semiBold14(color: AppColors.redColor),),
        labelText: hintText,
        labelStyle: AppTextStyle.semiBold14(color: AppColors.darkGreyColor),
        prefixIcon: icon != null
            ? Icon(icon, color: AppColors.primaryColor)
            : null,

        suffixIcon: isPassword
            ? IconButton(
          onPressed: passwordVisible,
          icon: Icon(
            obscureText ? Icons.visibility_off : Icons.visibility,
            color: AppColors.primaryColor,
          ),
        )
            : null,

        errorMaxLines: errorMaxLine ?? 3,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primaryColor, width: 1.5),
        ),
      ),
    ),
  );
}
