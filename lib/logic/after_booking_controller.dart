import 'package:flutter/material.dart';
import 'package:multitrip_user/api/app_repository.dart';
import 'package:multitrip_user/models/booking_history.dart';
import 'package:multitrip_user/shared/data/constants/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AfterBookingController extends ChangeNotifier {
  bool isLoading = false;
  Bookings? booking;
  String? amount;
  Future<void> cancelBooking({
    String? bookingId,
    Function()? onFailure,
    Function()? onSuccess,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      isLoading = true;
      notifyListeners();

      final resultant = await AppRepository().cancelBooking(
        bookingId: bookingId,
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
        booking = null;
        onSuccess?.call();
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

  Future<void> assigingDriver({
    String? bookingId,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final resultant = await AppRepository().checkDriverAssigningPolling(
        bookingId: bookingId,
        accesstoken: prefs.getString(
          Strings.accesstoken,
        )!,
        userId: prefs.getString(
          Strings.userid,
        )!,
      );

      if (resultant['code'] != null &&
              (resultant['code'] == 200 || resultant['code'] == 201) &&
              resultant['driver_mobile_number'] != null ||
          resultant['driver_mobile'] != null) {
        booking = Bookings.fromJson(resultant);
        notifyListeners();
      } else {}
    } catch (e) {
    } finally {}
  }

  Future<void> pollingTheRide({
    String? bookingId,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final resultant = await AppRepository().checkBookingPolling(
        bookingId: bookingId,
        accesstoken: prefs.getString(
          Strings.accesstoken,
        )!,
        userId: prefs.getString(
          Strings.userid,
        )!,
      );

      if (resultant['code'] != null &&
          (resultant['code'] == 200 || resultant['code'] == 201)) {
        booking = Bookings.fromJson(resultant);
        notifyListeners();
      }
    } catch (e) {
    } finally {}
  }

  Future<void> currentBooking() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final resultant = await AppRepository().currentBooking(
        accesstoken: prefs.getString(
          Strings.accesstoken,
        )!,
        userId: prefs.getString(
          Strings.userid,
        )!,
      );

      if (resultant['code'] != null &&
          (resultant['code'] == 200 || resultant['code'] == 201)) {
        booking = Bookings.fromJson(resultant);
        amount = resultant["amount"];
        notifyListeners();
      }
    } catch (e) {
    } finally {}
  }
}
