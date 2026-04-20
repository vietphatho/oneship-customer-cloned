import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkUtils {
  NetworkUtils._();

  // static bool _isShowLostConnection = false;

  static Future<bool> isNetworkAvailable() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi) ||
        connectivityResult.contains(ConnectivityResult.ethernet) ||
        connectivityResult.contains(ConnectivityResult.vpn)) {
      return true; // Có kết nối mạng
    } else {
      return false; // Không có mạng
    }
  }

  static Future<bool> hasInternetAccess() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
      return false;
    } on SocketException catch (_) {
      return false;
    }
  }

  static void listen({
    void Function()? onConnected,
    void Function()? onLostConnection,
  }) {
    Connectivity().onConnectivityChanged.listen((
      List<ConnectivityResult> result,
    ) {
      if (result.contains(ConnectivityResult.none)) {
        // _isShowLostConnection = true;
        // CustomDialog.showErrorDialog(
        //   AppNavigator.globalContext,
        //   title: "network_error_title".tr(),
        //   message: "network_error_mess".tr(),
        // ).then((_) {
        //   _isShowLostConnection = false;
        // });
        // CustomToast.showToast("network_error_title".tr());
        onLostConnection?.call();
      } else {
        // if (_isShowLostConnection) {
        //   Navigator.pop(AppNavigator.globalContext);
        //   _isShowLostConnection = false;
        // }
        // ToastView.dismiss();
        onConnected?.call();
      }
    });
  }
}
