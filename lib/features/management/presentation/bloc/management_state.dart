import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/management/data/models/response/get_shops_response.dart';

abstract class ManagementState {
  const ManagementState();
}

class ManagementInitState extends ManagementState {
  const ManagementInitState();
}

class ManagementGetShopsState extends ManagementState {
  final Resource<GetShopsResponse> resource;

  ManagementGetShopsState(this.resource);
}
