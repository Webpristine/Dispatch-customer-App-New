import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get_it/get_it.dart';
import 'package:multitrip_user/api/app_repository.dart';
import 'package:multitrip_user/shared/shared.dart';
import 'package:multitrip_user/themes/app_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HtmlRenderWidgetScreen extends StatefulWidget {
  const HtmlRenderWidgetScreen({super.key, required this.endPoint});
  final String endPoint;
  @override
  State<HtmlRenderWidgetScreen> createState() => _HtmlRenderWidgetScreenState();
}

class _HtmlRenderWidgetScreenState extends State<HtmlRenderWidgetScreen> {
  String html = '';
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _apicall();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black)),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: HtmlWidget(
          html,
          textStyle: AppText.text14w400,
        ),
      ),
    );
  }

  Future<void> _apicall() async {
    final prefs = await SharedPreferences.getInstance();
    html = await AppRepository().getHtmlData(
        userid: prefs.getString(Strings.userid)!,
        accesstoken: prefs.getString(Strings.accesstoken)!,
        endpoint: widget.endPoint);
    setState(() {});
  }
}
