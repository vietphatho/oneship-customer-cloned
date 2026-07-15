import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/core/services/device_id_service.dart';
import 'package:oneship_customer/core/utils/validators.dart';
import 'package:oneship_customer/features/auth/data/models/request/create_second_password_request.dart';
import 'package:oneship_customer/features/auth/data/models/request/forgot_password_request.dart';
import 'package:oneship_customer/features/auth/data/models/request/login_request.dart';
import 'package:oneship_customer/features/auth/data/models/request/update_password_request.dart';
import 'package:oneship_customer/features/auth/data/models/request/update_second_password_request.dart';
import 'package:oneship_customer/features/auth/data/models/request/update_user_profile_request.dart';
import 'package:oneship_customer/features/auth/data/models/request/verify_secondary_password_request.dart';
import 'package:oneship_customer/features/auth/data/models/response/user_profile_response.dart';
import 'package:oneship_customer/features/auth/domain/use_cases/create_second_password_use_case.dart';
import 'package:oneship_customer/features/auth/domain/use_cases/delete_account_use_case.dart';
import 'package:oneship_customer/features/auth/domain/use_cases/fetch_user_profile_use_case.dart';
import 'package:oneship_customer/features/auth/domain/use_cases/forgot_password_use_case.dart';
import 'package:oneship_customer/features/auth/domain/use_cases/forgot_secondary_password_use_case.dart';
import 'package:oneship_customer/features/auth/domain/use_cases/log_in_use_case.dart';
import 'package:oneship_customer/features/auth/domain/use_cases/log_out_use_case.dart';
import 'package:oneship_customer/features/auth/domain/use_cases/update_password_use_case.dart';
import 'package:oneship_customer/features/auth/domain/use_cases/update_second_password_use_case.dart';
import 'package:oneship_customer/features/auth/domain/use_cases/update_user_avatar_use_case.dart';
import 'package:oneship_customer/features/auth/domain/use_cases/update_user_profile_use_case.dart';
import 'package:oneship_customer/features/auth/domain/use_cases/verify_secondary_password_use_case.dart';
import 'package:oneship_customer/features/auth/presentation/bloc/auth_event.dart';
import 'package:oneship_customer/features/auth/presentation/bloc/auth_state.dart';
import 'package:oneship_customer/features/shop_master/data/enum.dart';

