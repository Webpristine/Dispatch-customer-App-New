import 'package:flutter/material.dart';

import 'package:multitrip_user/shared/shared.dart';
import 'package:multitrip_user/themes/app_text.dart';

class NextFloatingButton extends StatelessWidget {
  const NextFloatingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: 10.h,
      ),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.green,
              AppColors.yellow,
            ],
          ),
          borderRadius: BorderRadius.circular(40)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Next",
              style: AppText.text18w400.copyWith(
                color: Colors.white,
              )),
          SizedBox(
            width: 20,
          ),
          Icon(
            Icons.arrow_forward_sharp,
            color: Colors.white,
          )
        ],
      ),
    );
  }
}
