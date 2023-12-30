import 'package:flutter/material.dart';
import 'package:multitrip_user/api/app_repository.dart';
import 'package:multitrip_user/shared/data/data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RateDriverController extends ChangeNotifier {
  Future<void> rateRider({
    String? bookingId,
    required double rating,
    String? comment,
    Function()? onFailure,
    Function()? onSuccess,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final resultant = await AppRepository().ratingTheDriver(
        booking_number: bookingId!,
        rating: rating,
        comments: comment,
        accesstoken: prefs.getString(
          Strings.accesstoken,
        )!,
        user_id: prefs.getString(
          Strings.userid,
        )!,
      );

      if (resultant['code'] != null &&
          (resultant['code'] == 200 || resultant['code'] == 201)) {
        onSuccess?.call();
      } else {
        onFailure?.call();
      }
    } catch (e) {
      onFailure?.call();
    }
  }
}
