import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:multitrip_user/features/book_ride/add_vehicle.dart';
import 'package:multitrip_user/features/book_ride/booking_otp.dart';
import 'package:multitrip_user/logic/vehicle/vehicle_controller.dart';
import 'package:multitrip_user/models/address.dart';
import 'package:multitrip_user/shared/shared.dart';
import 'package:multitrip_user/shared/ui/common/icon_map.dart';
import 'package:multitrip_user/shared/ui/common/spacing.dart';
import 'package:multitrip_user/themes/app_text.dart';
import 'package:provider/provider.dart';

class ScheduleVehicle extends StatefulWidget {
  final String pickuptime;
  final double droplat;
  final double pickuplat;
  final double pickuplong;
  final double droplong;
  final String pickupdate;
  final dynamic pickuplocation;
  final LatLng? extraDropLatLng;
  final LatLng? secnodDropLatLong;
  final dynamic droplocation;
  const ScheduleVehicle(
      {super.key,
      required this.pickuplocation,
      required this.droplocation,
      required this.pickuptime,
      required this.droplat,
      required this.droplong,
      required this.pickuplat,
      this.extraDropLatLng,
      this.secnodDropLatLong,
      required this.pickuplong,
      required this.pickupdate});

  @override
  State<ScheduleVehicle> createState() => _ScheduleVehicleState();
}

class _ScheduleVehicleState extends State<ScheduleVehicle> {
  Uint8List? custommarker;
  Future<Uint8List> getBytesFromAsset(String path) async {
    double pixelRatio = MediaQuery.of(context).devicePixelRatio;
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: pixelRatio.round() * 30);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  getmarker() async {
    try {
      final Uint8List markerIcon = await getBytesFromAsset('assets/drop.png');
      setState(() {
        custommarker = markerIcon;
      });
    } catch (e) {}
  }

