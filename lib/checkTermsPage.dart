import 'package:flutter/material.dart';
import 'custom_drawer.dart';
import 'checkTermsBody.dart';

class CheckTermsPage extends StatelessWidget {
  const CheckTermsPage({super.key});

  @override
  Widget build(BuildContext context) {

    final page = Scaffold(
      //this argument(ValueNotifier) can avoid bug when we using keyboard.
      resizeToAvoidBottomInset: false,
      body: CheckTerms(),
      backgroundColor: const Color(0XFFD9D9D9),
      drawer: CustomDrawer(),
    );

    return page;
  }
}