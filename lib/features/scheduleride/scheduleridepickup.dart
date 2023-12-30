import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:multi_value_listenable_builder/multi_value_listenable_builder.dart';
import 'package:multitrip_user/app_enverionment.dart';
import 'package:multitrip_user/blocs/address/address_bloc.dart' as address;
import 'package:multitrip_user/blocs/confirmride/confirmride_bloc.dart';
import 'package:multitrip_user/blocs/member/member_bloc.dart';
import 'package:multitrip_user/bottomnavigationbar.dart';
import 'package:multitrip_user/features/book_ride/vehiclelist.dart';
import 'package:multitrip_user/features/book_ride/widgets/membersSheet.dart';
import 'package:multitrip_user/features/scheduleride/schedulevehicle.dart';
import 'package:multitrip_user/models/address.dart';
import 'package:multitrip_user/shared/shared.dart';
import 'package:multitrip_user/shared/ui/common/app_image.dart';

import 'package:multitrip_user/shared/ui/common/spacing.dart';
import 'package:multitrip_user/themes/app_text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_modal_sheet/top_modal_sheet.dart';

import '../../api/app_repository.dart';
import '../../blocs/locationbloc/location_bloc_bloc.dart';

class ScheduleRidePickupDropAddress extends StatefulWidget {
  final String pickupaddess;
  final double lat;
  final String pickuptime;
  final double long;
  final String pickupdate;
  final AddressElement? dropLocation;
  const ScheduleRidePickupDropAddress(
      {super.key,
      required this.pickupaddess,
      required this.pickuptime,
      required this.lat,
      required this.long,
      this.dropLocation,
      required this.pickupdate});

  @override
  State<ScheduleRidePickupDropAddress> createState() =>
      _ScheduleRidePickupDropAddressState();
}

