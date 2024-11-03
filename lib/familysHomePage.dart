import 'package:flutter/material.dart';
import 'package:hpb/addDeviceBody.dart';

import 'appBar.dart';
import 'familysHomeBody.dart';
import 'custom_drawer.dart';
class FamilySHomePage extends StatelessWidget {
  final int index;
  const FamilySHomePage({super.key, required this.index});

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
      resizeToAvoidBottomInset: false,
      appBar: appBar,
      body: FamilySHome(index: index), // Assuming Home is a widget you have defined elsewhere
      backgroundColor: const Color(0XFFD9D9D9),
      drawer: CustomDrawer(),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 50,
          child: Center(
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.arrow_back,
                    color: Color(0XFF70B1B8),
                    size: 25,
                  ),
                  SizedBox(width: 10),
                  Text(
                    '返回我家',
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(0XFF70B1B8),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    return page;
  }
}
