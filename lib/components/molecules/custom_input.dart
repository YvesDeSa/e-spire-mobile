import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class CustomInput extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String hintText;
  final IconData icon;
  final bool isPassword;
  final bool obscureText;
  final VoidCallback? onToggleObscure;
  final String? errorText;
  final String? successText;
  final Function(String)? onChanged;

  const CustomInput({
    Key? key,
    required this.controller,
    required this.focusNode,
    required this.hintText,
    required this.icon,
    this.isPassword = false,
    this.obscureText = false,
    this.onToggleObscure,
    this.errorText,
    this.successText,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool hasTextOrFocus = focusNode.hasFocus || controller.text.isNotEmpty;
    bool hasError = errorText != null;
    bool hasSuccess = successText != null;

    Color currentColor;
    if (hasError) currentColor = AppColors.primary;
    else if (hasSuccess) currentColor = AppColors.success;
    else if (hasTextOrFocus) currentColor = AppColors.primary;
    else currentColor = AppColors.textHint;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10, offset: Offset(0, 4))
            ],
          ),
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            obscureText: isPassword ? obscureText : false,
            onChanged: onChanged,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            cursorColor: hasSuccess ? AppColors.success : AppColors.primary,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.surface.withOpacity(0.8),
              hintText: hintText,
              hintStyle: TextStyle(color: AppColors.textHint),
              errorText: null, 
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 10.0),
                child: Icon(icon, color: currentColor, size: 22),
              ),
              suffixIcon: isPassword
                  ? Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: IconButton(
                        icon: Icon(
                          obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                          color: AppColors.textHint,
                        ),
                        onPressed: onToggleObscure,
                      ),
                    )
                  : null,
              contentPadding: const EdgeInsets.symmetric(vertical: 20),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: BorderSide(
                  color: hasError ? AppColors.primary : (hasSuccess ? AppColors.success : AppColors.border),
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: BorderSide(
                  color: hasError ? AppColors.primary : (hasSuccess ? AppColors.success : AppColors.primary.withOpacity(0.5)),
                  width: 2,
                ),
              ),
            ),
          ),
        ),
        if (hasError || hasSuccess)
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 24.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  hasError ? Icons.error_outline : Icons.check_circle_outline,
                  color: hasError ? AppColors.primary : AppColors.success,
                  size: 14,
                ),
                const SizedBox(width: 6),
                Text(
                  hasError ? errorText! : successText!,
                  style: TextStyle(
                    color: hasError ? AppColors.primary : AppColors.success,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}