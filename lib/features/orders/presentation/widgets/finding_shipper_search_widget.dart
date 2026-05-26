import 'dart:math' as math;

import 'package:oneship_customer/core/base/base_import_components.dart';

class FindingShipperSearchWidget extends StatefulWidget {
  const FindingShipperSearchWidget({super.key});

  @override
  State<FindingShipperSearchWidget> createState() =>
      _FindingShipperSearchWidgetState();
}

class _FindingShipperSearchWidgetState
    extends State<FindingShipperSearchWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppDimensions.smallSpacing,
        0,
        AppDimensions.smallSpacing,
        AppDimensions.smallSpacing,
      ),
      child: SizedBox(
        height: 200,
        width: double.infinity,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: _SearchBeamPainter(progress: _controller.value),
                  ),
                ),
                const Positioned(
                  top: AppDimensions.mediumSpacing,
                  left: AppDimensions.mediumSpacing,
                  right: AppDimensions.mediumSpacing,
                  child: _SearchingShipperTitle(),
                ),
                Positioned.fill(
                  child: Center(
                    child: _SearchCenter(progress: _controller.value),
                  ),
                ),
                Positioned(
                  left: AppDimensions.largeSpacing,
                  top: 82,
                  child: _DriverPingChip(
                    progress: _controller.value,
                    delay: 0,
                  ),
                ),
                Positioned(
                  right: AppDimensions.largeSpacing,
                  top: 94,
                  child: _DriverPingChip(
                    progress: _controller.value,
                    delay: 0.34,
                  ),
                ),
                Positioned(
                  left: 72,
                  bottom: AppDimensions.largeSpacing,
                  child: _DriverPingChip(
                    progress: _controller.value,
                    delay: 0.68,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SearchingShipperTitle extends StatelessWidget {
  const _SearchingShipperTitle();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        PrimaryText(
          'finding_driver'.tr(),
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColors.neutral2,
          ),
          textAlign: TextAlign.center,
          maxLine: 1,
          overflow: TextOverflow.ellipsis,
        ),
        AppSpacing.vertical(AppDimensions.xxSmallSpacing),
        PrimaryText(
          'finding_driver_desc'.tr(),
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.neutral5,
          ),
          textAlign: TextAlign.center,
          maxLine: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _SearchCenter extends StatelessWidget {
  const _SearchCenter({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    final scale = 0.92 + math.sin(progress * math.pi * 2) * 0.08;

    return Transform.scale(
      scale: scale,
      child: Container(
        width: 58,
        height: 58,
        decoration: BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.28),
              blurRadius: 18,
              spreadRadius: 4,
            ),
          ],
        ),
        child: const Icon(
          Icons.storefront_outlined,
          color: AppColors.onPrimary,
          size: AppDimensions.largeIconSize,
        ),
      ),
    );
  }
}

class _DriverPingChip extends StatelessWidget {
  const _DriverPingChip({
    required this.progress,
    required this.delay,
  });

  final double progress;
  final double delay;

  @override
  Widget build(BuildContext context) {
    final opacity = 0.45 + _shiftedProgress * 0.55;

    return Opacity(
      opacity: opacity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppDimensions.largeBorderRadius,
          border: Border.all(color: AppColors.blue100),
          boxShadow: [
            BoxShadow(
              color: AppColors.secondary.withOpacity(0.10),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.xSmallSpacing,
            vertical: AppDimensions.xxSmallSpacing,
          ),
          child: const Icon(
            Icons.two_wheeler_outlined,
            color: AppColors.secondary,
            size: AppDimensions.smallIconSize,
          ),
        ),
      ),
    );
  }

  double get _shiftedProgress {
    final value = progress + delay;
    return value - value.floor();
  }
}

class _SearchBeamPainter extends CustomPainter {
  const _SearchBeamPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.60);
    final radius = size.shortestSide * 0.42;
    final bgRect = Offset.zero & size;
    final bgPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFFFFFFFF),
          Color(0xFFF8FBFF),
        ],
      ).createShader(bgRect);

    canvas.drawRRect(
      RRect.fromRectAndRadius(bgRect, const Radius.circular(12)),
      bgPaint,
    );

    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..color = AppColors.secondary.withOpacity(0.16);
    final pulsePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = AppColors.primary.withOpacity(1 - progress);
    final sweepPaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = SweepGradient(
        colors: [
          AppColors.primary.withOpacity(0),
          AppColors.primary.withOpacity(0.05),
          AppColors.primary.withOpacity(0.24),
        ],
        stops: const [0.0, 0.70, 1.0],
        transform: GradientRotation(progress * math.pi * 2),
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawCircle(center, radius * 0.50, ringPaint);
    canvas.drawCircle(center, radius * 0.76, ringPaint);
    canvas.drawCircle(center, radius, ringPaint);
    canvas.drawCircle(center, radius * (0.44 + progress * 0.56), pulsePaint);
    canvas.drawCircle(center, radius, sweepPaint);

    final pointPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = AppColors.primary.withOpacity(0.72);
    for (final point in const [
      Offset(0.30, 0.50),
      Offset(0.72, 0.52),
      Offset(0.38, 0.80),
      Offset(0.64, 0.78),
    ]) {
      canvas.drawCircle(
        Offset(size.width * point.dx, size.height * point.dy),
        3.4,
        pointPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _SearchBeamPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