  VehicleController controller = VehicleController();
  PolylinePoints polylinePoints = PolylinePoints();
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];

  addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        width: 2,
        polylineId: id,
        color: Colors.black,
        points: polylineCoordinates);
    polylines[id] = polyline;
    setState(() {});
  }

  void makeLines() async {
    final resultant = await polylinePoints.getRouteBetweenCoordinates(
        "AIzaSyD6MRqmdjtnIHn7tyDLX-qsjreaTkuzSCY",
        PointLatLng(widget.pickuplat, widget.pickuplong), //Starting LATLANG
        PointLatLng(widget.droplat, widget.droplong), //End LATLANG
        travelMode: TravelMode.driving,
        wayPoints: [
          if (widget.extraDropLatLng != null) ...{
            PolylineWayPoint(
              stopOver: true,
              location:
                  '${widget.extraDropLatLng!.latitude},${widget.extraDropLatLng!.longitude}',
            )
          },
          // ignore: body_might_complete_normally_catch_error
        ]).catchError((E) {
      print(E);
    });

    resultant.points.forEach((PointLatLng point) {
      polylineCoordinates.add(LatLng(point.latitude, point.longitude));
    });

    addPolyLine();
    initMarkers();
  }

  int selectedvalue = 0;
  String? vehicleid;
  Set<Marker> markers = {};

  initMarkers() async {
    markers = {};

    markers.add(
      Marker(
        markerId: const MarkerId('marker_2'),
        draggable: false,
        position: LatLng(
          widget.pickuplat,
          widget.pickuplong,
        ),
        infoWindow: const InfoWindow(
            title: 'Pick up location', snippet: 'Marker Snippet'),
        icon: await pickUpIcon,
      ),
    );
    if (widget.extraDropLatLng != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('marker_3'),
          draggable: false,
          position: LatLng(
            widget.extraDropLatLng!.latitude,
            widget.extraDropLatLng!.longitude,
          ),
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
        position: LatLng(
          widget.droplat,
          widget.droplong,
        ),
        infoWindow: const InfoWindow(
          title: 'Drop Location',
          snippet: 'Marker Snippet',
        ),
        icon: await dropIcon,
      ),
    );

    setState(() {});
  }

  @override
  void initState() {
    controller = Provider.of<VehicleController>(context, listen: false);

    getmarker();
    controller.getvehicles(context: context);
    makeLines();
    initMarkers();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);

        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              GoogleMap(
                polylines: Set<Polyline>.of(polylines.values),
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
                        widget.pickuplat,
                        widget.pickuplong,
                      ),
                      getZoomLevel(
                        LatLng(widget.pickuplat, widget.pickuplong),
                        LatLng(widget.droplat, widget.droplong),
                        MediaQuery.of(context).size.width,
                      ),
                    ),
                  );
                },
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    widget.pickuplat,
                    widget.pickuplong,
                  ),
                  zoom: getZoomLevel(
                    LatLng(widget.pickuplat, widget.pickuplong),
                    LatLng(widget.droplat, widget.droplong),
                    MediaQuery.of(context).size.width,
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  Navigator.pop(context);
                },
                child: Container(
                  height: 40.h,
                  width: 40.w,
                  margin: EdgeInsets.only(
                    top: 10.h,
                    left: 8.w,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.arrow_back,
                      color: AppColors.black,
                    ),
                  ),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  // height: 300.h,
                  constraints: BoxConstraints(
                    maxHeight: 270.h,
                    //maximum height set to 100% of vertical height

                    //maximum width set to 100% of width
                  ),
                  width: double.infinity,
                  color: Colors.white,
                  padding: EdgeInsets.only(
                    top: 10.h,
                    left: 16.w,
                    bottom: 10.h,
                    right: 16.w,
                  ),
                  child: Consumer<VehicleController>(
                    builder: (context, value, child) {
                      if (value.isloading) {
                        Loader.show(context,
                            progressIndicator: CircularProgressIndicator(
                              color: AppColors.appColor,
                            ));
                      } else {
                        if (controller.vehicles?.vehicles.isEmpty ?? true) {
                          return SizedBox();
                        }
                        return ListView.separated(
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            vehicleid = controller.vehicles!.vehicles
                                .elementAt(index)
                                .vehicleId;
                            return Slidable(
                              key: const ValueKey(0),

                              // The start action pane is the one at the left or the top side.
                              endActionPane: ActionPane(
                                // A motion is a widget used to control how the pane animates.
                                motion: const ScrollMotion(),

                                // A pane can dismiss the Slidable.
                                //  dismissible: DismissiblePane(onDismissed: () {}),

                                // All actions are defined in the children parameter.
                                children: [
                                  // A SlidableAction can have an icon and/or a label.
                                  SlidableAction(
                                    onPressed: (BuildContext context) async {
                                      controller.deletevehicle(
                                          context: context,
                                          vehicle_id: controller
                                              .vehicles!.vehicles
                                              .elementAt(index)
                                              .vehicleId);
                                    },
                                    backgroundColor: Color(0xFFFE4A49),
                                    foregroundColor: Colors.white,
                                    icon: Icons.delete,
                                    label: 'Delete',
                                  ),
                                ],
                              ),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    selectedvalue = index;
                                    vehicleid = controller.vehicles!.vehicles
                                        .elementAt(index)
                                        .vehicleId;
                                  });
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CircleAvatar(
                                      radius: 25,
                                      backgroundColor: AppColors.greylight,
                                      backgroundImage: Svg(
                                        "assets/1299198.svg",
                                      ),
                                    ),
                                    sizedBoxWithWidth(10),
                                    Flexible(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            value.vehicles!.vehicles
                                                .elementAt(index)
                                                .vehicleName,
                                            maxLines: 2,
                                            style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16.sp),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                value.vehicles!.vehicles
                                                    .elementAt(index)
                                                    .vehicleNumber,
                                                maxLines: 2,
                                                style: GoogleFonts.poppins(
                                                    color: AppColors.grey500,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 13.sp),
                                              ),
                                              Text(
                                                value.vehicles!.vehicles
                                                    .elementAt(index)
                                                    .vehicleColor,
                                                maxLines: 2,
                                                style: GoogleFonts.poppins(
                                                    color: AppColors.grey500,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 13.sp),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            value.vehicles!.vehicles
                                                .elementAt(index)
                                                .vehicleType,
                                            style: GoogleFonts.poppins(
                                                color: AppColors.grey500,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 13.sp),
                                          )
                                        ],
                                      ),
                                    ),
                                    const Spacer(),
                                    Container(
                                      height: 20.h,
                                      width: 20.w,
                                      child: Icon(
                                        Icons.circle,
                                        color: selectedvalue == index
                                            ? Colors.white
                                            : AppColors.black,
                                        size: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.black,
                                        shape: BoxShape.circle,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return Divider();
                          },
                          itemCount: value.vehicles!.vehicles.length,
                        ).animate().slideX(duration: 400.ms);
                      }
                      return SizedBox();
                    },
                  ),
                ),
              )
            ],
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
                Padding(
                  padding: EdgeInsets.only(
                    bottom: 0.h,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => AddVehicle(),
                            ),
                          );
                        },
                        child: Text(
                          "Add Vehicle + ",
                          style: GoogleFonts.poppins(
                            color: AppColors.green,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    if (vehicleid == null) {
                      context.showSnackBar(context,
                          msg: "Please Add Atleast one Vehicle");
                    } else {
                      //TODO : Schedule Ride will Call from Here
                      controller.scheduleride(
                        context: context,
                        droplocation: widget.droplocation,
                        pickuplocation: widget.pickuplocation,
                        schedule_date: widget.pickupdate,
                        vehicleid: vehicleid!,
                        schedule_time: widget.pickuptime,
                      );
                    }
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
