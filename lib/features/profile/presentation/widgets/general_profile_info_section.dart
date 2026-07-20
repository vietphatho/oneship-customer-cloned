import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/features/auth/data/models/response/user_profile_response.dart';

class GeneralProfileShopInfoCard extends StatelessWidget {
  const GeneralProfileShopInfoCard({super.key, this.userProfile});

  static const _emptyText = '--';

  final UserProfileResponse? userProfile;

  @override
  Widget build(BuildContext context) {
    final items = _items;

    return PrimaryPanel(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.smallSpacing,
        AppDimensions.smallSpacing,
        AppDimensions.smallSpacing,
        AppDimensions.largeSpacing,
      ),
      child: Row(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            Expanded(child: PrimaryInfoItem(data: items[i])),
            if (i != items.length - 1) const _InfoDivider(),
          ],
        ],
      ),
    );
  }

  List<PrimaryInfoItemData> get _items {
    return [
      PrimaryInfoItemData(
        icon: Icons.storefront_outlined,
        iconColor: AppColors.primary,
        label: 'Tên chủ tài khoản',
        value: _textOr(userProfile?.displayName),
      ),
      PrimaryInfoItemData(
        icon: Icons.verified_user_outlined,
        iconColor: AppColors.green,
        label: 'Trạng thái tài khoản',
        value: _formatAccountStatus(userProfile?.userStatus),
      ),
      PrimaryInfoItemData(
        icon: Icons.calendar_month_outlined,
        iconColor: AppColors.info,
        label: 'Ngày tham gia',
        value: _formatDynamicDate(userProfile?.userRegistered),
      ),
      // const PrimaryInfoItemData(
      //   icon: Icons.workspace_premium_outlined,
      //   iconColor: AppColors.investmentPurple,
      //   label: 'Gói dịch vụ',
      //   value: 'Business',
      // ),
    ];
  }

  String _textOr(String? value) {
    final text = value?.trim();
    if (text != null && text.isNotEmpty) return text;

    return _emptyText;
  }

  String _formatAccountStatus(UserStatus? status) {
    switch (status) {
      case UserStatus.active:
        return 'Hoạt động';
      case UserStatus.inactive:
        return 'Không hoạt động';
      case UserStatus.unknown:
      case null:
        return _emptyText;
    }
  }

  String? _formatDate(DateTime? date) {
    if (date == null) return null;

    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  String _formatDynamicDate(dynamic value) {
    if (value is DateTime) return _formatDate(value) ?? '';
    if (value is int) return _formatTimestamp(value);
    if (value is String) {
      final date = DateTime.tryParse(value);
      if (date != null) return _formatDate(date) ?? '';

      final timestamp = int.tryParse(value);
      if (timestamp != null) return _formatTimestamp(timestamp);
    }
    return _emptyText;
  }

  String _formatTimestamp(int value) {
    final milliseconds = value > 1000000000000 ? value : value * 1000;
    return _formatDate(DateTime.fromMillisecondsSinceEpoch(milliseconds)) ?? '';
  }
}

class _InfoDivider extends StatelessWidget {
  const _InfoDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppDimensions.mediumBorderStroke,
      height: AppDimensions.displayIconSize,
      color: AppColors.neutral8,
    );
  }
}
