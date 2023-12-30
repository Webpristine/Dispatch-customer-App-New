import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:multitrip_user/api/app_repository.dart';
import 'package:multitrip_user/app_enverionment.dart';
import 'package:multitrip_user/bottomnavigationbar.dart';
import 'package:multitrip_user/features/book_ride/under_the_ride.dart';
import 'package:multitrip_user/features/rate/rate_driver.dart';
import 'package:multitrip_user/logic/after_booking_controller.dart';
import 'package:multitrip_user/models/booking_history.dart';
import 'package:multitrip_user/shared/shared.dart';
import 'package:multitrip_user/shared/ui/common/app_image.dart';
import 'package:multitrip_user/shared/ui/common/icon_map.dart';
import 'package:multitrip_user/shared/ui/common/spacing.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:provider/provider.dart';
import 'package:timelines/timelines.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../themes/app_text.dart';

class BookingOTP extends StatefulWidget {
  final LatLng pickuplatlong;
  final LatLng droplatlong;
  final LatLng? dropExtralatlong;
  final Set<Polyline>? polylines;
  final String? bookingId;

  const BookingOTP({
    this.polylines,
    required this.droplatlong,
    required this.pickuplatlong,
    this.dropExtralatlong,
    super.key,
    this.bookingId,
  });

  @override
  State<BookingOTP> createState() => _BookingOTPState();
}

class _BookingOTPState extends State<BookingOTP> {
  Set<Marker> markers = {};
  Timer? _timer;
  final _maxSeconds = ValueNotifier<int>(30);
  final _controller = Completer<GoogleMapController>();
  var polyLinesSet = <Polyline>{};
  List<PickupLocation> timeLine = [];