class _ScheduleRidePickupDropAddressState
    extends State<ScheduleRidePickupDropAddress> {
  late GoogleMapController googleMapController;
  final _controller = TextEditingController();
  final _secondController = TextEditingController();
  final _thirdController = TextEditingController();

  Position? position;
  double dividerHeight = 50.h;
  int enabledfield = 1;
  bool pickenabled = true;
  bool extraFieldEnabled = false;

  bool dropenable = false;
  bool secondenable = false;
  bool thirdenable = false;

  int currentTextField = 0;
  bool ismapvisible = false;

  final isExtraTextfieldVisible = ValueNotifier(false);
  final isExtraTextfieldVisible1 = ValueNotifier(false);
  final isExtraTextfieldVisible2 = ValueNotifier(false);
  final isaddgone = ValueNotifier(false);

  TextEditingController pickupController = TextEditingController();
  TextEditingController dropController = TextEditingController();
  LocationBlocBloc locationBlocBloc = LocationBlocBloc();
  MemberBloc memberBloc = MemberBloc();

  late LatLng pickuplatlong;
  LatLng? droplatlong;
  LatLng? extraDropLatLong;
  LatLng? secnodDropLatLong;
  LatLng? thirdDropLatLong;

  final textFields = <Widget>[];

  @override
  void initState() {
    print("Date is ${widget.pickupdate}");
    pickuplatlong = LatLng(widget.lat, widget.long);
    pickupController.text = widget.pickupaddess;
    fetchlocation();

    locationBlocBloc = BlocProvider.of<LocationBlocBloc>(context);
    memberBloc = BlocProvider.of<MemberBloc>(context);
    super.initState();
    _addTextFields();
    BlocProvider.of<address.AddressBloc>(context).add(address.FetchAddress());
    if (widget.dropLocation != null && widget.dropLocation?.placeId != null) {
      dropController.text = widget.dropLocation!.addressLine2;

      dropController.selection =
          TextSelection.collapsed(offset: dropController.text.length);

      locationBlocBloc.add(
        FetchDropLatlong(placeId: widget.dropLocation!.placeId!),
      );
    }
  }

  Future<void> fetchlocation() async {
    position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.medium,
    );
    SharedPreferences prefs = await SharedPreferences.getInstance();
    AppRepository().storeuserlatlong(
      accesstoken: prefs.getString(
        Strings.accesstoken,
      )!,
      user: prefs.getString(
        Strings.userid,
      )!,
      lat: position!.latitude.toString(),
      long: position!.longitude.toString(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _secondController.dispose();
    _thirdController.dispose();
    super.dispose();
  }

  void _addTextFields() {
    textFields.addAll(
      [
        ValueListenableBuilder(
            key: ValueKey('text_1'),
            valueListenable: isExtraTextfieldVisible,
            builder: (_, bool val, __) {
              return Visibility(
                visible: val,
                child: Container(
                  width: 270.w,
                  margin: const EdgeInsets.only(bottom: 10, top: 10),
                  child: Row(
                    children: [
                      Flexible(
                        child: Container(
                          color: Colors.grey.shade300,
                          child: TextFormField(
                            controller: _controller,
                            onTap: () {
                              setState(() {
                                pickenabled = false;
                                dropenable = false;

                                secondenable = false;
                                thirdenable = false;
                                extraFieldEnabled = true;
                              });
                            },
                            onChanged: (value) {
                              BlocProvider.of<LocationBlocBloc>(context).add(
                                FetchSuggestions(query: value),
                              );
                            },
                            cursorColor: AppColors.grey500,
                            decoration: InputDecoration(
                              isDense: true,
                              hintText: "Where to 2?",
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 15) +
                                      EdgeInsets.only(
                                        left: 10.w,
                                      ),
                              hintStyle: AppText.text14w400.copyWith(
                                fontSize: 14.sp,
                                color: AppColors.grey500,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AppImage(
                          "assets/sort.svg",
                          height: 32.h,
                          width: 48.w,
                        ),
                      ),
                      sizedBoxWithWidth(5),
                      InkWell(
                        onTap: () {
                          isExtraTextfieldVisible.value = false;
                          isaddgone.value = false;
                          setState(() {
                            enabledfield--;
                          });
                          _controller.clear();

                          // setState(() {
                          //   dividerHeight -= 50.h;
                          // });
                        },
                        child: Icon(
                          Icons.close,
                          color: AppColors.black,
                          size: 18.r,
                        ),
                      )
                    ],
                  ),
                ),
              );
            }),
        ValueListenableBuilder(
            key: ValueKey('text_3'),
            valueListenable: isExtraTextfieldVisible1,
            builder: (_, bool val, __) {
              return Visibility(
                visible: val,
                child: Container(
                  width: 270.w,
                  margin: const EdgeInsets.only(bottom: 10, top: 10),
                  child: Row(
                    children: [
                      Flexible(
                        child: Container(
                          color: Colors.grey.shade300,
                          child: TextFormField(
                            controller: _secondController,
                            onTap: () {
                              setState(() {
                                pickenabled = false;
                                dropenable = false;
                                secondenable = false;
                                thirdenable = true;
                                extraFieldEnabled = false;
                              });
                            },
                            onChanged: (value) {
                              BlocProvider.of<LocationBlocBloc>(context).add(
                                FetchSuggestions(query: value),
                              );
                            },
                            cursorColor: AppColors.grey500,
                            decoration: InputDecoration(
                              isDense: true,
                              hintText: "Where to 3?",
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 15) +
                                      EdgeInsets.only(
                                        left: 10.w,
                                      ),
                              hintStyle: AppText.text14w400.copyWith(
                                fontSize: 14.sp,
                                color: AppColors.grey500,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AppImage(
                          "assets/sort.svg",
                          height: 32.h,
                          width: 48.w,
                        ),
                      ),
                      sizedBoxWithWidth(5),
                      InkWell(
                        onTap: () {
                          isExtraTextfieldVisible1.value = false;
                          isaddgone.value = false;
                          _secondController.clear();
                          setState(() {
                            enabledfield--;
                          });

                          // setState(() {
                          //   dividerHeight -= 50.h;
                          // });
                        },
                        child: Icon(
                          Icons.close,
                          color: AppColors.black,
                          size: 18.r,
                        ),
                      )
                    ],
                  ),
                ),
              );
            }),
        ValueListenableBuilder(
            key: ValueKey('text_4'),
            valueListenable: isExtraTextfieldVisible2,
            builder: (_, bool val, __) {
              return Visibility(
                visible: val,
                child: Container(
                  width: 270.w,
                  margin: const EdgeInsets.only(bottom: 10, top: 10),
                  child: Row(
                    children: [
                      Flexible(
                        child: Container(
                          color: Colors.grey.shade300,
                          child: TextFormField(
                            controller: _thirdController,
                            onTap: () {
                              setState(() {
                                pickenabled = false;
                                dropenable = false;
                                secondenable = true;
                                thirdenable = false;

                                extraFieldEnabled = false;
                              });
                            },
                            onChanged: (value) {
                              BlocProvider.of<LocationBlocBloc>(context).add(
                                FetchSuggestions(query: value),
                              );
                            },
                            cursorColor: AppColors.grey500,
                            decoration: InputDecoration(
                              isDense: true,
                              hintText: "Where to 4?",
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 15) +
                                      EdgeInsets.only(
                                        left: 10.w,
                                      ),
                              hintStyle: AppText.text14w400.copyWith(
                                fontSize: 14.sp,
                                color: AppColors.grey500,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AppImage(
                          "assets/sort.svg",
                          height: 32.h,
                          width: 48.w,
                        ),
                      ),
                      sizedBoxWithWidth(5),
                      InkWell(
                        onTap: () {
                          isExtraTextfieldVisible2.value = false;
                          isaddgone.value = false;
                          _thirdController.clear();
                          setState(() {
                            enabledfield--;
                          });
                          // setState(() {
                          //   dividerHeight -= 50.h;
                          // });
                        },
                        child: Icon(
                          Icons.close,
                          color: AppColors.black,
                          size: 18.r,
                        ),
                      )
                    ],
                  ),
                ),
              );
            }),
        Row(
          key: ValueKey('text_2'),
          children: [
            Flexible(
              child: Container(
                color: Colors.grey.shade300,
                child: TextFormField(
                  controller: dropController,
                  onTap: () {
                    setState(() {
                      pickenabled = false;
                      dropenable = true;
                      secondenable = false;
                      thirdenable = false;
                      extraFieldEnabled = false;
                    });
                    if (pickupController.text == "") {
                      setState(() {
                        pickupController.text = widget.pickupaddess;
                      });
                    }

                    locationBlocBloc.add(ClearSuggestionList());
                    //  locationProvider.changepickupordrop(value: "Drop");
                  },
                  onChanged: (value) {
                    BlocProvider.of<LocationBlocBloc>(context)
                        .add(FetchSuggestions(query: value));
                  },
                  cursorColor: AppColors.grey500,
                  decoration: InputDecoration(
                    hintText: "Where to 1?",
                    hintStyle: AppText.text14w400.copyWith(
                      fontSize: 14.sp,
                      color: AppColors.grey500,
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 15) +
                        EdgeInsets.only(
                          left: 10.w,
                        ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AppImage(
                "assets/sort.svg",
                height: 32.h,
                width: 48.w,
              ),
            ),
            // isExtraTextfieldVisible.value &&
            //         isExtraTextfieldVisible1.value &&
            //         isExtraTextfieldVisible2.value &&
            //         isExtraTextfieldVisible3.value
            //     ? sizedBoxWithWidth(24)
            //     :
            MultiValueListenableBuilder(
                valueListenables: [
                  isExtraTextfieldVisible,
                  isExtraTextfieldVisible1,
                  isExtraTextfieldVisible2,
                  isaddgone
                ],
                builder: (context, snapshot, __) {
                  if (snapshot.elementAt(0)) {
                    return InkWell(
                      onTap: () {
                        if (isExtraTextfieldVisible1.value) {
                          isExtraTextfieldVisible2.value = true;
                          isaddgone.value = true;
                          setState(() {
                            enabledfield++;
                          });

                          // setState(() {
                          //   dividerHeight += 50.h;
                          // });
                        } else if (isExtraTextfieldVisible.value) {
                          isExtraTextfieldVisible1.value = true;
                          setState(() {
                            enabledfield++;
                          });
                          // setState(() {
                          //   dividerHeight += 50.h;
                          // });
                        } else {}
                        // setState(() {
                        //   if (isExtraTextfieldVisible1.value ||
                        //       isExtraTextfieldVisible2.value ||
                        //       isExtraTextfieldVisible.value ||
                        //       isExtraTextfieldVisible3.value) {
                        //   } else {
                        //   }
                        // });
                      },
                      child: isaddgone.value
                          ? SizedBox(
                              width: 24,
                            )
                          : Icon(
                              Icons.add,
                              color: AppColors.black,
                              size: 24.r,
                            ),
                    );
                  }
                  return SizedBox();
                }),
            // ValueListenableBuilder(
            //     valueListenable: isExtraTextfieldVisible1,
            //     builder: (context, snapshot, __) {
            //       if (snapshot) {
            //         return SizedBox(
            //           width: 24.w,
            //         );
            //       }
            //       return SizedBox();
            //     })
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        dropController.text = "";
        pickupController.text = '';
        Navigator.pop(context);
        return false;
      },
      child: KeyboardVisibilityBuilder(
        builder: (p0, isKeyboardVisible) {
          if (isKeyboardVisible == true) {
            ismapvisible = false;
          }
          return Scaffold(
            resizeToAvoidBottomInset: false,
            bottomNavigationBar: GestureDetector(
              onTap: () {
                if (pickupController.text.isEmpty && pickuplatlong == null) {
                  context.showSnackBar(context,
                      msg: "Please Add or change Pickup Address");
                  return;
                }
                if (dropController.text.isEmpty || droplatlong == null) {
                  context.showSnackBar(context,
                      msg: "Please Add or change Drop Address");
                  return;
                }

                if (isExtraTextfieldVisible.value && _controller.text.isEmpty) {
                  context.showSnackBar(context,
                      msg: "Please Add or change Additional Drop Address");
                  return;
                }
                if (isExtraTextfieldVisible1.value &&
                    _secondController.text.isEmpty) {
                  context.showSnackBar(context,
                      msg: "Please Add or change Additional Drop Address");
                  return;
                }
                if (isExtraTextfieldVisible2.value &&
                    _thirdController.text.isEmpty) {
                  context.showSnackBar(context,
                      msg: "Please Add or change Additional Drop Address");
                  return;
                }
                var mapList = [];
                if (droplatlong != null) {
                  mapList.add(
                    {
                      "lat": droplatlong?.latitude.toString(),
                      "long": droplatlong?.longitude.toString(),
                      "address": dropController.text
                    },
                  );
                }
                if (extraDropLatLong != null) {
                  mapList.add({
                    "lat": extraDropLatLong?.latitude.toString(),
                    "long": extraDropLatLong?.longitude.toString(),
                    "address": _controller.text
                  });
                }
                if (secnodDropLatLong != null) {
                  mapList.add({
                    "lat": secnodDropLatLong?.latitude.toString(),
                    "long": secnodDropLatLong?.longitude.toString(),
                    "address": _secondController.text
                  });
                }
                if (thirdDropLatLong != null) {
                  mapList.add({
                    "lat": secnodDropLatLong?.latitude.toString(),
                    "long": secnodDropLatLong?.longitude.toString(),
                    "address": _thirdController.text
                  });
                }

                AppEnvironment.navigator.push(
                  MaterialPageRoute(
                    builder: (context) => ScheduleVehicle(
                        pickuplocation: jsonEncode(
                          {
                            "lat": pickuplatlong.latitude.toString(),
                            "long": pickuplatlong.longitude.toString(),
                            "address": pickupController.text
                          },
                        ),
                        droplocation: jsonEncode(mapList),
                        pickuptime: widget.pickuptime,
                        droplat: droplatlong!.latitude,
                        pickuplat: pickuplatlong.latitude,
                        pickuplong: pickuplatlong.longitude,
                        extraDropLatLng: extraDropLatLong,
                        secnodDropLatLong: secnodDropLatLong,
                        droplong: droplatlong!.longitude,
                        pickupdate: widget.pickupdate),
                  ),
                );
                // BlocProvider.of<ConfirmrideBloc>(context).add(
                //   DoConfirmRide(
                //       droplocation: jsonEncode(mapList),
                //       pickuplocation:

                // );
                // locationBlocBloc.add(InitBloc());
              },
              child: Container(
                height: 50.h,
                margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
                padding: EdgeInsets.symmetric(
                  vertical: 15.h,
                ),
                child: Center(
                  child: Text(
                    "Done",
                    style: AppText.text15Normal.copyWith(color: Colors.white),
                  ),
                ),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.green,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            backgroundColor: AppColors.appColor,
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w) +
                    EdgeInsets.only(
                      top: 10.h,
                    ),
                child: MultiBlocListener(
                  listeners: [
                    BlocListener<LocationBlocBloc, LocationBlocState>(
                      listener: (context, state) {
                        if (state is PickupLatLongLoaded) {
                          setState(() {
                            pickuplatlong = state.picklatlong;
                          });
                        }
                      },
                    ),
                  ],
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      _showmembers(),
                      sizedBoxWithHeight(10),
                      textfields(),
                      _renderbody(),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget textfields() {
    return Padding(
      padding: EdgeInsets.only(
        bottom: 10.h,
      ),
      child: Row(
        children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Icon(
                Icons.circle,
                color: AppColors.black,
                size: 10,
              ),
              SizedBox(
                height: dividerHeight,
                child: VerticalDivider(
                  width: 20,
                  color: AppColors.black,
                ),
              ),
              Icon(
                Icons.square,
                color: AppColors.greylight,
                size: 10,
              ),
            ],
          ),
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 276.w,
                  color: Colors.grey.shade300,
                  child: TextFormField(
                    controller: pickupController,
                    onTap: () {
                      locationBlocBloc.add(ClearSuggestionList());
                      setState(() {
                        pickenabled = true;
                        dropenable = false;
                        secondenable = false;
                        thirdenable = false;
                        extraFieldEnabled = false;
                      });
                    },
                    onChanged: (value) {
                      BlocProvider.of<LocationBlocBloc>(context).add(
                        FetchSuggestions(query: value),
                      );
                    },
                    cursorColor: AppColors.grey500,
                    decoration: InputDecoration(
                      hintText: "Enter Pickup location",
                      hintStyle: AppText.text14w400.copyWith(
                        fontSize: 12.sp,
                        color: AppColors.grey500,
                      ),
                      contentPadding: EdgeInsets.all(8.w),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                sizedBoxWithHeight(10),
                ReorderableListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    ...textFields,
                  ],
                  onReorder: (oldIndex, newIndex) {
                    setState(() {
                      if (oldIndex < newIndex) {
                        newIndex -= 1;
                      }
                      final item = textFields.removeAt(oldIndex);
                      textFields.insert(newIndex, item);
                    });
                  },
                ),
              ],
            ),
          ),
          sizedBoxWithWidth(7),
          ValueListenableBuilder(
            valueListenable: isExtraTextfieldVisible,
            builder: (_, bool val, __) {
              return Visibility(
                visible: !val,
                child: InkWell(
                  onTap: () => setState(() {
                    isExtraTextfieldVisible.value = true;
                    enabledfield++;
                    //
                    //
                    //   dividerHeight += 50.h;
                  }),
                  child: Container(
                    height: 30.h,
                    width: 30.w,
                    decoration: BoxDecoration(
                      // color: _controllers.length < 3
                      //     ? AppColors.greylight
                      //     : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.add,
                        color: AppColors.black,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _showmembers() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            dropController.text = "";
            pickupController.text = '';
            locationBlocBloc.add(ClearSuggestionList());
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: AppColors.black,
          ),
        ),
        Spacer(),
        BlocListener<MemberBloc, MemberState>(
          listener: (context, state) async {
            if (state is MemberLoading) {
              // Loader.show(context);
            } else if (state is MembersFail) {
              context.showSnackBar(context, msg: state.error);
              Loader.hide();
            } else if (state is MemberLoaded) {
              Loader.hide();
              await showTopModalSheet<String?>(
                  context, MembersSheet(members: state.listMembers.members));
            } else if (state is MemberTokenExpired) {
              Loader.hide();
              context.showSnackBar(context, msg: "Token Expired");
            }
          },
          child: InkWell(
            onTap: () async {
              memberBloc.add(FetchMembers());
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.person,
                  color: AppColors.grey500,
                  size: 12,
                ),
                sizedBoxWithWidth(3),
                Text(
                  "Switch Member",
                  style: AppText.text14w400.copyWith(
                    color: AppColors.grey500,
                    fontSize: 12.sp,
                  ),
                ),
                sizedBoxWithWidth(3),
                Icon(
                  Icons.keyboard_arrow_down_outlined,
                  color: AppColors.grey500,
                  size: 12,
                )
              ],
            ),
          ),
        ),
        Spacer(),
      ],
    );
  }

  Widget _renderbody() {
    return Padding(
      padding: EdgeInsets.symmetric(
            horizontal: 0.w,
          ) +
          EdgeInsets.only(
            top: 16.h,
          ),
      child: !ismapvisible
          ? SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BlocConsumer<address.AddressBloc,
                                address.AddressState>(
                              listener: (context, state) {
                                Loader.show(context);
                                if (state is address.AddressLoaded) {
                                  Loader.hide();
                                } else {
                                  Loader.hide();
                                }
                              },
                              builder: (context, state) {
                                if (state is address.AddressLoaded) {
                                  return ExpansionTile(
                                    title: Text(
                                      "Saved Places",
                                      style: AppText.text16w400.copyWith(
                                        color: AppColors.black,
                                      ),
                                    ),
                                    children: List.generate(
                                        state.address.address.length,
                                        (index) => GestureDetector(
                                              onTap: () {
                                                FocusScopeNode currentFocus =
                                                    FocusScope.of(context);

                                                if (!currentFocus
                                                    .hasPrimaryFocus) {
                                                  currentFocus.unfocus();
                                                }

                                                if (pickenabled) {
                                                  locationBlocBloc.add(
                                                    FetchPickupLatLong(
                                                        placeId: state
                                                                .address
                                                                .address[index]
                                                                .placeId ??
                                                            ''),
                                                  );
                                                  pickupController.text = state
                                                      .address
                                                      .address[index]
                                                      .addressLine2;
                                                  pickupController.selection =
                                                      TextSelection.collapsed(
                                                    offset: pickupController
                                                        .text.length,
                                                  );
                                                  locationBlocBloc.add(
                                                    FetchPickupLatLong(
                                                        placeId: state
                                                                .address
                                                                .address[index]
                                                                .placeId ??
                                                            ''),
                                                  );
                                                  return;
                                                }
                                                if (extraFieldEnabled) {
                                                  _controller.text = state
                                                      .address
                                                      .address[index]
                                                      .addressLine2;

                                                  _controller.selection =
                                                      TextSelection.collapsed(
                                                          offset: _controller
                                                              .text.length);

                                                  locationBlocBloc.add(
                                                    FetchSecondDropLatlong(
                                                        placeId: state
                                                                .address
                                                                .address[index]
                                                                .placeId ??
                                                            ''),
                                                  );
                                                  return;
                                                }
                                                if (secondenable) {
                                                  _secondController.text = state
                                                      .address
                                                      .address[index]
                                                      .addressLine2;

                                                  _secondController.selection =
                                                      TextSelection.collapsed(
                                                          offset:
                                                              _secondController
                                                                  .text.length);

                                                  locationBlocBloc.add(
                                                    FetchThirdDropLatlong(
                                                        placeId: state
                                                                .address
                                                                .address[index]
                                                                .placeId ??
                                                            ''),
                                                  );
                                                  return;
                                                }
                                                if (thirdenable) {
                                                  _thirdController.text = state
                                                      .address
                                                      .address[index]
                                                      .addressLine2;

                                                  _thirdController.selection =
                                                      TextSelection.collapsed(
                                                          offset:
                                                              _thirdController
                                                                  .text.length);

                                                  locationBlocBloc.add(
                                                    FetchForthDropLatlong(
                                                        placeId: state
                                                                .address
                                                                .address[index]
                                                                .placeId ??
                                                            ''),
                                                  );
                                                  return;
                                                }
                                                if (dropenable) {
                                                  dropController.text = state
                                                      .address
                                                      .address[index]
                                                      .addressLine2;

                                                  dropController.selection =
                                                      TextSelection.collapsed(
                                                          offset: dropController
                                                              .text.length);

                                                  locationBlocBloc.add(
                                                    FetchDropLatlong(
                                                        placeId: state
                                                                .address
                                                                .address[index]
                                                                .placeId ??
                                                            ''),
                                                  );
                                                }
                                              },
                                              child: Row(
                                                children: [
                                                  Container(
                                                    height: 32.h,
                                                    width: 32.w,
                                                    child: Icon(
                                                      Icons.star,
                                                      color: Colors.white,
                                                      size: 16,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: AppColors.greydark,
                                                      shape: BoxShape.circle,
                                                    ),
                                                  ),
                                                  SizedBox(width: 12.w),
                                                  Flexible(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          state
                                                              .address
                                                              .address[index]
                                                              .addressLine1,
                                                          style: AppText
                                                              .text16w400
                                                              .copyWith(
                                                            color:
                                                                AppColors.black,
                                                          ),
                                                        ),
                                                        Text(
                                                          state
                                                              .address
                                                              .address[index]
                                                              .addressLine2,
                                                          maxLines: 3,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: AppText
                                                              .text14w400
                                                              .copyWith(
                                                            color: AppColors
                                                                .grey500,
                                                            fontSize: 13.sp,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )),
                                  );
                                }
                                return SizedBox();
                              },
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  sizedBoxWithHeight(10),
                  BlocListener<address.AddressBloc, address.AddressState>(
                    listener: (context, state) {
                      if (state is address.AddAddressSucess) {
                        context.showSnackBar(context,
                            msg: 'Saved Successfully');
                      }
                    },
                    child: BlocConsumer<LocationBlocBloc, LocationBlocState>(
                      builder: (context, state) {
                        if (state is SuggestionsLoaded) {
                          // Loader.hide();
                          return ListView.separated(
                            shrinkWrap: true,
                            primary: false,
                            itemCount: state.predictions.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  FocusScopeNode currentFocus =
                                      FocusScope.of(context);

                                  if (!currentFocus.hasPrimaryFocus) {
                                    currentFocus.unfocus();
                                  }

                                  if (pickenabled) {
                                    locationBlocBloc.add(
                                      FetchPickupLatLong(
                                          placeId: state.predictions
                                              .elementAt(index)
                                              .placeId),
                                    );
                                    pickupController.text = state.predictions
                                        .elementAt(index)
                                        .structuredFormatting
                                        .secondaryText;
                                    pickupController.selection =
                                        TextSelection.collapsed(
                                      offset: pickupController.text.length,
                                    );
                                    locationBlocBloc.add(
                                      FetchPickupLatLong(
                                          placeId: state.predictions
                                              .elementAt(index)
                                              .placeId),
                                    );
                                  } else if (dropenable) {
                                    dropController.text = state.predictions
                                        .elementAt(index)
                                        .structuredFormatting
                                        .secondaryText;

                                    dropController.selection =
                                        TextSelection.collapsed(
                                            offset: dropController.text.length);

                                    locationBlocBloc.add(
                                      FetchDropLatlong(
                                          placeId: state.predictions
                                              .elementAt(index)
                                              .placeId),
                                    );
                                  } else if (extraFieldEnabled) {
                                    _controller.text = state.predictions
                                        .elementAt(index)
                                        .structuredFormatting
                                        .secondaryText;

                                    _controller.selection =
                                        TextSelection.collapsed(
                                            offset: _controller.text.length);

                                    locationBlocBloc.add(
                                      FetchSecondDropLatlong(
                                          placeId: state.predictions
                                              .elementAt(index)
                                              .placeId),
                                    );

                                    // _controllers
                                    //         .elementAt(currentTextField)
                                    //         .text =
                                    //     state.predictions
                                    //         .elementAt(index)
                                    //         .structuredFormatting
                                    //         .secondaryText;
                                  } else if (thirdenable) {
                                    _secondController.text = state.predictions
                                        .elementAt(index)
                                        .structuredFormatting
                                        .secondaryText;

                                    _secondController.selection =
                                        TextSelection.collapsed(
                                            offset:
                                                _secondController.text.length);

                                    locationBlocBloc.add(
                                      FetchSecondDropLatlong(
                                          placeId: state.predictions
                                              .elementAt(index)
                                              .placeId),
                                    );

                                    // _controllers
                                    //         .elementAt(currentTextField)
                                    //         .text =
                                    //     state.predictions
                                    //         .elementAt(index)
                                    //         .structuredFormatting
                                    //         .secondaryText;
                                  } else if (secondenable) {
                                    _thirdController.text = state.predictions
                                        .elementAt(index)
                                        .structuredFormatting
                                        .secondaryText;

                                    _thirdController.selection =
                                        TextSelection.collapsed(
                                            offset:
                                                _thirdController.text.length);

                                    locationBlocBloc.add(
                                      FetchForthDropLatlong(
                                          placeId: state.predictions
                                              .elementAt(index)
                                              .placeId),
                                    );

                                    // _controllers
                                    //         .elementAt(currentTextField)
                                    //         .text =
                                    //     state.predictions
                                    //         .elementAt(index)
                                    //         .structuredFormatting
                                    //         .secondaryText;
                                  } else {}
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      height: 50.h,
                                      width: 50.w,
                                      child: Icon(
                                        Icons.access_time_filled_sharp,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                      decoration: BoxDecoration(
                                          color: AppColors.greydark,
                                          shape: BoxShape.circle),
                                    ),
                                    sizedBoxWithWidth(10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            state.predictions
                                                .elementAt(index)
                                                .structuredFormatting
                                                .mainText,
                                            style: AppText.text16w400.copyWith(
                                              color: AppColors.black,
                                            ),
                                          ),
                                          Text(
                                            state.predictions
                                                .elementAt(index)
                                                .structuredFormatting
                                                .secondaryText,
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                            style: AppText.text14w400.copyWith(
                                              color: AppColors.grey500,
                                              fontSize: 13.sp,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        LatLng latLng = await getPlaceLatLng(
                                            state.predictions
                                                .elementAt(index)
                                                .placeId);
                                        context.read<address.AddressBloc>().add(
                                              address.AddAddress(
                                                element: AddressElement(
                                                  placeId: state.predictions
                                                      .elementAt(index)
                                                      .placeId,
                                                  addressLine1: state
                                                      .predictions
                                                      .elementAt(index)
                                                      .structuredFormatting
                                                      .mainText,
                                                  latitude: latLng.latitude
                                                      .toString(),
                                                  longitude: latLng.longitude
                                                      .toString(),
                                                  addressLine2: state
                                                      .predictions
                                                      .elementAt(index)
                                                      .structuredFormatting
                                                      .secondaryText,
                                                ),
                                              ),
                                            );
                                      },
                                      child: Icon(
                                        Icons.saved_search,
                                        size: 24.r,
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                            separatorBuilder: (c, i) {
                              return Divider(
                                thickness: 0.6,
                                color: AppColors.greylight,
                              );
                            },
                          );
                        }
                        return SizedBox();
                      },
                      listener: (context, state) {
                        if (state is SuggestionsLoading) {
                          //     Loader.show(context);
                        } else if (state is DropLatLongLoading) {
                          // Loader.show(context);
                        } else if (state is DropLatLongLoaded ||
                            state is DropSecondaryLatLongLoaded ||
                            state is DropThirdLatLongLoaded) {
                          Loader.hide();

                          var mapList = [];
                          if (state is DropLatLongLoaded) {
                            droplatlong = state.latLng;
                            mapList.add({
                              "lat": state.latLng.latitude.toString(),
                              "long": state.latLng.longitude.toString(),
                              "address": dropController.text
                            });
                          }
                          if (state is DropSecondaryLatLongLoaded) {
                            extraDropLatLong = state.latLng;
                            mapList.add({
                              "lat": state.latLng.latitude.toString(),
                              "long": state.latLng.longitude.toString(),
                              "address": _controller.text
                            });
                          }
                          if (state is DropThirdLatLongLoaded) {
                            secnodDropLatLong = state.latLng;
                            mapList.add({
                              "lat": state.latLng.latitude.toString(),
                              "long": state.latLng.longitude.toString(),
                              "address": _secondController.text
                            });
                          }
                          if (state is DropForthLatLongLoaded) {
                            secnodDropLatLong = state.latLng;
                            mapList.add({
                              "lat": state.latLng.latitude.toString(),
                              "long": state.latLng.longitude.toString(),
                              "address": _thirdController.text
                            });
                          }
                        }
                      },
                    ),
                  ),
                  sizedBoxWithHeight(10),
                  GestureDetector(
                    onTap: () {
                      if (ismapvisible == false) {
                        setState(() {
                          ismapvisible = true;
                        });
                      }
                      FocusScopeNode currentFocus = FocusScope.of(context);
                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: 50.h,
                          width: 50.w,
                          child: Icon(
                            Icons.location_on,
                            color: Colors.white,
                            size: 30,
                          ),
                          decoration: BoxDecoration(
                              color: AppColors.greydark,
                              shape: BoxShape.circle),
                        ),
                        sizedBoxWithWidth(10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Set location on map ",
                              style: AppText.text16w400.copyWith(
                                color: AppColors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${pickenabled ? 'Pick up Location' : 'Drop Location'}',
                  style: AppText.text16w400,
                ),
                SizedBox(
                  height: 16.h,
                ),
                SizedBox(
                  child: Stack(
                    children: [
                      position == null
                          ? Center(
                              child: CircularProgressIndicator(
                                color: AppColors.green,
                              ),
                            )
                          : Builder(builder: (context) {
                              return GoogleMap(
                                myLocationEnabled: true,
                                zoomGesturesEnabled: true,
                                zoomControlsEnabled: true,
                                //  myLocationButtonEnabled: true,
                                gestureRecognizers: <Factory<
                                    OneSequenceGestureRecognizer>>{
                                  Factory<OneSequenceGestureRecognizer>(
                                    () => EagerGestureRecognizer(),
                                  ),
                                },
                                onCameraIdle: () async {
                                  LatLngBounds bounds =
                                      await googleMapController
                                          .getVisibleRegion();
                                  final lon = (bounds.northeast.longitude +
                                          bounds.southwest.longitude) /
                                      2;
                                  final lat = (bounds.northeast.latitude +
                                          bounds.southwest.latitude) /
                                      2;
                                  String _fullAddress = "";

                                  getAddressFromLatLng(lat, lon).then((value) {
                                    setState(() {
                                      _fullAddress = value;
                                      FocusScopeNode currentFocus =
                                          FocusScope.of(context);

                                      if (!currentFocus.hasPrimaryFocus) {
                                        currentFocus.unfocus();
                                      }

                                      if (pickenabled) {
                                        pickuplatlong = LatLng(lat, lon);
                                        setState(() {
                                          pickupController.text = _fullAddress;
                                        });
                                        pickupController.selection =
                                            TextSelection.collapsed(
                                          offset: pickupController.text.length,
                                        );
                                      } else if (extraFieldEnabled) {
                                        extraDropLatLong = LatLng(lat, lon);

                                        _controller.text = _fullAddress;

                                        _controller.selection =
                                            TextSelection.collapsed(
                                                offset:
                                                    _controller.text.length);
                                      } else if (thirdenable) {
                                        secnodDropLatLong = LatLng(lat, lon);

                                        _secondController.text = _fullAddress;

                                        _secondController.selection =
                                            TextSelection.collapsed(
                                                offset: _secondController
                                                    .text.length);
                                      } else if (secondenable) {
                                        secnodDropLatLong = LatLng(lat, lon);

                                        _thirdController.text = _fullAddress;

                                        _thirdController.selection =
                                            TextSelection.collapsed(
                                                offset: _thirdController
                                                    .text.length);
                                      } else if (dropenable) {
                                        droplatlong = LatLng(lat, lon);

                                        dropController.text = _fullAddress;

                                        dropController.selection =
                                            TextSelection.collapsed(
                                                offset:
                                                    dropController.text.length);
                                      } else {
                                        pickupController.text = _fullAddress;
                                        pickupController.selection =
                                            TextSelection.collapsed(
                                          offset: pickupController.text.length,
                                        );
                                      }
                                      print(_fullAddress);
                                    });
                                  });
                                },
                                onMapCreated: (controller) {
                                  setState(() {
                                    googleMapController = controller;
                                  });
                                },
                                initialCameraPosition: CameraPosition(
                                  target: LatLng(
                                      position!.latitude, position!.longitude),
                                  zoom: 15.0,
                                ),
                              );
                            }),
                      Center(
                          child: Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 40.h,
                      )),
                    ],
                  ),
                  height: mapheight(),
                ),
              ],
            ),
    );
  }

  double mapheight() {
    print(" length is  ${enabledfield}");
    if (enabledfield == 1) {
      return 500.h;
    } else if (enabledfield == 2) {
      return 410.h;
    } else if (enabledfield == 3) {
      return 320.h;
    } else if (enabledfield == 4) {
      return 280.h;
    }
    return 500.h;
  }
}
