import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_dialog.dart';
import 'package:oneship_customer/core/navigation/app_navigator.dart';
import 'package:oneship_customer/core/utils/app_logger.dart';
import 'package:permission_handler/permission_handler.dart';

class PushNotification {
  PushNotification._();

  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  static StreamSubscription? _fcmTokenRefreshedListener;
  static StreamSubscription? _onMessageListener;
  static StreamSubscription? _onMessageOpenedAppListener;

  static Future<void> _initLocalPushNotification() async {
    try {
      await _plugin.initialize(
        settings: const InitializationSettings(
          android: AndroidInitializationSettings('@mipmap/ic_launcher'),
          iOS: DarwinInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true,
          ),
        ),
      );

      if (Platform.isIOS) {
        final ios = _plugin
            .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin
            >();

        await ios?.requestPermissions(alert: true, badge: true, sound: true);
      }

      if (Platform.isAndroid) {
        final status = await Permission.notification.request();
        if (status.isPermanentlyDenied &&
            AppNavigator.globalKey.currentContext != null) {
          PrimaryDialog.showQuestionDialog(
            AppNavigator.globalKey.currentContext!,
            title: "turn_on_notification".tr(),
            message: "turn_on_noti_des".tr(),
            positiveButtonText: "turn_on".tr(),
            negativeButtonText: "skip".tr(),
            onPositiveTapped: openAppSettings,
          );
          return;
        }

        final channel = AndroidNotificationChannel(
          PushNotificationType.info.channelId,
          PushNotificationType.info.channelName,
          importance: Importance.max,
          playSound: true,
          enableVibration: true,
          vibrationPattern: PushNotificationType.info.vibrationPattern,
          sound: RawResourceAndroidNotificationSound(
            PushNotificationType.info.sound,
          ),
        );

        await _plugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >()
            ?.createNotificationChannel(channel);
      }
    } catch (e) {
      AppLogger().log("Error init local push notification");
    }
  }

  // static Future<void> _initFCM() async {
  //   try {
  //     await FirebaseMessaging.instance.requestPermission(
  //       alert: true,
  //       announcement: true,
  //       badge: true,
  //       carPlay: false,
  //       criticalAlert: false,
  //       provisional: false,
  //       sound: true,
  //     );
  //     String? token = await FirebaseMessaging.instance.getToken().timeout(
  //       Constant.timeoutFCMToken,
  //     );
  //     AppLogger().log("FCM Token", detail: token);
  //     SecureStorage.setSecureData(KeyStorage.fcmTokenKey, token!);
  //   } catch (e) {
  //     AppLogger().log("FCM getToken timeout / error", detail: e);
  //   }
  // }

  static Future<void> init() async {
    await Future.wait([
      _initLocalPushNotification(),
      // _initFCM()
    ]);
  }

  // static Future<void> registerNewFcmToken() {
  //   return _initFCM();
  // }

  static Future<int> show({
    int? id,
    required String title,
    required String message,
    bool autoClose = false,
    Duration timeOut = Constants.pushNotiTimeOut,
    PushNotificationType type = PushNotificationType.info,
  }) async {
    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      type.channelId,
      type.channelName,
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      sound: RawResourceAndroidNotificationSound(type.sound),
      vibrationPattern: type.vibrationPattern,
    );

    DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: "${type.sound}.caf",
    );

    NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    int notiId = id ?? DateTime.now().millisecondsSinceEpoch ~/ 1000;
    AppLogger().log("show push notification", detail: message);
    await _plugin.show(
      id: notiId,
      title: title,
      body: message,
      notificationDetails: details,
    );

    if (autoClose) {
      await Future.delayed(timeOut);
      close(notiId);
    }
    return notiId;
  }

  static void close(int id) {
    _plugin.cancel(id: id);
  }

  static void clearToken() {
    _fcmTokenRefreshedListener?.cancel();
    _onMessageListener?.cancel();
    _onMessageOpenedAppListener?.cancel();
    // FirebaseMessaging.instance.deleteToken();
  }

  // static void registerFCMListener({
  //   void Function(RemoteMessage message)? onMessageOpenedApp,
  //   void Function(RemoteMessage message)? onHasInitialMessage,
  //   void Function(String newToken)? onTokenRefreshed,
  // }) async {
  //   RemoteMessage? initialMessage = await FirebaseMessaging.instance
  //       .getInitialMessage();

  //   if (initialMessage != null) {
  //     onHasInitialMessage?.call(initialMessage);
  //   }

  //   _fcmTokenRefreshedListener = FirebaseMessaging.instance.onTokenRefresh
  //       .listen((newToken) {
  //         SecureStorage.setSecureData(KeyStorage.fcmTokenKey, newToken);
  //         onTokenRefreshed?.call(newToken);
  //       });

  //   _onMessageListener = FirebaseMessaging.onMessage.listen((
  //     RemoteMessage message,
  //   ) {
  //     AppLogger().log("FCM Foreground message", detail: message.toString());
  //     // handle for assigned package case
  //     const int assignedPkgNotiTimeOut = 30;
  //     show(
  //       title: message.notification?.title ?? "notification",
  //       message: message.notification?.body ?? "notification",
  //       autoClose: true,
  //       timeOut: const Duration(seconds: assignedPkgNotiTimeOut),
  //     );
  //   });

  //   _onMessageOpenedAppListener = FirebaseMessaging.onMessageOpenedApp.listen((
  //     RemoteMessage message,
  //   ) {
  //     AppLogger().log("Open FCM notification", detail: message.toString());
  //     onMessageOpenedApp?.call(message);
  //   });
  // }
}

enum PushNotificationType { info, message, ads, accepted, rejected }

extension PushNotificationTypeExt on PushNotificationType {
  static const String _infoSound = "info_sound";
  static const String _acceptedSound = "accepted_sound";
  static const String _rejectedSound = "rejected_sound";

  static const String _infoChannelId = "info_channel_id";
  static const String _infoChannelName = "Thông báo Đơn hàng";

  static const _mapChannelId = {
    PushNotificationType.info: _infoChannelId,
    PushNotificationType.accepted: _infoChannelId,
    PushNotificationType.rejected: _infoChannelId,
  };

  static const _mapChannelName = {
    PushNotificationType.info: _infoChannelName,
    PushNotificationType.accepted: _infoChannelName,
    PushNotificationType.rejected: _infoChannelName,
  };

  static const _mapSoundName = {
    PushNotificationType.info: _infoSound,
    PushNotificationType.accepted: _acceptedSound,
    PushNotificationType.rejected: _rejectedSound,
  };

  static const _mapVibrationPartern = {
    PushNotificationType.info: [0, 1000],
    PushNotificationType.accepted: [0, 300, 0, 300, 0, 300],
    PushNotificationType.rejected: [0, 300, 0, 300, 0, 300],
  };

  String get channelId => _mapChannelId[this]!;

  String get channelName => _mapChannelName[this]!;

  String get sound => _mapSoundName[this]!;

  Int64List get vibrationPattern =>
      Int64List.fromList(_mapVibrationPartern[this]!);
}
