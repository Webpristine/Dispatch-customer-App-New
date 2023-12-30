import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:multitrip_user/api/app_repository.dart';
import 'package:multitrip_user/api/token_manager.dart';
import 'package:multitrip_user/app_enverionment.dart';
import 'package:multitrip_user/blocs/dashboard/dashboard_controller.dart';
import 'package:multitrip_user/features/account/account.dart';
import 'package:multitrip_user/features/ride_history/previous_ride.dart';
import 'package:multitrip_user/features/dashboard/home.dart';
import 'package:multitrip_user/logic/scheduledrides/scheduledride.dart';
import 'package:multitrip_user/models/route_arguments.dart';
import 'package:multitrip_user/shared/shared.dart';
import 'package:multitrip_user/themes/app_text.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class PagesWidget extends StatefulWidget {
  dynamic currentTab;
  RouteArgument? routeArgument;
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  PagesWidget({
    Key? key,
    this.currentTab,
  }) {
    if (currentTab != null) {
      if (currentTab is RouteArgument) {
        routeArgument = currentTab;
        currentTab = int.parse(
          currentTab.id,
        );
      }
    } else {
      currentTab = 0;
    }
  }

  @override
  _PagesWidgetState createState() {
    return _PagesWidgetState();
  }
}

class _PagesWidgetState extends State<PagesWidget> with WidgetsBindingObserver {
  Widget currentPage = HomeScreen();
  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final prefs = await SharedPreferences.getInstance();
      GetIt.instance
          .get<TokenManager>()
          .saveToken(GetIt.instance.get<TokenManager>().token ?? '');
      AppRepository().saveFcmToken(
        accesstoken: prefs.getString(Strings.accesstoken)!,
        userid: prefs.getString(Strings.userid)!,
        fcmToken: prefs.getString('fcm') ?? '',
      );
      _selectTab(widget.currentTab);
    });
  }

  // @override
  // void didChangeAppLifecycleState(state) {
  //   if (state == AppLifecycleState.resumed) {
  //     AppEnvironment.navigator.pushAndRemoveUntil(
  //         MaterialPageRoute(
  //             builder: (_) => PagesWidget(
  //                   currentTab: 0,
  //                 )),
  //         (route) => false);
  //   }
  // }

  @override
  void didUpdateWidget(PagesWidget oldWidget) {
    _selectTab(oldWidget.currentTab);
    super.didUpdateWidget(oldWidget);
  }

  void _selectTab(int tabItem) {
    setState(() {
      widget.currentTab = tabItem;
      switch (tabItem) {
        case 0:
          currentPage = HomeScreen(
            parentScaffoldKey: widget.scaffoldKey,
          );
          // _handleHome();

          break;
        case 1:
          currentPage = PreviousRides(
            parentScaffoldKey: widget.scaffoldKey,
          );
          break;
        case 1:
          currentPage = ScheduleRideScreen(
            parentScaffoldKey: widget.scaffoldKey,
          );
          break;
        case 2:
          currentPage = Account(
            parentScaffoldKey: widget.scaffoldKey,
          );
          break;
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        key: widget.scaffoldKey,
        body: IndexedStack(
          index: widget.currentTab,
          children: [
            HomeScreen(
              parentScaffoldKey: widget.scaffoldKey,
            ),
            PreviousRides(
              parentScaffoldKey: widget.scaffoldKey,
            ),
            ScheduleRideScreen(
              parentScaffoldKey: widget.scaffoldKey,
            ),
            Account(
              parentScaffoldKey: widget.scaffoldKey,
            )
          ],
        ),
        bottomNavigationBar: Container(
          color: AppColors.appColor,
          child: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                icon: new Icon(
                  Icons.home,
                ),
                label: Strings.home,
              ),
              BottomNavigationBarItem(
                icon: new Icon(Icons.ac_unit),
                label: 'Activity',
              ),
              BottomNavigationBarItem(
                icon: new Icon(Icons.history),
                label: 'Rides',
              ),
              BottomNavigationBarItem(
                label: 'Account',
                icon: new Icon(Icons.person),
              ),
            ],
            type: BottomNavigationBarType.fixed, // Fixed
            selectedItemColor: AppColors.green,
            selectedFontSize: 0,
            unselectedFontSize: 0,
            iconSize: 22,
            elevation: 0,
            selectedLabelStyle: AppText.text14w400.copyWith(
              color: AppColors.green,
              fontSize: 14.sp,
            ),
            unselectedLabelStyle: AppText.text14w400.copyWith(
              color: AppColors.grey500,
              fontSize: 14.sp,
            ),
            backgroundColor: Colors.transparent,
            selectedIconTheme: IconThemeData(
              size: 22,
              color: AppColors.green,
            ),
            unselectedItemColor: AppColors.grey500,
            currentIndex: widget.currentTab,
            onTap: (int i) {
              this._selectTab(
                i,
              );
            },
          ),
        ),
        // bottomNavigationBar: Container(
        //   color: AppColors.green,
        //   child: FancyBottomNavigation(
        //     barBackgroundColor: AppColors.green,
        //     circleColor: Colors.white,
        //     inactiveIconColor: Colors.black,
        //     activeIconColor: AppColors.green,
        //     initialSelection: widget.currentTab,
        //     onTabChangedListener: (int i) {
        //       _selectTab(
        //         i,
        //       );
        //     },
        //     tabs: [
        //       TabData(iconData: MyFlutterApp.home, title: Strings.home),
        //       TabData(
        //         iconData: MyFlutterApp.past,
        //         title: Strings.activity,
        //       ),
        //       TabData(iconData: MyFlutterApp.person, title: Strings.account),
        //     ],
        //   ),
        // ),
      ),
    );
  }

  Future<void> _handleHome() async {
    var position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.bestForNavigation)
        // ignore: body_might_complete_normally_catch_error
        .catchError((e) {
      print("error is $e");
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    AppRepository().storeuserlatlong(
      accesstoken: prefs.getString(
        Strings.accesstoken,
      )!,
      user: prefs.getString(
        Strings.userid,
      )!,
      lat: position.latitude.toString(),
      long: position.longitude.toString(),
    );
    getAddressFromLatLng(position.latitude, position.longitude).then((value) {
      if (!mounted) {
        return;
      }

      context.read<DashBoardController>().saveCurrentLocatoin(
          LatLng(position.latitude, position.longitude),
          fulladdress: value);
      context.read<DashBoardController>().callDashboardApi(
            LatLng(position.latitude, position.longitude),
          );
    });
  }
}

final mapApiKey = "AIzaSyD6MRqmdjtnIHn7tyDLX-qsjreaTkuzSCY";

Future<String> getAddressFromLatLng(double lat, double lng) async {
  String _host = 'https://maps.google.com/maps/api/geocode/json';
  final url = '$_host?key=$mapApiKey&language=en&latlng=$lat,$lng';
  if (lat != null && lng != null) {
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      Map data = jsonDecode(response.body);
      String _formattedAddress = data["results"][0]["formatted_address"];
      print("response ==== $_formattedAddress");
      return _formattedAddress;
    } else
      return "";
  } else
    return "";
}
