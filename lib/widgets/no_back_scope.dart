import 'package:flutter/material.dart';

/// Widget que previene la navegación hacia atrás cuando [allowBack] es false
class NoBackScope extends StatefulWidget {
  final Widget child;
  final bool allowBack;
  final String? message;

  const NoBackScope({
    super.key,
    required this.child,
    required this.allowBack,
    this.message,
  });

  @override
  State<NoBackScope> createState() => _NoBackScopeState();
}

class _NoBackScopeState extends State<NoBackScope> {
  @override
  Widget build(BuildContext context) {
    if (widget.allowBack) {
      return widget.child;
    }

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop && widget.message != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(widget.message!),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      },
      child: widget.child,
    );
  }
}
