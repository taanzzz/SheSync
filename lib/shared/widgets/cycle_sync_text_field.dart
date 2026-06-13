import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';

class CycleSyncTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final String? errorText;
  final bool isSuccess;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final bool showToggleObscure;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;

  const CycleSyncTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.errorText,
    this.isSuccess = false,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.showToggleObscure = false,
    this.keyboardType,
    this.validator,
    this.onChanged,
  });

  @override
  State<CycleSyncTextField> createState() => _CycleSyncTextFieldState();
}

class _CycleSyncTextFieldState extends State<CycleSyncTextField> {
  late bool _obscured;
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _obscured = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        FocusScope(
          onFocusChange: (focus) => setState(() => _focused = focus),
          child: TextFormField(
            controller: widget.controller,
            obscureText: _obscured,
            keyboardType: widget.keyboardType,
            validator: widget.validator,
            onChanged: widget.onChanged,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              color: AppColors.textDark,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.inputFill,
              hintText: widget.hint,
              hintStyle: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                color: AppColors.textLight,
              ),
              labelText: widget.label,
              labelStyle: TextStyle(
                fontFamily: 'Poppins',
                fontSize: _focused ? 11 : 13,
                color: _focused ? AppColors.crimsonHeart : AppColors.textLight,
              ),
              floatingLabelStyle: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 11,
                color: AppColors.crimsonHeart,
              ),
              prefixIcon: widget.prefixIcon != null
                  ? Icon(
                      widget.prefixIcon,
                      color: _focused
                          ? AppColors.crimsonHeart
                          : AppColors.roseBlush,
                      size: 20,
                    )
                  : null,
              suffixIcon: widget.isSuccess
                  ? const Icon(
                      Icons.check_circle,
                      color: AppColors.success,
                      size: 20,
                    )
                  : widget.showToggleObscure
                  ? IconButton(
                      icon: Icon(
                        _obscured ? Icons.visibility_off : Icons.visibility,
                        color: AppColors.textLight,
                        size: 20,
                      ),
                      onPressed: () => setState(() => _obscured = !_obscured),
                    )
                  : widget.suffixIcon,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                borderSide: const BorderSide(
                  color: AppColors.crimsonHeart,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                borderSide: const BorderSide(color: AppColors.error),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 18,
              ),
              errorStyle: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 11,
                color: AppColors.error,
              ),
            ),
          ),
        ),
        if (widget.errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: Text(
              widget.errorText!,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 11,
                color: AppColors.error,
              ),
            ),
          ),
      ],
    );
  }
}
