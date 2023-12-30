import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multitrip_user/app_enverionment.dart';
import 'package:multitrip_user/blocs/account/account_controller.dart';
import 'package:multitrip_user/bottomnavigationbar.dart';
import 'package:multitrip_user/features/account/account_info.dart';
import 'package:multitrip_user/features/settings/settings.dart';
import 'package:multitrip_user/shared/shared.dart';
import 'package:multitrip_user/shared/ui/common/spacing.dart';
import 'package:multitrip_user/widgets/html_render.dart';
import 'package:provider/provider.dart';

class Account extends StatefulWidget {
  final GlobalKey<ScaffoldState>? parentScaffoldKey;

  const Account({
    super.key,
    this.parentScaffoldKey,
  });

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<AccountController>(context, listen: false).getPofileData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appColor,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leadingWidth: 40.w,
        leading: InkWell(
          onTap: () {
            AppEnvironment.navigator.push(
              MaterialPageRoute(
                builder: (context) => PagesWidget(),
              ),
            );
          },
          child: Icon(
            Icons.arrow_back,
            color: AppColors.black,
          ),
        ),
      ),
      body: Consumer<AccountController>(builder: (context, model, __) {
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 16.w,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (model.userModel?.name?.isEmpty ?? true)
                            ? 'Full Name'
                            : model.userModel?.name ?? '',
                        style: GoogleFonts.poppins(
                          color: AppColors.black,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          top: 20.h,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 7.w,
                          vertical: 2.h,
                        ),
                        child: Row(children: [
                          Icon(
                            Icons.star,
                            color: Colors.white,
                            size: 13,
                          ),
                          sizedBoxWithWidth(3),
                          Text(
                            model.userModel?.rating ?? '0.00',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w300,
                            ),
                          )
                        ]),
                        decoration: BoxDecoration(
                          color: AppColors.green,
                          borderRadius: BorderRadius.circular(
                            20,
                          ),
                        ),
                      )
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      AppEnvironment.navigator.push(
                        MaterialPageRoute(
                          builder: (context) => AccountInfo(),
                        ),
                      );
                    },
                    child: Consumer<AccountController>(
                        builder: (context, model, _) {
                      return Container(
                        padding: EdgeInsets.all(15),
                        clipBehavior: Clip.hardEdge,
                        height: 80.h,
                        width: 80.w,
                        decoration: BoxDecoration(
                          color: AppColors.green,
                          shape: BoxShape.circle,
                          image: (model.userModel?.profilePhoto?.isNotEmpty ??
                                  false)
                              ? DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                      model.userModel?.profilePhoto ?? ''),
                                )
                              : null,
                        ),
                        child:
                            (model.userModel?.profilePhoto?.isNotEmpty ?? false)
                                ? null
                                : Icon(
                                    Icons.person,
                                    size: 40,
                                    color: Colors.white,
                                  ),
                      );
                    }),
                  )
                ],
              ),
              sizedBoxWithHeight(20),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 20.h,
                      horizontal: 24.w,
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.help,
                          color: Colors.white,
                          size: 20,
                        ),
                        Text(
                          "Help",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.green,
                      borderRadius: BorderRadius.circular(
                        4,
                      ),
                    ),
                  ),
                  sizedBoxWithWidth(
                    10,
                  ),
                  GestureDetector(
                    onTap: () {
                      AppEnvironment.navigator.pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (_) => PagesWidget(
                              currentTab: 1,
                            ),
                          ),
                          (_) => false);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 20.h,
                        horizontal: 10.w,
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.access_time_filled_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                          Text(
                            "Previous booking",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.green,
                        borderRadius: BorderRadius.circular(
                          4,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              sizedBoxWithHeight(
                40,
              ),
              Divider(
                thickness: 1.2,
                color: AppColors.greylight,
              ),
              sizedBoxWithHeight(40),
              InkWell(
                onTap: () {
                  ///     BlocProvider.of<DashboardBloc>(context).add(InitBloc());

                  AppEnvironment.navigator.push(
                    MaterialPageRoute(
                      builder: (context) => Settings(),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.settings_outlined,
                      color: AppColors.black,
                      size: 24,
                    ),
                    sizedBoxWithWidth(3),
                    Text(
                      "Settings",
                      style: GoogleFonts.poppins(
                        color: AppColors.black,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w300,
                      ),
                    )
                  ],
                ),
              ),
              sizedBoxWithHeight(10),
              GestureDetector(
                onTap: () {
                  AppEnvironment.navigator.push(MaterialPageRoute(
                      builder: (_) =>
                          HtmlRenderWidgetScreen(endPoint: '/legal_policy')));
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.info,
                      color: AppColors.black,
                      size: 24,
                    ),
                    sizedBoxWithWidth(3),
                    Text(
                      "Legal",
                      style: GoogleFonts.poppins(
                        color: AppColors.black,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w300,
                      ),
                    )
                  ],
                ),
              ),
              sizedBoxWithHeight(40),
              Divider(
                thickness: 1.2,
                color: AppColors.greylight,
              ),
              sizedBoxWithHeight(40),
              Text(
                "Total Spending - \$ ${model.userModel?.totalSpend ?? 0}",
                style: GoogleFonts.poppins(
                    color: AppColors.black,
                    fontWeight: FontWeight.w300,
                    fontSize: 16.sp),
              ),
              sizedBoxWithHeight(10),
              Text(
                "Total miles drive - ${model.userModel?.totalRide ?? 0} miles",
                style: GoogleFonts.poppins(
                    color: AppColors.black,
                    fontWeight: FontWeight.w300,
                    fontSize: 16.sp),
              )
            ],
          ),
        );
      }),
    );
  }
}
