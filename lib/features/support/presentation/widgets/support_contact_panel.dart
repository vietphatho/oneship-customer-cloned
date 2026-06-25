import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/themes/app_box_shadows.dart';
import 'package:oneship_customer/features/support/presentation/widgets/support_section_title.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportContactPanel extends StatelessWidget {
  const SupportContactPanel({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final rows = Column(
      children: [
        _ContactRow(
          icon: Icons.chat_bubble_outline,
          title: 'support_help.chat_title',
          subtitle: 'support_help.chat_subtitle',
        ),
        Divider(height: 1, color: AppColors.grey200),
        _ContactRow(
          icon: Icons.phone_outlined,
          title: 'support_help.call_title',
          subtitle: 'support_help.call_subtitle',
          onTap: () {
            final Uri launchUri = Uri(scheme: 'tel', path: Constants.hotline);
            launchUrl(launchUri);
          },
        ),
      ],
    );

    if (compact) {
      return _ContactRowsCard(child: rows);
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: AppDimensions.xLargeBorderRadius,
      ),
      child: Column(
        children: [
          SizedBox(
            height: 82,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 112),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SupportSectionTitle('support_help.contact_title'.tr()),
                      const SizedBox(height: 4),
                      PrimaryText(
                        'support_help.contact_description'.tr(),
                        maxLine: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.bodyXSmall.copyWith(
                          color: AppColors.grey600,
                          fontSize: 16,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
                const Positioned(top: -4, right: 2, child: _ContactBannerArt()),
              ],
            ),
          ),
          _ContactRowsCard(child: rows),
        ],
      ),
    );
  }
}

class _ContactRowsCard extends StatelessWidget {
  const _ContactRowsCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppDimensions.largeBorderRadius,
        boxShadow: AppBoxShadows.card,
      ),
      child: child,
    );
  }
}

class _ContactBannerArt extends StatelessWidget {
  const _ContactBannerArt();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: SizedBox(
        width: 100,
        height: 62,
        child: CustomPaint(painter: _EnvelopePainter()),
      ),
    );
  }
}

class _EnvelopePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final envelope = Paint()..color = AppColors.supportEnvelope;
    final fold = Paint()..color = AppColors.supportEnvelopeFold;
    final paper = Paint()..color = Colors.white.withValues(alpha: 0.9);
    final plane = Paint()..color = AppColors.secondary;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(10, 28, 54, 31),
        const Radius.circular(4),
      ),
      envelope,
    );

    final flap = Path()
      ..moveTo(10, 29)
      ..lineTo(37, 46)
      ..lineTo(64, 29)
      ..lineTo(64, 59)
      ..lineTo(10, 59)
      ..close();
    canvas.drawPath(flap, fold);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(22, 15, 30, 24),
        const Radius.circular(4),
      ),
      paper,
    );

    final planePath = Path()
      ..moveTo(72, 16)
      ..lineTo(99, 4)
      ..lineTo(87, 35)
      ..lineTo(82, 24)
      ..lineTo(72, 16)
      ..close();
    canvas.drawPath(planePath, plane);
    canvas.drawLine(
      const Offset(82, 24),
      const Offset(99, 4),
      Paint()
        ..color = Colors.white.withValues(alpha: 0.55)
        ..strokeWidth = 2,
    );

    final trail = Paint()
      ..color = AppColors.secondary.withValues(alpha: 0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final path = Path()
      ..moveTo(78, 48)
      ..quadraticBezierTo(92, 56, 98, 42);
    canvas.drawPath(path, trail);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ContactRow extends StatelessWidget {
  const _ContactRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.secondary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.secondary, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PrimaryText(
                    title.tr(),
                    style: AppTextStyles.labelXSmall.copyWith(
                      color: AppColors.blue950,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  PrimaryText(
                    subtitle.tr(),
                    style: AppTextStyles.bodyXXSmall.copyWith(
                      color: AppColors.grey500,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.grey500, size: 22),
          ],
        ),
      ),
    );
  }
}
