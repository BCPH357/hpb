import 'package:flutter/material.dart';

import 'setSelfInfoBody.dart';
import 'custom_drawer.dart';


class SetSelfInfoPage extends StatelessWidget {
  const SetSelfInfoPage({super.key});

  @override
  Widget build(BuildContext context) {

    final page = Scaffold(
      //this argument(ValueNotifier) can avoid bug when we using keyboard.
      resizeToAvoidBottomInset: false,
      body: SetSelfInfo(),
      backgroundColor: const Color(0XFFD9D9D9),
      drawer: CustomDrawer(),
    );

    return page;
  }
}