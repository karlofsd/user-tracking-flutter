import 'package:flutter/material.dart';

class InputText extends TextFormField {
  InputText({
    super.key,
    required String label,
    super.onChanged,
    super.validator,
    super.onSaved,
    super.initialValue,
    super.enabled,
    super.readOnly,
    super.controller,
    super.obscureText,
    super.onTap,
    super.expands,
    super.minLines,
    super.onFieldSubmitted,
    Widget? suffix,
    int? maxLines,
    String? error,
    VoidCallback? onVisible,
  }) : super(
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              suffixIcon: suffix,
              label: Text(label),
              errorText: error,
              filled: true,
              border: UnderlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            maxLines: maxLines ?? minLines ?? 1);

  InputText.password({
    Key? key,
    required String label,

    ///* Handle osbcureText state
    required VoidCallback onVisible,
    String? initialValue,
    String? error,
    String? Function(String?)? validator,
    TextEditingController? controller,
    ValueChanged<String?>? onChanged,
    ValueChanged? onSaved,
    VoidCallback? onTap,
    bool enabled = true,
    bool expands = false,
    bool obscureText = true,
  }) : this(
          key: key,
          label: label,
          initialValue: initialValue,
          controller: controller,
          onChanged: onChanged,
          onSaved: onSaved,
          onTap: onTap,
          enabled: enabled,
          expands: expands,
          obscureText: obscureText,
          onVisible: onVisible,
          error: error,
          suffix: InkWell(
              onTap: onVisible,
              child: Icon(
                obscureText ? Icons.visibility_off : Icons.visibility,
                color: obscureText ? Colors.grey : null,
              )),
        );
}

class InputPassword extends StatefulWidget {
  const InputPassword({
    super.key,
    required this.label,
    this.validator,
    this.initialValue,
    this.controller,
    this.onChanged,
    this.onSaved,
    this.onTap,
    this.enabled = true,
    this.expands = false,
    this.error,
  });

  final String label;
  final String? Function(String?)? validator;
  final String? initialValue;
  final TextEditingController? controller;
  final ValueChanged<String?>? onChanged;
  final ValueChanged? onSaved;
  final VoidCallback? onTap;
  final bool enabled;
  final bool expands;
  final String? error;

  @override
  State<InputPassword> createState() => _InputPasswordState();
}

class _InputPasswordState extends State<InputPassword> {
  late bool isVisible;

  @override
  void initState() {
    isVisible = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InputText.password(
      key: widget.key,
      label: widget.label,
      initialValue: widget.initialValue,
      controller: widget.controller,
      onChanged: widget.onChanged,
      onSaved: widget.onSaved,
      onTap: widget.onTap,
      enabled: widget.enabled,
      expands: widget.expands,
      obscureText: isVisible,
      error: widget.error,
      onVisible: handleVisibility,
    );
  }

  void handleVisibility() {
    setState(() {
      isVisible = !isVisible;
    });
  }
}
