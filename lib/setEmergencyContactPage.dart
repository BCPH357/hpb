import 'package:flutter/material.dart';

import 'setEmergencyContactBody.dart';
import 'custom_drawer.dart';


class SetEmergencyContactPage extends StatelessWidget {
  const SetEmergencyContactPage({super.key});

  @override
  Widget build(BuildContext context) {

    final page = Scaffold(
      //this argument(ValueNotifier) can avoid bug when we using keyboard.
      resizeToAvoidBottomInset: false,
      body: SetEmergencyContact(),
      backgroundColor: const Color(0XFFD9D9D9),
      drawer: CustomDrawer(),
    );

    return page;
  }
}