import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Appbar extends StatelessWidget {
  const Appbar({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(411, 890));
    return Container(
      // color: Colors.green,
      // margin: const EdgeInsets.only(
      //   bottom: 10,
      // ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              print('onTap');
              Scaffold.of(context).openDrawer();
            },
            child: Icon(
              Icons.view_headline,
            ),
          ),
          Expanded(
            child: Center(
              child: Image.asset(
                'assets/icons/hpbLogo.png',
                width: 50.w,
                height: 50.h,
              ),
            ),
          ),
        ],
      ),
    );
  }
}