import 'package:flutter/material.dart';

class VisibilityDetector extends StatefulWidget {
  final Key key;
  final Widget child;
  final Function(VisibilityInfo) onVisibilityChanged;

  const VisibilityDetector({
    required this.key,
    required this.child,
    required this.onVisibilityChanged,
  }) : super(key: key);

  @override
  State<VisibilityDetector> createState() => _VisibilityDetectorState();
}

class _VisibilityDetectorState extends State<VisibilityDetector> {
  bool _hasNotified = false;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_hasNotified) {
        _hasNotified = true;
        widget.onVisibilityChanged(VisibilityInfo(visibleFraction: 1.0));
      }
    });
    return widget.child;
  }
}

class VisibilityInfo {
  final double visibleFraction;
  VisibilityInfo({required this.visibleFraction});
}