@lazySingleton
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(
    this._logInUseCase,
    this._logOutUseCase,
    this._fetchUserProfileUseCase,
    this._updateUserProfileUseCase,
    this._updatePasswordUseCase,
    this._createSecondPasswordUseCase,
    this._updateSecondPasswordUseCase,
    this._verifySecondaryPasswordUseCase,
    this._deleteAccountUseCase,
    this._updateUserAvatarUseCase,
    this._forgotPasswordUseCase,
    this._forgotSecondaryPasswordUseCase,
    this._deviceIdService,
  ) : super(const AuthInitialState()) {
    on<AuthLoginEvent>(_onLoginEvent);
    on<AuthForgotPasswordEvent>(_onForgotPasswordEvent);
    on<AuthForgotSecondaryPasswordEvent>(_onForgotSecondaryPasswordEvent);
    on<AuthFetchingUserProfileEvent>(_onProfileFetchedEvent);
    on<AuthUpdateUserProfileEvent>(_onProfileUpdatedEvent);
    on<AuthLogOutEvent>(_onLogOutEvent);
    on<AuthUpdatePasswordEvent>(_onPasswordUpdatedEvent);
    on<AuthCreateSecondPasswordEvent>(_onSecondPasswordCreatedEvent);
    on<AuthUpdateSecondPasswordEvent>(_onSecondPasswordUpdatedEvent);
    on<AuthVerifySecondaryPasswordEvent>(_onVerifySecondaryPassword);
    on<AuthDeleteAccountEvent>(_onDeleteAccountEvent);
    on<AuthUpdateUserAvatarEvent>(_onUserAvatarUpdatedEvent);
  }

  final LogInUseCase _logInUseCase;
  final LogOutUseCase _logOutUseCase;
  final FetchUserProfileUseCase _fetchUserProfileUseCase;
  final UpdateUserProfileUseCase _updateUserProfileUseCase;
  final UpdatePasswordUseCase _updatePasswordUseCase;
  final CreateSecondPasswordUseCase _createSecondPasswordUseCase;
  final UpdateSecondPasswordUseCase _updateSecondPasswordUseCase;
  final VerifySecondaryPasswordUseCase _verifySecondaryPasswordUseCase;
  final DeleteAccountUseCase _deleteAccountUseCase;
  final UpdateUserAvatarUseCase _updateUserAvatarUseCase;
  final ForgotPasswordUseCase _forgotPasswordUseCase;
  final ForgotSecondaryPasswordUseCase _forgotSecondaryPasswordUseCase;
  final DeviceIdService _deviceIdService;

  final ImagePicker _imagePicker = ImagePicker();

  late UserProfileResponse _userProfile;
  UserProfileResponse get userProfile => _userProfile;
  bool _hasDismissedSecondPasswordReminder = false;

  List<BottomNavigationItem> getBottomNavBarList() {
    return [
      BottomNavigationItem.home,
      BottomNavigationItem.orderList,
      BottomNavigationItem.finance,
      BottomNavigationItem.menu,
    ];
  }

  Future<void> _onLoginEvent(AuthLoginEvent event, Emitter emit) async {
    emit(AuthLoggedInState(Resource.loading()));

    LoginRequest request = LoginRequest(
      login: event.userName,
      password: event.password,
      deviceId: await _deviceIdService.getDeviceId(),
    );
    final response = await _logInUseCase.call(request);

    emit(AuthLoggedInState(response));
  }

  FutureOr<void> _onForgotPasswordEvent(
    AuthForgotPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    final email = event.email.trim();
    final validationMessage = validateForgotPasswordEmail(email);
    if (validationMessage != null) {
      emit(AuthForgotPasswordState(Resource.error(validationMessage, 0)));
      return;
    }

    emit(AuthForgotPasswordState(Resource.loading()));

    final response = await _forgotPasswordUseCase.call(
      ForgotPasswordRequest(email: email),
    );

    emit(AuthForgotPasswordState(response));
  }

  FutureOr<void> _onForgotSecondaryPasswordEvent(
    AuthForgotSecondaryPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    final email = event.email.trim();
    final validationMessage = validateForgotPasswordEmail(email);
    if (validationMessage != null) {
      emit(
        AuthForgotSecondaryPasswordState(Resource.error(validationMessage, 0)),
      );
      return;
    }

    emit(AuthForgotSecondaryPasswordState(Resource.loading()));

    final response = await _forgotSecondaryPasswordUseCase.call(
      ForgotPasswordRequest(email: email),
    );

    emit(AuthForgotSecondaryPasswordState(response));
  }

  FutureOr<void> _onProfileFetchedEvent(
    AuthFetchingUserProfileEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthFetchedUserProfileState(Resource.loading()));
    final response = await _fetchUserProfileUseCase.call();
    if (response.state == Result.success) {
      _userProfile = response.data!;
    }
    emit(AuthFetchedUserProfileState(response));
  }

  FutureOr<void> _onLogOutEvent(
    AuthLogOutEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLogOutState(Resource.loading()));
    final response = await _logOutUseCase.call();
    if (response.state == Result.success) {
      _hasDismissedSecondPasswordReminder = false;
    }
    emit(AuthLogOutState(response));
  }

  FutureOr<void> _onProfileUpdatedEvent(
    AuthUpdateUserProfileEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthUpdatedUserProfileState(Resource.loading()));

    final response = await _updateUserProfileUseCase.call(
      id: userProfile.id.toString(),
      request: event.request,
    );

    if (response.state == Result.success) {
      _userProfile = response.data!;
    }
    emit(AuthUpdatedUserProfileState(response));
  }

  FutureOr<void> _onPasswordUpdatedEvent(
    AuthUpdatePasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthUpdatedPasswordState(Resource.loading()));
    final response = await _updatePasswordUseCase.call(event.body);
    emit(AuthUpdatedPasswordState(response));
  }

  FutureOr<void> _onSecondPasswordCreatedEvent(
    AuthCreateSecondPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthUpdatedPasswordState(Resource.loading()));
    final response = await _createSecondPasswordUseCase.call(event.body);
    if (response.state == Result.success) {
      final profileResponse = await _fetchUserProfileUseCase.call();
      if (profileResponse.state == Result.success &&
          profileResponse.data != null) {
        _userProfile = profileResponse.data!;
      } else {
        emit(AuthUpdatedPasswordState(profileResponse));
        return;
      }
    }
    emit(AuthUpdatedPasswordState(response));
  }

  FutureOr<void> _onSecondPasswordUpdatedEvent(
    AuthUpdateSecondPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthUpdatedPasswordState(Resource.loading()));
    final response = await _updateSecondPasswordUseCase.call(event.body);
    if (response.state == Result.success) {
      final profileResponse = await _fetchUserProfileUseCase.call();
      if (profileResponse.state == Result.success &&
          profileResponse.data != null) {
        _userProfile = profileResponse.data!;
      } else {
        emit(AuthUpdatedPasswordState(profileResponse));
        return;
      }
    }
    emit(AuthUpdatedPasswordState(response));
  }

  FutureOr<void> _onDeleteAccountEvent(
    AuthDeleteAccountEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthDeleteAccountState(Resource.loading()));

    final response = await _deleteAccountUseCase.call();

    emit(AuthDeleteAccountState(response));
  }

  FutureOr<void> _onUserAvatarUpdatedEvent(
    AuthUpdateUserAvatarEvent event,
    Emitter<AuthState> emit,
  ) async {
    final selectedImage = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (selectedImage == null) return;

    emit(AuthUpdatedUserAvatarState(Resource.loading(data: _userProfile)));

    final uploadResponse = await _updateUserAvatarUseCase.call(
      id: userProfile.id.toString(),
      avatarPath: selectedImage.path,
    );

    if (uploadResponse.state != Result.success) {
      emit(
        AuthUpdatedUserAvatarState(
          Resource.error(
            uploadResponse.message,
            uploadResponse.statusCode,
            errorCode: uploadResponse.errorCode,
            err: uploadResponse.err,
          ),
        ),
      );
      return;
    }

    final profileResponse = await _fetchUserProfileUseCase.call();
    if (profileResponse.state == Result.success &&
        profileResponse.data != null) {
      _userProfile = profileResponse.data!;
    }
    emit(AuthUpdatedUserAvatarState(profileResponse));
  }

  void updatePassword(UpdatePasswordRequest body) {
    add(AuthUpdatePasswordEvent(body));
  }

  void forgotPassword({required String email}) {
    add(AuthForgotPasswordEvent(email: email));
  }

  void forgotSecondaryPassword({required String email}) {
    add(AuthForgotSecondaryPasswordEvent(email: email));
  }

  String? validateForgotPasswordEmail(String email) {
    return Validators.validateEmail(email.trim());
  }

  void createSecondPassword(CreateSecondPasswordRequest body) {
    add(AuthCreateSecondPasswordEvent(body));
  }

  void updateSecondPassword(UpdateSecondPasswordRequest body) {
    add(AuthUpdateSecondPasswordEvent(body));
  }

  Future<void> _onVerifySecondaryPassword(
    AuthVerifySecondaryPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthVerifySecondaryPasswordState(Resource.loading()));

    final response = await _verifySecondaryPasswordUseCase.call(event.request);

    emit(AuthVerifySecondaryPasswordState(response));
  }

  void verifySecondaryPassword({required String secondPassword}) {
    add(
      AuthVerifySecondaryPasswordEvent(
        VerifySecondaryPasswordRequest(secondPassword: secondPassword),
      ),
    );
  }

  void updateUserProfile({String? displayName, String? userPhone}) {
    add(
      AuthUpdateUserProfileEvent(
        UpdateUserProfileRequest(
          displayName: displayName ?? _userProfile.displayName,
          userPhone: userPhone ?? _userProfile.userPhone,
        ),
      ),
    );
  }

  void login({required String userName, required String password}) {
    add(AuthLoginEvent(userName: userName, password: password));
  }

  void logOut() {
    add(AuthLogOutEvent());
  }

  void fetchUserProfile() {
    add(const AuthFetchingUserProfileEvent());
  }

  void deleteAccount() {
    add(const AuthDeleteAccountEvent());
  }

  void updateUserAvatar() {
    add(const AuthUpdateUserAvatarEvent());
  }

  bool get shouldShowSecondPasswordReminder =>
      !_hasDismissedSecondPasswordReminder &&
      (_userProfile.hasSecondPassword ?? false) == false;

  void dismissSecondPasswordReminder() {
    _hasDismissedSecondPasswordReminder = true;
  }
}
