import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_dvp/utils/constants.dart';
import 'package:flutter_app_dvp/utils/input_validators.dart';

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
  final ValidationType? validationType;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final int? minLength;

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
    this.validationType,
    this.inputFormatters,
    this.maxLength,
    this.minLength,
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

  // Método para obtener el validador apropiado
  String? Function(String?) _getValidator() {
    if (widget.validator != null) {
      return widget.validator!;
    }

    if (widget.validationType != null) {
      switch (widget.validationType!) {
        case ValidationType.name:
          return (value) =>
              InputValidators.validateName(value, fieldName: widget.label);
        case ValidationType.text:
          return (value) => InputValidators.validateText(
            value,
            fieldName: widget.label,
            minLength: widget.minLength,
            maxLength: widget.maxLength,
          );
        case ValidationType.zipCode:
          return (value) =>
              InputValidators.validateZipCode(value, fieldName: widget.label);
        case ValidationType.number:
          return (value) =>
              InputValidators.validateNumber(value, fieldName: widget.label);
        case ValidationType.email:
          return (value) =>
              InputValidators.validateEmail(value, fieldName: widget.label);
        case ValidationType.phone:
          return (value) =>
              InputValidators.validatePhone(value, fieldName: widget.label);
        case ValidationType.custom:
          return (value) => InputValidators.validateCustom(
            value,
            fieldName: widget.label,
            required: widget.isRequired,
            minLength: widget.minLength,
            maxLength: widget.maxLength,
          );
      }
    }

    // Validador por defecto
    return (value) =>
        widget.isRequired && (value?.isEmpty ?? true)
            ? 'Este campo es requerido'
            : null;
  }

  // Método para obtener los formatters apropiados
  List<TextInputFormatter> _getInputFormatters() {
    if (widget.inputFormatters != null) {
      return widget.inputFormatters!;
    }

    if (widget.validationType != null) {
      switch (widget.validationType!) {
        case ValidationType.name:
          return InputFormatters.nameFormatter();
        case ValidationType.zipCode:
          return InputFormatters.zipCodeFormatter();
        case ValidationType.number:
          return InputFormatters.numberFormatter(maxLength: widget.maxLength);
        case ValidationType.email:
          return InputFormatters.emailFormatter();
        case ValidationType.phone:
          return InputFormatters.phoneFormatter();
        case ValidationType.text:
        case ValidationType.custom:
          return InputFormatters.textFormatter(maxLength: widget.maxLength);
      }
    }

    return [];
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
              validator: _getValidator(),
              inputFormatters: _getInputFormatters(),
              maxLength: widget.maxLength,
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
                counterText:
                    widget.maxLength != null
                        ? null
                        : '', // Ocultar contador si no hay maxLength
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
