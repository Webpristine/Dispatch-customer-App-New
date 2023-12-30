import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:multitrip_user/models/dashboard.dart';
import 'package:multitrip_user/shared/shared.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/app_repository.dart';

class DashBoardController extends ChangeNotifier {
  bool isLoading = false;
  Dashboard? dashboard;
  LatLng? currentLocation;
  String? fullAddress;

  String? error;
  void saveCurrentLocatoin(LatLng current, {String? fulladdress}) {
    currentLocation = current;
    fullAddress = fulladdress;
    notifyListeners();
  }

  Future<void> callDashboardApi(LatLng latLng) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      isLoading = true;
      notifyListeners();

      final value = await AppRepository().getdashboarddata(
        userid: prefs.getString(Strings.userid)!,
        latitude: latLng.latitude.toString(),
        longitude: latLng.longitude.toString(),
        accesstoken: prefs.getString(Strings.accesstoken)!,
      );
      isLoading = false;
      if (value == null) {}
      if (value['code'] != null && value?["code"] == 200) {
        dashboard = Dashboard.fromJson(value);
        currentLocation = latLng;
        notifyListeners();
      } else if (value["code"] == 201) {
        callDashboardApi(latLng);
      } else if (value["code"] == 401) {
        callDashboardApi(latLng);
        error = 'Something Went Wrong';
      } else {
        error = 'Something Went Wrong';
      }
      notifyListeners();
    } catch (e) {
    } finally {
      isLoading = false;
    }
  }
}
