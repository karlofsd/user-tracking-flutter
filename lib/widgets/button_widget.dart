import 'package:flutter/material.dart';

class Button extends FilledButton {
  Button({
    super.key,
    Widget? child,
    bool loading = false,
    super.onPressed,
    Color? color,
  }) : super(
          style: FilledButton.styleFrom(
              backgroundColor: color,
              fixedSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16))),
          child: loading
              ? Center(
                  child: CircularProgressIndicator(
                  color: ThemeData.light().colorScheme.onPrimary,
                ))
              : child,
        );

  Button.expanded(
      {Key? key,
      required Widget child,
      VoidCallback? onPressed,
      bool loading = false})
      : this(
            key: key,
            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              child: child,
            ),
            onPressed: onPressed,
            loading: loading);
}
