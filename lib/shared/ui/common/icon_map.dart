import 'package:flutter/material.dart';
import 'package:multitrip_user/shared/ui/common/app_image.dart';
import 'package:widget_to_marker/widget_to_marker.dart';

final pickUpIcon = AppImage(
  "assets/drop.svg",
  height: 100,
  color: Colors.black,
  width: 100,
).toBitmapDescriptor(
  logicalSize: const Size(100, 100),
  imageSize: const Size(100, 100),
);
final dropIcon = AppImage(
  "assets/pickup.svg",
  height: 100,
  width: 100,
).toBitmapDescriptor(
  logicalSize: const Size(100, 100),
  imageSize: const Size(100, 100),
);

final driverIcon = AppImage(
  "assets/super.svg",
  height: 100,
  width: 100,
).toBitmapDescriptor(
  logicalSize: const Size(100, 100),
  imageSize: const Size(100, 100),
);
