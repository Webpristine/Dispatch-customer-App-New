import 'package:flutter/material.dart';
import 'package:multitrip_user/api/app_repository.dart';
import 'package:multitrip_user/models/booking_history.dart';
import 'package:multitrip_user/models/user.dart';
import 'package:multitrip_user/shared/shared.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountController extends ChangeNotifier {
  bool isLoading = false;
  UserModel? userModel;
  BookingHistory? history;
  Future<void> getPofileData(
      {Function()? onFailure, bool isEnableLoading = true}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (isEnableLoading) {
        isLoading = true;
        notifyListeners();
      }

      final resultant = await AppRepository().getProfile(
        accesstoken: prefs.getString(
          Strings.accesstoken,
        )!,
        user_id: prefs.getString(
          Strings.userid,
        )!,
      );
      if (isEnableLoading) {
        isLoading = false;
        notifyListeners();
      }
      if (resultant['code'] != null && resultant['code'] == 200) {
        userModel = UserModel.fromJson(resultant);
        notifyListeners();
      } else {
        if (isEnableLoading) {
          onFailure?.call();
        }
      }
    } catch (e) {
      // TODO
    } finally {
      if (isEnableLoading) {
        isLoading = false;
      }
      notifyListeners();
    }
  }

  Future<void> updateName({
    required String firstName,
    required String LastName,
    Function()? onSuccess,
    Function()? onFailure,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      isLoading = true;
      notifyListeners();

      final resultant = await AppRepository().updateNameProfile(
          accesstoken: prefs.getString(
            Strings.accesstoken,
          )!,
          user_id: prefs.getString(
            Strings.userid,
          )!,
          first_name: firstName,
          last_name: LastName);
      isLoading = false;
      notifyListeners();

      if (resultant['code'] != null && resultant['code'] == 200) {
        getPofileData();
        onSuccess?.call();
      } else {
        onFailure?.call();
      }
    } catch (e) {
      // TODO
      onFailure?.call();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateMobileNumber({
    required String mobileNumber,
    Function()? onSuccess,
    Function()? onFailure,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      isLoading = true;
      notifyListeners();

      final resultant = await AppRepository().updateMobileProfile(
        accesstoken: prefs.getString(
          Strings.accesstoken,
        )!,
        user_id: prefs.getString(
          Strings.userid,
        )!,
        mobile_number: mobileNumber,
      );
      isLoading = false;
      notifyListeners();

      if (resultant['code'] != null && resultant['code'] == 200) {
        getPofileData();
        onSuccess?.call();
      } else {
        onFailure?.call();
      }
    } catch (e) {
      // TODO
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateEmail({
    required String email,
    Function()? onSuccess,
    Function()? onFailure,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      isLoading = true;
      notifyListeners();

      final resultant = await AppRepository().updateEmailProfile(
        accesstoken: prefs.getString(
          Strings.accesstoken,
        )!,
        user_id: prefs.getString(
          Strings.userid,
        )!,
        email: email,
      );
      isLoading = false;
      notifyListeners();

      if (resultant['code'] != null && resultant['code'] == 200) {
        getPofileData();
        onSuccess?.call();
      } else {
        onFailure?.call();
      }
    } catch (e) {
      // TODO
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updatePassword({
    required String password,
    Function()? onSuccess,
    Function()? onFailure,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      isLoading = true;
      notifyListeners();

      final resultant = await AppRepository().changePassword(
        accesstoken: prefs.getString(
          Strings.accesstoken,
        )!,
        user_id: prefs.getString(
          Strings.userid,
        )!,
        password: password,
      );
      isLoading = false;
      notifyListeners();

      if (resultant['code'] != null && resultant['code'] == 200) {
        onSuccess?.call();
      } else {
        onFailure?.call();
      }
    } catch (e) {
      // TODO
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProfile({
    required String path,
    Function()? onSuccess,
    Function()? onFailure,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      isLoading = true;
      notifyListeners();

      final resultant = await AppRepository().uploadImage(
        accesstoken: prefs.getString(
          Strings.accesstoken,
        )!,
        user_id: prefs.getString(
          Strings.userid,
        )!,
        path: path,
      );
      isLoading = false;
      notifyListeners();

      if (resultant['code'] != null &&
          (resultant['code'] == 200 || resultant['code'] == 201)) {
        onSuccess?.call();
        getPofileData();
      } else {
        onFailure?.call();
      }
    } catch (e) {
      // TODO
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getBookingHistory({
    Function()? onFailure,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      isLoading = true;
      notifyListeners();

      final resultant = await AppRepository().bookingHistory(
        accesstoken: prefs.getString(
          Strings.accesstoken,
        )!,
        userId: prefs.getString(
          Strings.userid,
        )!,
      );
      isLoading = false;
      notifyListeners();

      if (resultant['code'] != null &&
          (resultant['code'] == 200 || resultant['code'] == 201)) {
        history = BookingHistory.fromJson(resultant);
        notifyListeners();
      } else {
        onFailure?.call();
      }
    } catch (e) {
      onFailure?.call();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
