import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/base_response.dart';
import 'package:oneship_customer/features/barcode_scanner/data/models/request/update_google_sheet_request.dart';
import 'package:retrofit/retrofit.dart';

part 'barcode_scanner_api.g.dart';

@lazySingleton
@RestApi()
abstract class BarcodeScannerApi {
  @factoryMethod
  factory BarcodeScannerApi(Dio dio) = _BarcodeScannerApi;

  @POST("/api/v1/orders/update-google-sheet")
  Future<BaseResponse> updateGoogleSheet(@Body() UpdateGoogleSheetRequest body);
}
