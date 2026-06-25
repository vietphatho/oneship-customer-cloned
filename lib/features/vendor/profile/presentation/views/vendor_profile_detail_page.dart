import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_empty_data.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/core/utils/date_time_utils.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/profile/presentation/widgets/profile_background_scaffold.dart';
import 'package:oneship_customer/features/vendor/profile/domain/entities/vendor_profile_entity.dart';
import 'package:oneship_customer/features/vendor/profile/presentation/bloc/vendor_profile_bloc.dart';
import 'package:oneship_customer/features/vendor/profile/presentation/bloc/vendor_profile_state.dart';

class VendorProfileDetailPage extends StatefulWidget {
  const VendorProfileDetailPage({super.key});

  @override
  State<VendorProfileDetailPage> createState() =>
      _VendorProfileDetailPageState();
}

class _VendorProfileDetailPageState extends State<VendorProfileDetailPage> {
  final VendorProfileBloc _vendorProfileBloc = getIt.get();

  @override
  void initState() {
    super.initState();
    _vendorProfileBloc.init();
  }

  @override
  Widget build(BuildContext context) {
    return ProfileBackgroundScaffold(
      appBar: PrimaryAppBar(
        title: 'vendor_profile.detail_title'.tr(),
        backgroundColor: Colors.transparent,
        titleColor: AppColors.onPrimary,
      ),
      body: BlocBuilder<VendorProfileBloc, VendorProfileState>(
        bloc: _vendorProfileBloc,
        buildWhen: (previous, current) =>
            previous.profileResource != current.profileResource,
        builder: (context, state) {
          final profile = state.profile;
          final resource = state.profileResource;

          if (resource.state == Result.loading && profile == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (resource.state == Result.error && profile == null) {
            return Center(
              child: PrimaryEmptyData(onRetry: _vendorProfileBloc.refresh),
            );
          }

          return SingleChildScrollView(
            padding: AppDimensions.mediumPaddingAll,
            child: PrimaryPanel(
              width: double.infinity,
              padding: AppDimensions.mediumPaddingAll,
              child: Column(
                children: _detailItems(profile)
                    .map(
                      (item) => _VendorProfileDetailRow(
                        label: item.label,
                        value: item.value,
                      ),
                    )
                    .toList(),
              ),
            ),
          );
        },
      ),
    );
  }

  List<_VendorProfileDetailItem> _detailItems(VendorProfileEntity? profile) {
    return [
      _VendorProfileDetailItem(
        label: 'vendor_profile.vendor_name'.tr(),
        value: _textOr(profile?.vendorName),
      ),
      _VendorProfileDetailItem(
        label: 'vendor_profile.vendor_code'.tr(),
        value: _textOr(profile?.vendorCode),
      ),
      _VendorProfileDetailItem(
        label: 'vendor_profile.description'.tr(),
        value: _textOr(profile?.description),
      ),
      _VendorProfileDetailItem(
        label: 'vendor_profile.phone'.tr(),
        value: _textOr(profile?.phone),
      ),
      _VendorProfileDetailItem(
        label: 'vendor_profile.email'.tr(),
        value: _textOr(profile?.email),
      ),
      _VendorProfileDetailItem(
        label: 'vendor_profile.address'.tr(),
        value: _textOr(profile?.fullAddress),
      ),
      _VendorProfileDetailItem(
        label: 'vendor_profile.status'.tr(),
        value: _textOr(profile?.status),
      ),
      _VendorProfileDetailItem(
        label: 'vendor_profile.created_date'.tr(),
        value: _formatDate(profile?.createdAt),
      ),
      _VendorProfileDetailItem(
        label: 'vendor_profile.updated_date'.tr(),
        value: _formatDate(profile?.updatedAt),
      ),
    ];
  }

  String _textOr(String? value) {
    final text = value?.trim();
    return text == null || text.isEmpty ? '--' : text;
  }

  String _formatDate(DateTime? value) {
    return DateTimeUtils.formatDateTime(value?.toLocal()) ?? '--';
  }
}

class _VendorProfileDetailItem {
  const _VendorProfileDetailItem({required this.label, required this.value});

  final String label;
  final String value;
}

class _VendorProfileDetailRow extends StatelessWidget {
  const _VendorProfileDetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppDimensions.xSmallSpacing,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PrimaryText(
            label,
            style: AppTextStyles.bodySmall,
            color: AppColors.neutral4,
          ),
          AppSpacing.horizontal(AppDimensions.smallSpacing),
          Expanded(
            flex: 3,
            child: PrimaryText(
              value,
              style: AppTextStyles.labelSmall,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
