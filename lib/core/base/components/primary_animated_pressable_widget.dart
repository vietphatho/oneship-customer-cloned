import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PrimaryAnimatedPressableWidget extends StatefulWidget {
  const PrimaryAnimatedPressableWidget({
    super.key,
    required this.child,
    this.onTap,
    this.scale = 0.95,
    this.downDuration = const Duration(milliseconds: 120),
    this.upDuration = const Duration(milliseconds: 120),
    this.curve = Curves.easeOut,
    this.enableFeedback = true,
  });

  final Widget child;
  final VoidCallback? onTap;
  final double scale;
  final Duration downDuration;
  final Duration upDuration;
  final Curve curve;
  final bool enableFeedback;

  @override
  State<PrimaryAnimatedPressableWidget> createState() =>
      _CustomAnimatedPressableWidgetState();
}

class _CustomAnimatedPressableWidgetState
    extends State<PrimaryAnimatedPressableWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: widget.downDuration,
      reverseDuration: widget.upDuration,
    );
    _anim = Tween<double>(
      begin: 1.0,
      end: widget.scale,
    ).animate(CurvedAnimation(parent: _ctrl, curve: widget.curve));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) {
    if (widget.enableFeedback) {
      HapticFeedback.selectionClick();
    }
    // start pressing animation
    _ctrl.forward();
  }

  void _onTapCancel() {
    // return immediately when cancelled
    _ctrl.reverse();
  }

  Future<void> _onTapUp(TapUpDetails _) async {
    // If user releases too fast, fast-forward to pressed state so the press is visible.
    if (!_ctrl.isCompleted) {
      // short fast-forward to make press visible even on quick taps
      await _ctrl.animateTo(
        1.0,
        duration: const Duration(milliseconds: 80),
        curve: widget.curve,
      );
    }
    // then reverse (release) and call callback after release animation
    await _ctrl.reverse();
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTapDown: _onTapDown,
      onTapCancel: _onTapCancel,
      onTapUp: _onTapUp,
      child: AnimatedBuilder(
        animation: _anim,
        builder: (context, child) {
          return Transform.scale(scale: _anim.value, child: child);
        },
        child: widget.child,
      ),
    );
  }
}
