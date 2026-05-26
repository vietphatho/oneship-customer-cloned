// ignore_for_file: constant_identifier_names

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/constants/constants.dart';
import 'package:oneship_customer/core/network/token_manager.dart';
import 'package:oneship_customer/core/utils/app_logger.dart';
import 'package:socket_io_client/socket_io_client.dart' as socket_io;

class SocketEvent {
  static const socketConnected = 'connected';
  static const socketError = 'error';
  //Has driver accepted the package
  static const pkgStatusChanged = 'package_status_changed';
  //No drivers accepted
  static const autoDispatchFailed = 'auto_dispatch_failed';
}

class SocketMessage {
  final String event;
  final dynamic data;

  SocketMessage(this.event, this.data);
}

@lazySingleton
class SocketService {
  static socket_io.Socket? _socket;
  static final _controller = StreamController<SocketMessage>.broadcast();
  Stream<SocketMessage> get stream => _controller.stream;
  bool get isConnected => _socket?.connected ?? false;

  Future<void> connect(String shopId) async {
    if (isConnected) return;

    // final endpoint = dotenv.env[Constant.endpointKey] ?? "";
    final endpoint = Constants.endpoint;
    final accessToken = await TokenManager().getAccessToken() ?? '';
    final token = Uri.encodeComponent(accessToken);

    _socket = socket_io.io(
      '$endpoint/shops',
      socket_io.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .setQuery({'token': token, 'shopId': shopId})
          .build(),
    );

    _socket
      ?..onConnect((_) {
        AppLogger().log('✅ Connected to Socket.IO server');
        _controller.add(
          SocketMessage(SocketEvent.socketConnected, "Connected"),
        );
      })
      ..onDisconnect((_) {
        AppLogger().log('Disconnected from server');
      })
      ..onError((data) {
        AppLogger().log('Socket error', detail: data);
        _controller.add(SocketMessage(SocketEvent.socketError, "Error"));
      })
      ..onAny((event, data) async {
        if (event == SocketEvent.socketError) {
          AppLogger().log(
            "socket onAny",
            detail: "event: $event, data: ${data.toString()}",
          );
          await _refreshToken();
          disconnect();
          connect(shopId);
        }
      });

    // Nhận event từ server
    _listen(SocketEvent.socketConnected);
    _listen(SocketEvent.pkgStatusChanged);
    _listen(SocketEvent.autoDispatchFailed);
  }

  static void _listen(String event) {
    _socket?.on(event, (data) {
      _controller.add(SocketMessage(event, data));
      AppLogger().log(event, detail: data);
    });
  }

  Future<void> _refreshToken() async {
    // final endpoint = dotenv.env[Constant.endpointKey] ?? "";
    final endpoint = Constants.endpoint;
    final TokenManager tokenManager = TokenManager();
    final refreshToken = await tokenManager.getRefreshToken();

    final refreshDio = Dio(
      BaseOptions(headers: {'refresh-token': refreshToken}),
    );
    final response = await refreshDio.post(
      '$endpoint${Constants.refreshTokenEndpoint}',
    );

    AppLogger().log("socket refresh token result", detail: response.data);

    await tokenManager.saveTokens(
      accessToken: response.data['result']['access_token'],
      refreshToken: response.data['result']['refresh_token'],
    );
  }

  void disconnect() {
    if (_socket == null) return;
    _socket?.disconnect();
    _socket?.dispose();
    _socket?.close();
    _socket = null;
    debugPrint('🔌 Socket disconnected');
  }
}
