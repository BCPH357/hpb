import 'package:flutter/material.dart';
import 'loadingBody.dart';
import 'custom_drawer.dart';


class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {

    final page = Scaffold(
      //this argument(ValueNotifier) can avoid bug when we using keyboard.
      resizeToAvoidBottomInset: false,
      body: Loading(),
      backgroundColor: const Color(0XFFFFFFFF),
      drawer: CustomDrawer(),
    );

    return page;
  }
}