import 'package:flutter/material.dart';
import 'package:flutter_app_dvp/utils/constants.dart';

class CustomInput extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final TextInputType? keyboardType;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixIconPressed;
  final bool isPassword;
  final bool isRequired;
  final String? Function(String?)? validator;

  const CustomInput({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.keyboardType,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconPressed,
    this.isPassword = false,
    this.isRequired = true,
    this.validator,
  });

  @override
  State<CustomInput> createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInput> {
  bool _isFocused = false;
  bool _obscureText = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label con indicador de requerido
        Row(
          children: [
            Text(
              widget.label,
              style: AppTextStyles.label.copyWith(
                color: _isFocused ? primaryColor : textSecondaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (widget.isRequired) ...[
              const SizedBox(width: AppSpacing.xs),
              Text(
                '*',
                style: AppTextStyles.label.copyWith(
                  color: errorColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: AppSpacing.sm),

        // Campo de entrada moderno
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            boxShadow:
                _isFocused
                    ? [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.1),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                    : [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
          ),
          child: Focus(
            onFocusChange: (hasFocus) {
              setState(() {
                _isFocused = hasFocus;
              });
            },
            child: TextFormField(
              controller: widget.controller,
              keyboardType: widget.keyboardType,
              obscureText: _obscureText,
              validator:
                  widget.validator ??
                  (value) =>
                      widget.isRequired && (value?.isEmpty ?? true)
                          ? 'Este campo es requerido'
                          : null,
              style: AppTextStyles.bodyMedium.copyWith(
                color: textPrimaryColor,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: widget.hint,
                hintStyle: AppTextStyles.bodyMedium.copyWith(
                  color: textMutedColor,
                ),

                // Iconos
                prefixIcon:
                    widget.prefixIcon != null
                        ? Container(
                          margin: const EdgeInsets.only(right: AppSpacing.sm),
                          child: Icon(
                            widget.prefixIcon,
                            color: _isFocused ? primaryColor : textMutedColor,
                            size: 20,
                          ),
                        )
                        : null,

                suffixIcon:
                    widget.isPassword
                        ? IconButton(
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: _isFocused ? primaryColor : textMutedColor,
                            size: 20,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        )
                        : widget.suffixIcon != null
                        ? IconButton(
                          icon: Icon(
                            widget.suffixIcon,
                            color: _isFocused ? primaryColor : textMutedColor,
                            size: 20,
                          ),
                          onPressed: widget.onSuffixIconPressed,
                        )
                        : null,

                // Bordes y colores
                filled: true,
                fillColor: _isFocused ? cardColor : surfaceColor,

                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.md + 2,
                ),

                // Bordes
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  borderSide: const BorderSide(color: borderColor, width: 1.5),
                ),

                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  borderSide: const BorderSide(color: borderColor, width: 1.5),
                ),

                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  borderSide: const BorderSide(
                    color: borderFocusColor,
                    width: 2,
                  ),
                ),

                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  borderSide: const BorderSide(
                    color: borderErrorColor,
                    width: 1.5,
                  ),
                ),

                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  borderSide: const BorderSide(
                    color: borderErrorColor,
                    width: 2,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
