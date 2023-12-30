import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:multitrip_user/api/app_repository.dart';
import 'package:multitrip_user/app_enverionment.dart';
import 'package:multitrip_user/blocs/bookride/bookride_bloc.dart';
import 'package:multitrip_user/bottomnavigationbar.dart';
import 'package:multitrip_user/features/book_ride/booking_otp.dart';
import 'package:multitrip_user/logic/after_booking_controller.dart';
import 'package:multitrip_user/shared/shared.dart';
import 'package:multitrip_user/shared/ui/common/icon_map.dart';
import 'package:multitrip_user/shared/ui/common/spacing.dart';
import 'package:multitrip_user/themes/app_text.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

class SelectRider extends StatefulWidget {
  final String bookingid;
  final String amount;
  final LatLng pickuplatlong;
  final LatLng droplatlong;
  final LatLng? dropExtralatlong;
  final Set<Polyline> polylines;
  final String vehicleid;
  const SelectRider(
      {super.key,
      required this.amount,
      required this.polylines,
      required this.droplatlong,
      required this.pickuplatlong,
      required this.bookingid,
      required this.vehicleid,
      this.dropExtralatlong});

  @override
  State<SelectRider> createState() => _SelectRiderState();
}

class _SelectRiderState extends State<SelectRider> {
  BookrideBloc bookrideBloc = BookrideBloc();
  Set<Marker> markers = {};

  @override
  void initState() {
    bookrideBloc = BlocProvider.of<BookrideBloc>(context);
    super.initState();
    initMarkers();
    AppRepository().saveAccessToken();
  }

  @override
  void dispose() {
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
            title: 'Pick up location', snippet: 'Marker Snippet'),
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

    setState(() {});
  }

  TextEditingController notecontroller = TextEditingController();
  _handleOnBackPress() async {
    if (widget.bookingid.isNotEmpty) {
      await PanaraConfirmDialog.show(context,
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
  }

  Future<void> _handleCancelBooking() async {
    Loader.show(context);
    await context.read<AfterBookingController>().cancelBooking(
        bookingId: widget.bookingid,
        onFailure: () {
          Loader.hide();
          context.showSnackBar(context, msg: 'Unable to cancel the ride.');
          Navigator.pop(context);
        },
        onSuccess: () {
          Loader.hide();
          context.showSnackBar(context,
              msg: 'Ride Cancelled Successfully. Please try again');
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await _handleOnBackPress();
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        body: BlocListener<BookrideBloc, BookrideState>(
          listener: (context, state) {
            if (state is BookRideLoading) {
              Loader.show(
                context,
              );
            } else if (state is BookRideFail) {
              Loader.hide();
              context.showSnackBar(context, msg: state.error);
            } else if (state is BookRideLoaded) {
              Loader.hide();
              AppEnvironment.navigator.push(
                MaterialPageRoute(
                  builder: (context) => BookingOTP(
                    droplatlong: widget.droplatlong,
                    pickuplatlong: widget.pickuplatlong,
                    polylines: widget.polylines,
                    bookingId: widget.bookingid,
                  ),
                ),
              );
            } else if (state is TokenExpired) {
              Loader.hide();
            }
          },
          child: SafeArea(
            child: Stack(
              children: [
                GoogleMap(
                  polylines: widget.polylines,
                  zoomGesturesEnabled: true,
                  zoomControlsEnabled: false,
                  markers: markers,
                  gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                    Factory<OneSequenceGestureRecognizer>(
                      () => EagerGestureRecognizer(),
                    ),
                  },
                  onMapCreated: (controller) {
                    controller.animateCamera(
                      CameraUpdate.newLatLngZoom(
                        LatLng(
                          widget.pickuplatlong.latitude,
                          widget.pickuplatlong.longitude,
                        ),
                        8,
                      ),
                    );
                  },
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      widget.pickuplatlong.latitude,
                      widget.pickuplatlong.longitude,
                    ),
                    zoom: 8.0,
                  ),
                ),
                // Container(
                //   height: 40.h,
                //   width: 40.w,
                //   margin: EdgeInsets.only(
                //     top: 10.h,
                //     left: 8.w,
                //   ),
                //   child: Center(
                //     child: GestureDetector(
                //       onTap: ()=>,
                //       child: Icon(
                //         Icons.arrow_back,
                //         color: AppColors.black,
                //       ),
                //     ),
                //   ),
                //   decoration: BoxDecoration(
                //     shape: BoxShape.circle,
                //     color: Colors.white,
                //   ),
                // ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 300.h,
                    width: double.infinity,
                    color: Colors.white,
                    padding: EdgeInsets.only(
                      top: 10.h,
                      left: 16.w,
                      bottom: 10.h,
                      right: 16.w,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.greylight,
                            borderRadius: BorderRadius.circular(
                              20,
                            ),
                          ),
                          child: TextFormField(
                            cursorColor: AppColors.grey500,
                            controller: notecontroller,
                            decoration: InputDecoration(
                              hintText: "Any pickup notes?",
                              hintStyle: GoogleFonts.poppins(
                                color: AppColors.grey500,
                                height:
                                    1.4, //                                <----- this was the key

                                fontSize: 13.sp,
                                fontWeight: FontWeight.normal,
                              ),
                              contentPadding: EdgeInsets.only(
                                left: 10.w,
                                bottom: 4.h,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "Total Amount ",
                              style: GoogleFonts.poppins(
                                color: AppColors.black,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              "${widget.amount}\$",
                              style: GoogleFonts.poppins(
                                color: AppColors.black,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
                color: Colors.grey.shade300,
                offset: Offset(0, -3),
                spreadRadius: 0,
                blurRadius: 4)
          ]),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.money_outlined,
                      color: AppColors.green,
                      size: 40.h,
                    ),
                    sizedBoxWithWidth(10),
                    Text(
                      "Cash",
                      style: AppText.text15Normal.copyWith(
                        color: AppColors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Spacer(),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.black,
                      size: 16.h,
                    )
                  ],
                ),
                InkWell(
                  onTap: () {
                    bookrideBloc.add(
                      DoBookRide(
                        bookingid: widget.bookingid,
                        notes: notecontroller.text,
                        payment_mode: "cash",
                        vehicleid: widget.vehicleid,
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(
                      top: 10.h,
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: 15.h,
                    ),
                    child: Center(
                      child: Text(
                        "Confirm ride",
                        style:
                            AppText.text15Normal.copyWith(color: Colors.white),
                      ),
                    ),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.green,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
