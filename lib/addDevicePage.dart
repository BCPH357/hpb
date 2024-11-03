import 'package:flutter/material.dart';
import 'package:hpb/addDeviceBody.dart';

import 'appBar.dart';
import 'custom_drawer.dart';
class DevicePage extends StatelessWidget {
  const DevicePage({super.key});

  @override
  Widget build(BuildContext context) {
    final appBar = PreferredSize(
      preferredSize: const Size.fromHeight(25.0),
      child: AppBar(
        // this argument(automaticallyImplyLeading) can cancel built-in back button.
        automaticallyImplyLeading: false,
        //sending user name to appbar to change the staff name
        //the user name is from login page

        title: const Appbar(),
        backgroundColor: Colors.white,
        // backgroundColor: const Color(0XFFF1F1F1),
      ),
    );

    final page = Scaffold(
      //this argument(ValueNotifier) can avoid bug when we using keyboard.
      resizeToAvoidBottomInset: false,
      appBar: appBar,
      body: AddDevice(),
      backgroundColor: const Color(0XFFD9D9D9),
      drawer: CustomDrawer(),
    );

    return page;
  }
}