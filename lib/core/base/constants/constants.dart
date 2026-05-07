import 'package:flutter/material.dart';

class Constants {
  Constants._();

  static const String endpointKey = "ENDPOINT";
  static const String imgEndpointKey = "IMG_ENDPOINT";
  static const String versionNameKey = "VERSION_NAME";
  static const String versionCodeKey = "VERSION_CODE";
  static const String envKey = "ENV";
  static const String refreshTokenEndpoint = "/api/v1/auth/refresh";
  static const vietmapAccessToken = "VIETMAP_ACCESS_TOKEN";
  static const String vehicleDefault = "motorcycle";
  static const String endpoint = "https://one-ship-api.de.onexway.io";
  static const String imgEndpoint = "https://xbyw3unofel1.cmccdn.net";
  static const String orderTrackingAction = "track_shipment";
  static const String orderTrackingNonce = "039a82a441";

  // Duration
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
  static const Duration defaultDelayOnTap = Duration(milliseconds: 300);
  static const Duration pageViewTransitionDur = Duration(milliseconds: 300);
  static const Duration fadeTransitionDur = Duration(milliseconds: 300);
  static const Duration tweenTransitionDur = Duration(milliseconds: 300);
  static const Duration assignedPkgSwitchTransitionDur = Duration(
    milliseconds: 700,
  );
  static const Duration assignedPackageNotiTimeOut = Duration(seconds: 6);

  static const String currencyUnit = "đ";
  static const String currencyUnitRequest = "vnd";
  static const String distanceUnit = "m";
  static const String pkgDimensionsUnit = "cm";
  static const String weightUnit = "gram";
  static const int minTopUpAmount = 10000;
  static const int timeoutInSeconds = 30;
  static const int limitCodAmount = 2000000;
  static const int limitDistance = 100;
  static const double defaultMapZoomValue = 16;

  // Date time format
  static const String defaultDateFormat = "dd/MM/yyyy";
  static const String defaultTimeFormat = "HH:mm";
  static const String defaultDateTimeFormat = "HH:mm dd/MM/yyyy";
  static const String requestDateFormat = "yyyy-MM-dd";

  //base url vietmap
  static const defaultTileMapUrl =
      "https://maps.vietmap.vn/maps/styles/tm/style.json?apikey=";
  static const darkTileMapUrl =
      "https://maps.vietmap.vn/maps/styles/dm/style.json?apikey=";

  /// Limitation
  static const int maxPickUpImgs = 3;
  static const int minOrderCodeCharacters = 8;
  static const int maxOrderImgSize = 300;
  static const double minDistanceToSyncLoc = 20; //m
  static const int minIntervalToSyncLoc = 120; //s
  static const int maxReceivingAssignedPkgs = 50;
  static const double minDistanceToSnapRoute = 10;

  static const tpSwitchBoard = "0981191608";

  static const ValueKey profileAvatarHeroKey = ValueKey(
    "profile_avatar_hero_key",
  );

  static const bool isTestMode = false;

  static const double minSpeedToUpdatePos = 3;

  static const int minTimeUpdatePos = 2;

  static const Duration animationUpdateCameraDur = Duration(milliseconds: 1500);

  static const Duration timeoutFCMToken = Duration(seconds: 5);
}
