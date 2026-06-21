import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:oneship_customer/core/base/components/primary_text.dart';
import 'package:oneship_customer/core/themes/app_colors.dart';
import 'package:oneship_customer/core/themes/app_text_style.dart';

class SupportHero extends StatelessWidget {
  const SupportHero({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PrimaryText(
                'support_help.hero_title'.tr(),
                style: AppTextStyles.titleXLarge.copyWith(
                  color: AppColors.blue950,
                  fontWeight: FontWeight.w700,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 10),
              PrimaryText(
                'support_help.hero_description'.tr(),
                style: AppTextStyles.bodyXSmall.copyWith(
                  color: AppColors.grey600,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        const _SupportHeroArt(),
      ],
    );
  }
}

class _SupportHeroArt extends StatelessWidget {
  const _SupportHeroArt();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 118,
      height: 118,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            right: 8,
            top: 16,
            child: Container(
              width: 88,
              height: 88,
              decoration: const BoxDecoration(
                color: AppColors.supportAccountBackground,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const Positioned(
            right: 14,
            top: 18,
            child: _MiniChatBubble(),
          ),
          const Positioned(
            left: 8,
            top: 38,
            child: _Sparkle(size: 12),
          ),
          const Positioned(
            right: 0,
            bottom: 34,
            child: _Sparkle(size: 10),
          ),
          CustomPaint(
            size: const Size(96, 96),
            painter: _HeadsetPainter(),
          ),
        ],
      ),
    );
  }
}

class _HeadsetPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final blue = Paint()
      ..color = AppColors.secondary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;
    final fill = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final pale = Paint()
      ..color = AppColors.supportAccountBackground
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2 + 4);
    canvas.drawCircle(center, 34, fill);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: 40),
      3.55,
      2.32,
      false,
      blue,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(14, 44, 20, 32),
        const Radius.circular(9),
      ),
      Paint()..color = AppColors.secondary,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(70, 44, 20, 32),
        const Radius.circular(9),
      ),
      Paint()..color = AppColors.secondary,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(32, 38, 40, 34),
        const Radius.circular(16),
      ),
      pale,
    );

    for (final dx in [43.0, 52.0, 61.0]) {
      canvas.drawCircle(Offset(dx, 55), 3.2, Paint()..color = AppColors.secondary);
    }

    final mic = Paint()
      ..color = AppColors.secondary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(const Offset(72, 72), const Offset(62, 72), mic);
    canvas.drawCircle(const Offset(60, 72), 3.2, Paint()..color = AppColors.secondary);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MiniChatBubble extends StatelessWidget {
  const _MiniChatBubble();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 30,
      decoration: BoxDecoration(
        color: AppColors.supportHeroBubble,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          _Dot(),
          SizedBox(width: 3),
          _Dot(),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 5,
      height: 5,
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: 0.28),
        shape: BoxShape.circle,
      ),
    );
  }
}

class _Sparkle extends StatelessWidget {
  const _Sparkle({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.auto_awesome,
      size: size,
      color: AppColors.secondary.withValues(alpha: 0.28),
    );
  }
}
