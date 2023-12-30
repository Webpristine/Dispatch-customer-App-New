import 'package:flutter/material.dart';
import 'package:multitrip_user/api/app_repository.dart';

import 'package:multitrip_user/features/add_member/add_member.dart';
import 'package:multitrip_user/logic/vehicle/vehicle_controller.dart';
import 'package:multitrip_user/shared/shared.dart';
import 'package:multitrip_user/shared/ui/common/spacing.dart';
import 'package:multitrip_user/themes/app_text.dart';
import 'package:provider/provider.dart';

class AddVehicle extends StatefulWidget {
  const AddVehicle({super.key});

  @override
  State<AddVehicle> createState() => _AddVehicleState();
}

class _AddVehicleState extends State<AddVehicle> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AppRepository().saveAccessToken();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<VehicleController>(context, listen: false);
    return Scaffold(
      backgroundColor: AppColors.appColor,
      appBar: AppBar(
        backgroundColor: AppColors.appColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Text(
          "Add your vehicle",
          style: AppText.text15w500.copyWith(
            color: AppColors.black,
          ),
        ),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: AppColors.black,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(
          left: 16.w,
          right: 16.w,
          bottom: 16.h,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              sizedBoxWithHeight(
                25,
              ),
              CommonTextField(
                controller: controller.vehiclename,
                title: "Vehicle Name",
                maxLines: 1,
              ),
              CommonTextField(
                controller: controller.vehicletype,
                title: "Vehicle Type",
                maxLines: 1,
              ),
              CommonTextField(
                maxLines: 1,
                controller: controller.vehiclecolor,
                title: "Vehicle Color",
              ),
              CommonTextField(
                controller: controller.vehiclenumber,
                maxLines: 1,
                title: "Vehicle Number",
              ),
              sizedBoxWithHeight(
                15,
              ),
              InkWell(
                onTap: () {
                  if (controller.vehiclename.text.isEmpty) {
                    context.showSnackBar(context,
                        msg: "Please enter vehicle number");
                  } else if (controller.vehiclecolor.text.isEmpty) {
                    context.showSnackBar(context,
                        msg: "Please enter vehicle color");
                  } else if (controller.vehiclenumber.text.isEmpty) {
                    context.showSnackBar(context,
                        msg: "Please enter vehicle number");
                  } else if (controller.vehicletype.text.isEmpty) {
                    context.showSnackBar(context,
                        msg: "Please enter vehicle type");
                  } else {
                    controller.addvehicle(context: context);
                  }
                },
                child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(
                    top: 15.h,
                  ),
                  child: Center(
                    child: Text(
                      "Add Vehicle",
                      style: AppText.text15w500.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: 16.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.green,
                    borderRadius: BorderRadius.circular(
                      10.r,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
