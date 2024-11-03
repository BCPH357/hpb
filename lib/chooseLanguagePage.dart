import 'package:flutter/material.dart';
import 'chooseLanguageBody.dart';
import 'custom_drawer.dart';


class ChooseLanguagePage extends StatelessWidget {
  const ChooseLanguagePage({super.key});

  @override
  Widget build(BuildContext context) {

    final page = Scaffold(
      //this argument(ValueNotifier) can avoid bug when we using keyboard.
      resizeToAvoidBottomInset: false,
      body: ChooseLanguage(),
      backgroundColor: const Color(0XFFD9D9D9),
      drawer: CustomDrawer(),
    );

    return page;
  }
}