  @override
  void initState() {
    super.initState();
    initMarkers();
    polyLinesSet = widget.polylines ?? <Polyline>{};
    AppRepository().saveAccessToken();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      timeLine = [];
      if (context.read<AfterBookingController>().booking?.pickupLocation !=
          null) {
        // timeLine.add(
        //     context.read<AfterBookingController>().booking!.pickupLocation!);
        context
            .read<AfterBookingController>()
            .booking!
            .dropLocation
            ?.forEach((element) {
          timeLine.add(element);
        });
      }
      print(timeLine);
      _handleWaitingForDriverAssign();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  initMarkers() async {
    markers = {};

    markers.add(
      Marker(
        markerId: const MarkerId('marker_2'),
        draggable: false,
        position: widget.pickuplatlong,
        infoWindow: const InfoWindow(
          title: 'Pick up location',
          snippet: 'Marker Snippet',
        ),
        icon: await pickUpIcon,
      ),
    );
    if (widget.dropExtralatlong != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('marker_3'),
          draggable: false,
          position: widget.dropExtralatlong!,
          infoWindow: const InfoWindow(
            title: 'Secondary Drop Location',
            snippet: 'Marker Snippet',
          ),
          icon: await dropIcon,
        ),
      );
    }
    markers.add(
      Marker(
        markerId: const MarkerId('marker_1'),
        draggable: false,
        position: widget.droplatlong,
        infoWindow: const InfoWindow(
          title: 'Drop Location',
          snippet: 'Marker Snippet',
        ),
        icon: await dropIcon,
      ),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (context.read<AfterBookingController>().booking?.status == 'new') {
          PanaraConfirmDialog.show(context,
              title: "Oops",
              message: "Do you want to cancel the ride?", onTapCancel: () {
            Navigator.pop(context);
          }, onTapConfirm: () async {
            await _handleCancelBooking();
          },
              panaraDialogType: PanaraDialogType.normal,
              barrierDismissible: false,
              cancelButtonText: 'No',
              confirmButtonText: 'yes'
              // optional parameter (default is true)
              );
          return false;
        }

        SystemNavigator.pop();

        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 2,
                child: GoogleMap(
                  polylines: polyLinesSet,
                  markers: markers,
                  gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                    Factory<OneSequenceGestureRecognizer>(
                      () => EagerGestureRecognizer(),
                    ),
                  },
                  onMapCreated: (controller) {
                    _controller.complete(controller);
                    controller.animateCamera(
                      CameraUpdate.newLatLngZoom(
                        LatLng(
                          widget.pickuplatlong.latitude,
                          widget.pickuplatlong.longitude,
                        ),
                        15,
                      ),
                    );
                  },
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      widget.pickuplatlong.latitude,
                      widget.pickuplatlong.longitude,
                    ),
                    zoom: 15.0,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 10.h,
                  ),
                  child: Consumer<AfterBookingController>(
                    builder: (context, model, __) {
                      if (model.booking!.driverMobileNumber?.isEmpty ?? false) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ValueListenableBuilder<int>(
                              valueListenable: _maxSeconds,
                              builder: (context, value, __) {
                                return LinearProgressIndicator();
                              },
                            ),
                            SizedBox(
                              height: 48.h,
                            ),
                            Center(
                              child: Text(
                                  'Please wait , Our drivers will accept your request soon.'),
                            ),
                          ],
                        );
                      }
                      return _renderAssignedDriver(model.booking!);
                    },
                  ),
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _renderAssignedDriver(Bookings model) {
    return ListView(
      shrinkWrap: true,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                getStatus(model.status ?? ''),
                style: GoogleFonts.poppins(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.black,
                ),
              ),
            ),
            if (model.timing?.isNotEmpty ?? false) ...{
              Container(
                height: 36.h,
                width: 48.h,
                padding: EdgeInsets.all(4),
                color: AppColors.green,
                child: Center(
                  child: Text(
                    '${model.timing ?? ''}',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              )
            },
          ],
        ),
        sizedBoxWithHeight(
          10,
        ),
        _renderDistance(model),
        sizedBoxWithHeight(
          10,
        ),
        Divider(),
        sizedBoxWithHeight(
          10,
        ),
        _renderDriver(model),
        sizedBoxWithHeight(
          20,
        ),
        if (isRideCompleted) ...{_renderPaymentNeedToPay(model)},
        if (isPaymentCompleted) ...{_renderRatingTheDriver(model)}
      ],
    );
  }

  Widget _renderDriver(Bookings model) {
    return Row(
      children: [
        AppImage(
          (model.driverProfilePhoto?.isEmpty ?? true)
              ? Images.driver
              : model.driverProfilePhoto!,
          height: 50.h,
          width: 50.w,
        ),
        sizedBoxWithWidth(15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              model.driverName ?? "NA",
              style: AppText.text14w400.copyWith(
                color: AppColors.black,
                fontSize: 14.sp,
              ),
            ),
            RatingBar.builder(
              initialRating: 3.4,
              minRating: 1,
              direction: Axis.horizontal,
              ignoreGestures: true,
              allowHalfRating: true,
              unratedColor: Colors.grey,
              itemCount: 5,
              itemSize: 15,
              itemPadding: EdgeInsets.symmetric(
                horizontal: .0,
              ),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
                size: 10,
              ),
              onRatingUpdate: (rating) {
                print(rating);
              },
            ),
            sizedBoxWithHeight(4),
          ],
        ),
        Spacer(),
        InkWell(
          onTap: () {
            _launchCaller(model.driverMobileNumber ?? '');
          },
          child: Container(
            margin: EdgeInsets.only(
              left: 10.w,
            ),
            child: Icon(
              Icons.phone_in_talk_sharp,
              color: AppColors.black,
              size: 20,
            ),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.greylight,
              shape: BoxShape.circle,
            ),
          ),
        )
      ],
    );
  }

  void _handleWaitingForDriverAssign() {
    if (context.read<AfterBookingController>().booking?.driverMobileNumber !=
        null) {
      _doCurrentRidePolling();
      return;
    }
    _timer = Timer.periodic(Duration(seconds: 15), _handleTimer);
  }

  Future<void> _handleCancelBooking() async {
    Loader.show(context);
    await context.read<AfterBookingController>().cancelBooking(
        bookingId: widget.bookingId,
        onFailure: () {
          Loader.hide();
          context.showSnackBar(context, msg: 'Unable to cancel the ride.');
          Navigator.pop(context);
        },
        onSuccess: () {
          Loader.hide();
          context.showSnackBar(context,
              msg: 'Ride Cancelled Successfully. Please try again');
          Navigator.pop(context);
          _navigateToHomePage();
        });
  }

  void _navigateToHomePage() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => PagesWidget(
            currentTab: 0,
          ),
        ),
        (_) => false);
  }

  String getStatus(String status) {
    /// new / schedule / accept / cancel / arrived / start / complete / payment done / payment received
    switch (status) {
      case 'accept':
        return 'Driver is on the way to pickup you';
      case 'arrived':
        return 'Driver is on the arrived on pickup location';

      case 'start':
        return 'Happy Journey, Be Safe and enjoy the ride.';

      case 'complete':
        return 'We reached to destination. Please pay and rate the driver';

      case 'payment received':
      case 'payment done':
        return 'Thank you for choose us.';

      default:
        return 'Driver is on the way to pickup you';
    }
  }

  void perfromAcction(String status) {
    /// new / schedule / accept / cancel / arrived / start / complete / payment done / payment received
    switch (status) {
      case 'accept':
      case 'arrived':
      case 'start':
      case 'complete':
      case 'payment received':
      default:
    }
  }

  Future<void> _handleTimer(Timer timer) async {
    if (context.read<AfterBookingController>().booking?.bookingId?.isNotEmpty ??
        false) {
      timer.cancel();
      _timer?.cancel();

      return;
    }
    if (_maxSeconds.value <= 0) {
      timer.cancel();
      _timer?.cancel();
      PanaraConfirmDialog.show(context,
          title: "Oops , No Driver Found",
          margin: EdgeInsets.all(24),
          message: "Do you want to cancel the ride?", onTapCancel: () {
        _maxSeconds.value = 30;
        _timer = Timer.periodic(Duration(seconds: 10), _handleTimer);
        Navigator.pop(context);
      }, onTapConfirm: () async {
        timer.cancel();
        _timer?.cancel();
        Navigator.pop(context);
        await _handleCancelBooking();
      },
          panaraDialogType: PanaraDialogType.normal,
          barrierDismissible: false,
          cancelButtonText: 'No',
          confirmButtonText: 'yes'
          // optional parameter (default is true)
          );

      return;
    }

    _maxSeconds.value -= 5;

    await context
        .read<AfterBookingController>()
        .assigingDriver(bookingId: widget.bookingId);
  }

  void _doCurrentRidePolling() async {
    if (mounted) {
      _timer = Timer.periodic(
        Duration(seconds: 5),
        (timer) async {
          if (!mounted) {
            timer.cancel();
            return;
          }
          await context
              .read<AfterBookingController>()
              .pollingTheRide(bookingId: widget.bookingId);

          _handleRideStatus(timer);
        },
      );
    }
  }

  void _handleRideStatus(Timer timer) {
    if (context.read<AfterBookingController>().booking?.status ==
        'payment received') {
      _handlePaymentReceived();
      return;
    }

    if (context.read<AfterBookingController>().booking?.status == 'complete') {
      _handleComplete();

      return;
    }
    if (context.read<AfterBookingController>().booking?.status == 'arrived') {
      _handleRideArrived(timer.tick);
      return;
    }

    if (context.read<AfterBookingController>().booking?.status == 'start') {
      _handleRideStarted(timer.tick);

      return;
    }

    if (context.read<AfterBookingController>().booking?.status == 'accept') {
      _handleRideAccept(timer.tick);

      return;
    }
    if (context.read<AfterBookingController>().booking?.status == 'reject') {
      _navigateToHomePage();

      return;
    }
  }

  void _handleRideAccept(int tick) async {
    final controller = await _controller.future;

    final bookingCtrl = await context.read<AfterBookingController>();

    final driverLat = double.tryParse(bookingCtrl.booking?.driverLat ?? '');
    final driverLong = double.tryParse(bookingCtrl.booking?.driverLong ?? '');

    if (driverLat == null || driverLong == null) {
      return;
    }
// "lat":"12.9791681","long":"77.6437184
    // final testLtLng = LatLng(
    //   12.9791681 + tick / 1000 + 0.00005,
    //   77.6437184 + tick / 1000 + 0.00005,
    // );

    await makePolylinesAndMarker(
      startPoint: PointLatLng(
        driverLat,
        driverLong,
      ),
      endPoint: PointLatLng(
        widget.pickuplatlong.latitude,
        widget.pickuplatlong.longitude,
      ),
    );

    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          zoom: 15,
          target: LatLng(
            driverLat,
            driverLong,
          ),
        ),
      ),
    );
  }

  void _handleRideArrived(int tick) async {
    final controller = await _controller.future;

    final bookingCtrl = await context.read<AfterBookingController>();

    final driverLat = double.tryParse(bookingCtrl.booking?.driverLat ?? '');
    final driverLong = double.tryParse(bookingCtrl.booking?.driverLong ?? '');

    if (driverLat == null || driverLong == null) {
      return;
    }

// "lat":"12.9791681","long":"77.6437184
    // final testLtLng = LatLng(
    //   12.9791681 + tick / 1000 + 0.00005,
    //   77.6437184 + tick / 1000 + 0.00005,
    // );

    await makePolylinesAndMarker(
      startPoint: PointLatLng(
        driverLat,
        driverLong,
      ),
      endPoint: PointLatLng(
        widget.droplatlong.latitude,
        widget.droplatlong.longitude,
      ),
    );

    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          zoom: 15,
          target: LatLng(driverLat, driverLong),
        ),
      ),
    );
  }

  void _handleRideStarted(int tick) async {
    final controller = await _controller.future;

    final bookingCtrl = await context.read<AfterBookingController>();

    final driverLat = double.tryParse(bookingCtrl.booking?.driverLat ?? '');
    final driverLong = double.tryParse(bookingCtrl.booking?.driverLong ?? '');

    if (driverLat == null || driverLong == null) {
      return;
    }

// "lat":"12.9791681","long":"77.6437184
    // final testLtLng = LatLng(
    //   12.9791681 + tick / 1000 + 0.00005,
    //   77.6437184 + tick / 1000 + 0.00005,
    // );

    await makePolylinesAndMarker(
      startPoint: PointLatLng(
        driverLat,
        driverLong,
      ),
      endPoint: PointLatLng(
        widget.droplatlong.latitude,
        widget.droplatlong.longitude,
      ),
    );

    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          zoom: 15,
          target: LatLng(driverLat, driverLong),
        ),
      ),
    );
  }

  Future<void> makePolylinesAndMarker({
    required PointLatLng startPoint,
    required PointLatLng endPoint,
  }) async {
    final polylinePoints = PolylinePoints();

    final resultant = await polylinePoints
        .getRouteBetweenCoordinates(
      "AIzaSyD6MRqmdjtnIHn7tyDLX-qsjreaTkuzSCY",
      startPoint,
      endPoint,
      travelMode: TravelMode.driving,
    )
        .catchError((E) {
      print(E);
      return PolylineResult();
    });

    final polylineCoordinates = <LatLng>[];

    resultant.points.forEach((PointLatLng point) {
      polylineCoordinates.add(LatLng(point.latitude, point.longitude));
    });

    final id = PolylineId("poly");

    final polyline = Polyline(
      width: 2,
      polylineId: id,
      color: Colors.red,
      points: polylineCoordinates,
    );

    markers.add(
      Marker(
        draggable: false,
        markerId: MarkerId('driver_marker'),
        position: polylineCoordinates.tryFirst ??
            LatLng(startPoint.latitude, startPoint.longitude),
        infoWindow: const InfoWindow(
          title: 'Driver location',
          snippet: 'Marker Snippet',
        ),
        icon: await driverIcon,
      ),
    );
    polyLinesSet = {polyline};

    setState(() {});
  }

  void _handleComplete() async {
    markers.remove(
      Marker(markerId: MarkerId('driver_marker')),
    );

    final controller = await _controller.future;

    final polylinePoints = PolylinePoints();

    final bookingCtrl = await context.read<AfterBookingController>();

    final driverLat = double.tryParse(bookingCtrl.booking?.driverLat ?? '');
    final driverLong = double.tryParse(bookingCtrl.booking?.driverLong ?? '');

    if (driverLat == null || driverLong == null) {
      return;
    }

// "lat":"12.9791681","long":"77.6437184

    await makePolylinesAndMarker(
      startPoint: PointLatLng(
        driverLat,
        driverLong,
      ),
      endPoint: PointLatLng(
        widget.droplatlong.latitude,
        widget.droplatlong.longitude,
      ),
    );
    final resultant = await polylinePoints
        .getRouteBetweenCoordinates(
      "AIzaSyD6MRqmdjtnIHn7tyDLX-qsjreaTkuzSCY",
      PointLatLng(
        widget.pickuplatlong.latitude,
        widget.pickuplatlong.longitude,
      ),
      PointLatLng(widget.droplatlong.latitude, widget.droplatlong.longitude),
      travelMode: TravelMode.driving,
    )
        .catchError((E) {
      print(E);
      return PolylineResult();
    });

    final polylineCoordinates = <LatLng>[];

    resultant.points.forEach((PointLatLng point) {
      polylineCoordinates.add(LatLng(point.latitude, point.longitude));
    });

    final id = PolylineId("poly");

    final polyline = Polyline(
      width: 2,
      polylineId: id,
      color: Colors.red,
      points: polylineCoordinates,
    );

    polyLinesSet = {polyline};

    setState(() {});
  }

  void _handlePaymentReceived() {
    _handlePaymentReceived();
  }

  _launchCaller(String mobile) async {
    final launchUri = Uri(
      scheme: 'tel',
      path: mobile,
    );
    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      } else {}
    } catch (e) {}
  }

  Widget _renderDistance(Bookings model) {
    return Column(
      children: [
        Timeline.tileBuilder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: NeverScrollableScrollPhysics(),
          theme: TimelineThemeData(
              indicatorTheme:
                  IndicatorThemeData(size: 12.r, color: Colors.green),
              connectorTheme: ConnectorThemeData(color: AppColors.greydark),
              indicatorPosition: 0,
              nodePosition: 0),
          builder: TimelineTileBuilder.connectedFromStyle(
            contentsAlign: ContentsAlign.basic,
            indicatorStyleBuilder: (_, __) =>
                __ == 0 ? IndicatorStyle.outlined : IndicatorStyle.dot,
            lastConnectorStyle: ConnectorStyle.transparent,
            connectorStyleBuilder: (__, v) => v == ((timeLine.length) - 1)
                ? ConnectorStyle.transparent
                : ConnectorStyle.solidLine,
            contentsBuilder: (context, _index) => Padding(
              padding: EdgeInsets.only(left: 4.w, bottom: 10.h),
              child: Text(
                timeLine[_index].address ?? 'NA',
                style: AppText.text14w400.copyWith(fontSize: 12.sp),
              ),
            ),
            itemCount: timeLine.length,
          ),
        )
      ],
    );
  }

  bool get isRideCompleted =>
      context.read<AfterBookingController>().booking?.status == 'complete';
  bool get isPaymentCompleted =>
      context.read<AfterBookingController>().booking?.status ==
          'payment received' ||
      context.read<AfterBookingController>().booking?.status == 'payment done';

  Widget _renderPaymentNeedToPay(Bookings model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "Payment",
              style: GoogleFonts.poppins(
                color: AppColors.black,
                fontSize: 16.sp,
                fontWeight: FontWeight.w300,
              ),
            ),
            SizedBox(
              width: 12,
            ),
            Image.asset(
              'assets/money.png',
              height: 24.h,
            ),
          ],
        ),
        SizedBox(
          height: 12,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Ride Charges",
              style: GoogleFonts.poppins(
                color: AppColors.greydark,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              "\$ ${model.amount ?? '0'}",
              style: GoogleFonts.poppins(
                color: AppColors.black,
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Waiting Charges",
              style: GoogleFonts.poppins(
                color: AppColors.greydark,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              "\$ ${model.waitingCharges ?? 0}",
              style: GoogleFonts.poppins(
                color: AppColors.black,
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
              ),
            )
          ],
        )
      ],
    );
  }

  Widget _renderRatingTheDriver(Bookings model) {
    return GestureDetector(
      onTap: () {
        _timer?.cancel();
        AppEnvironment.navigator.pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => RateDriver(model: model)),
            (route) => false);
      },
      child: Container(
        width: double.infinity,
        color: AppColors.green,
        margin: EdgeInsets.symmetric(vertical: 12.h),
        child: Column(
          children: [
            Text(
              "Thanks For riding with ${model.driverName}",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Text(
              "We hope you enjoyed your ride.\nClick here to rate me !! ",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
              ),
            )
          ],
        ),
      ),
    );
  }
}
