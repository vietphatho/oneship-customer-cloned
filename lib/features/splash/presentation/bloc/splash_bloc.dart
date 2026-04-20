import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/core/network/token_manager.dart';
import 'package:oneship_customer/features/splash/presentation/bloc/splash_event.dart';
import 'package:oneship_customer/features/splash/presentation/bloc/splash_state.dart';

@lazySingleton
class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashState(hasLoginSession: Resource.loading())) {
    on<SplashInitEvent>(_onInit);
  }

  bool _isFirstApp = true;
  bool get isFirstApp => _isFirstApp;

  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  FutureOr<void> _onInit(
    SplashInitEvent event,
    Emitter<SplashState> emit,
  ) async {
    TokenManager tokenManager = TokenManager();
    String? accessToken = await tokenManager.getAccessToken();

    emit(
      state.copyWith(hasLoginSession: Resource.success(accessToken != null)),
    );
  }

  // FutureOr<void> _loadThemeConfigEvent(
  //   SplashLoadThemeConfigEvent event,
  //   Emitter<SplashState> emit,
  // ) async {
  //   String? themeModeConfig = await SecureStorage.getSecureData(
  //     KeyStorage.themeModeKey,
  //   );

  //   if (themeModeConfig == ThemeMode.light.name) {
  //     _themeMode = ThemeMode.light;
  //     emit(const SplashThemeConfigChangedState(ThemeMode.light));
  //   } else if (themeModeConfig == ThemeMode.dark.name) {
  //     _themeMode = ThemeMode.dark;
  //     emit(const SplashThemeConfigChangedState(ThemeMode.dark));
  //   } else {
  //     _themeMode = ThemeMode.system;
  //     emit(const SplashThemeConfigChangedState(ThemeMode.system));
  //   }
  // }

  // FutureOr<void> _changeThemeConfigEvent(
  //   SplashChangeThemeConfigEvent event,
  //   Emitter<SplashState> emit,
  // ) {
  //   SecureStorage.setSecureData(KeyStorage.themeModeKey, event.themeMode.name);
  //   _themeMode = event.themeMode;
  //   emit(SplashThemeConfigChangedState(event.themeMode));
  // }

  @PostConstruct()
  void init() {
    add(const SplashInitEvent());
  }

  // void changeThemeMode(ThemeMode themeMode) {
  //   add(SplashChangeThemeConfigEvent(themeMode));
  // }
}
