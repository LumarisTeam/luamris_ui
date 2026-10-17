import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter/services.dart';

import '../theme/mc_context.dart';
import '../theme/mc_radii.dart';
import '../theme/mc_smooth_corners.dart';

// =============================================================================
// McField — unified text / password field
// =============================================================================

enum _McFieldVariant { text, password }

/// A single form-field class covering text input and password (with toggle).
///
/// ```dart
/// McField.text(placeholder: '用户名', validator: ...);
/// McField.password(placeholder: '密码', validator: ...);
/// ```
class McField extends StatefulWidget {
  final _McFieldVariant _variant;

  // Shared
  final TextEditingController? controller;
  final String? placeholder;
  final FormFieldValidator<String>? validator;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;

  // Text-only
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final int maxLines;
  final Widget? prefix;
  final Widget? suffix;
  final bool obscureText;
  final int? maxLength;
  final bool autofocus;

  /// Text input field with validation.
  const McField.text({
    super.key,
    this.controller,
    this.placeholder,
    this.keyboardType,
    this.textInputAction,
    this.onFieldSubmitted,
    this.onChanged,
    this.maxLines = 1,
    this.validator,
    this.prefix,
    this.suffix,
    this.obscureText = false,
    this.maxLength,
    this.autofocus = false,
  }) : _variant = _McFieldVariant.text;

  /// Password field with built-in visibility toggle.
  const McField.password({
    super.key,
    this.controller,
    this.placeholder,
    this.validator,
    this.textInputAction,
    this.onFieldSubmitted,
    this.autofocus = false,
  }) : _variant = _McFieldVariant.password,
       keyboardType = null,
       onChanged = null,
       maxLines = 1,
       prefix = null,
       suffix = null,
       obscureText = true,
       maxLength = null;

  @override
  State<McField> createState() => _McFieldState();
}

class _McFieldState extends State<McField> {
  late final TextEditingController _controller;
  late final bool _ownsController;
  bool _obscured = true;

  @override
  void initState() {
    super.initState();
    _ownsController = widget.controller == null;
    _controller = widget.controller ?? TextEditingController();
    _obscured = widget._variant == _McFieldVariant.password;
  }

  @override
  void dispose() {
    if (_ownsController) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final m = context.mc;
    final isPassword = widget._variant == _McFieldVariant.password;

    return FormField<String>(
      initialValue: _controller.text,
      validator: widget.validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      builder: (field) {
        final borderColor = field.hasError ? m.destructive : m.border;

        // Build the visibility toggle for password fields.
        Widget? suffixWidget = widget.suffix;
        if (isPassword) {
          suffixWidget = CupertinoButton(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            onPressed: () => setState(() => _obscured = !_obscured),
            child: Icon(
              _obscured ? CupertinoIcons.eye : CupertinoIcons.eye_slash,
              size: 18,
              color: m.mutedForeground,
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DecoratedBox(
              decoration: ShapeDecoration(
                color: m.input,
                shape: McSmoothCorners.shape(
                  BorderRadius.circular(McRadii.navigation),
                  side: BorderSide(color: borderColor),
                ),
              ),
              child: CupertinoTextField(
                controller: _controller,
                placeholder: widget.placeholder,
                keyboardType: widget.keyboardType,
                textInputAction: widget.textInputAction,
                maxLines: widget.maxLines,
                autofocus: widget.autofocus,
                obscureText: isPassword ? _obscured : widget.obscureText,
                inputFormatters: widget.maxLength == null
                    ? null
                    : [LengthLimitingTextInputFormatter(widget.maxLength)],
                onChanged: (v) {
                  field.didChange(v);
                  widget.onChanged?.call(v);
                },
                onSubmitted: widget.onFieldSubmitted,
                prefix: widget.prefix == null
                    ? null
                    : Padding(
                        padding: const EdgeInsets.only(left: 14),
                        child: widget.prefix!,
                      ),
                suffix: suffixWidget == null
                    ? null
                    : Padding(
                        padding: const EdgeInsets.only(right: 14),
                        child: suffixWidget,
                      ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                decoration: null,
                style: m.textBody,
                placeholderStyle: TextStyle(
                  fontSize: 16,
                  color: m.mutedForeground,
                ),
              ),
            ),
            if (field.hasError) ...[
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Text(
                  field.errorText ?? '',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: m.destructive,
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
