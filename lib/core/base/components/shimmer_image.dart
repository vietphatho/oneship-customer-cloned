import 'package:flutter/material.dart';

class ShimmerImage extends StatefulWidget {
  final ImageProvider image;
  final double? width;
  final double? height;
  final Duration duration;

  const ShimmerImage({
    super.key,
    required this.image,
    this.width,
    this.height,
    this.duration = const Duration(milliseconds: 2500),
  });

  @override
  State<ShimmerImage> createState() => _ShimmerImageState();
}

class _ShimmerImageState extends State<ShimmerImage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _startLoop();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _startLoop() async {
    while (mounted) {
      await Future.delayed(const Duration(milliseconds: 2000)); // ⏱ delay
      if (mounted) {
        await _controller.forward(from: 0);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            final shimmerPosition = _controller.value * 2 - 1;

            return LinearGradient(
              begin: Alignment(shimmerPosition - 1, 0),
              end: Alignment(shimmerPosition + 1, 0),
              colors: [
                Colors.transparent,
                Colors.white.withOpacity(0.5),
                Colors.transparent,
              ],
              stops: const [0.3, 0.5, 0.7],
            ).createShader(bounds);
          },
          child: Image(
            image: widget.image,
            width: widget.width,
            height: widget.height,
            fit: BoxFit.contain,
          ),
        );
      },
    );
  }
}
