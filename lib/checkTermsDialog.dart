import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'loginPage.dart';

class CheckTermsDialog extends StatelessWidget {
  final String term;
  const CheckTermsDialog({super.key, required this.term});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(411, 890));

    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text("條款與隱私權", style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w500)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(color: Color(0XFFD9D9D9), thickness: 2.0),
            Container(
              margin: EdgeInsets.all(10.w),
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Color(0XFFD9D9D9), width: 2.0),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(term, style: TextStyle(fontSize: 16.sp)), // Assuming 'term' is defined elsewhere or passed as a parameter
            ),
          ],
        ),
      ),
      actions: [
        // Checkbox(
        //   value: false,
        //   onChanged: (bool? value) {
        //     // Handle checkbox state change
        //   },
        //   side: BorderSide(color: Color(0xfff5f5f5), width: 2.0),
        // ),
        
        Spacer(),
        ElevatedButton(
          onPressed: () {
            // Handle button press
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xff757575),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 10.h),
          ),
          child: Text('關閉', style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w300)),
        ),
      ],
    );
  }
}