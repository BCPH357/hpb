import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hpb/stateLightManualBody.dart';
import 'package:hpb/stateLightManualPage.dart';
import 'package:hpb/voiceSettingPage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:wifi_scan/wifi_scan.dart';
import 'lightSettingBody.dart';
import 'mult_provider.dart';
import 'package:wifi_iot/wifi_iot.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'voiceSettingBody.dart';
import 'lightSettingPage.dart';
import 'restfulApi.dart';
import 'bedCompletePage.dart';
import 'alertDialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
//畫定位點
class PointsPainter extends CustomPainter {
  final List<Offset> points;

  PointsPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color(0xFF70B1B8)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(points[0].dx, points[0].dy)
      ..lineTo(points[1].dx, points[1].dy)
      ..lineTo(points[2].dx, points[2].dy)
      ..lineTo(points[3].dx, points[3].dy)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class BedSetting extends StatefulWidget {
  final int index;

  const BedSetting({Key? key, required this.index}) : super(key: key);

  @override
  _BedSettingState createState() => _BedSettingState();
}

class _BedSettingState extends State<BedSetting> {
  List<Offset> points = [
    Offset(100, 100),
    Offset(200, 100),
    Offset(200, 200),
    Offset(100, 200),
  ];
  //取得目前四點座標
  List<Offset> getRelativePositions(double imageWidth, double imageHeight) {
    return points
        .map((point) => Offset(
            double.parse((point.dx / imageWidth).toStringAsFixed(4)),
            double.parse((point.dy / imageHeight).toStringAsFixed(4))))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final deviceInfo = Provider.of<DeviceInfo>(context, listen: false);
    ScreenUtil.init(context, designSize: Size(411, 890));
    // deviceInfo.setDeviceInfo();
    final imageWidth = 287.7.w;
    final imageHeight = 215.775.h;

    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 44.5.h),
        width: 390.45.w,
        decoration: BoxDecoration(
          color: Color(0XFFFFFFFF),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Center(
                      child: Text(
                        "床緣邊界設定",
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.w),
                  child: Column(
                    children: [
                      SizedBox(height: 20.h),
                      AspectRatio(
                        aspectRatio: 4 / 3, // 根據實際圖片比例調整
                        child: Stack(
                          children: [
                            deviceInfo.boundaryImage,
                            // Image.asset(
                            //   "assets/images/bedSetting.png",
                            //   width: imageWidth,
                            //   height: imageHeight,
                            //   fit: BoxFit.contain,
                            // ), 
                            Positioned.fill(
                              child: CustomPaint(
                                painter: PointsPainter(points),
                                child: Stack(
                                  children: [
                                    for (int i = 0; i < points.length; i++)
                                      Positioned(
                                        left: points[i].dx - 15,
                                        top: points[i].dy - 15,
                                        child: GestureDetector(
                                          onPanUpdate: (details) {
                                            setState(() {
                                              points[i] = Offset(
                                                (points[i].dx +
                                                        details.delta.dx)
                                                    .clamp(0, imageWidth),
                                                (points[i].dy +
                                                        details.delta.dy)
                                                    .clamp(0, imageHeight),
                                              );
                                            });
                                          },
                                          child: Container(
                                            width: 30.w,
                                            height: 30.h,
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.blue.withOpacity(0.5),
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Image.asset(
                        "assets/images/settingExample.png",
                        width:369.9.w,
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.w, vertical: 10.h),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border:
                                Border.all(color: Color(0xFF70B1B8), width: 1),
                          ),
                          child: Center(
                            child: Text(
                              "重新設定",
                              style: TextStyle(
                                color: Color(0xFF70B1B8),
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      GestureDetector(
                        onTap: () async {
                          final relativePositions =
                              getRelativePositions(imageWidth, imageHeight);
                          final formattedPositions = relativePositions
                              .map((p) => [
                                    p.dx.toStringAsFixed(2),
                                    p.dy.toStringAsFixed(2)
                                  ])
                              .toList();
                          
                          final boundaryParameters = {
                            "rx1": formattedPositions[0][0],
                            "ry1": formattedPositions[0][1],
                            "rx2": formattedPositions[1][0],
                            "ry2": formattedPositions[1][1],
                            "rx3": formattedPositions[2][0],
                            "ry3": formattedPositions[2][1],
                            "rx4": formattedPositions[3][0],
                            "ry4": formattedPositions[3][1]
                          };
                          
                          final result = await setBedEdgeBoundary(
                              deviceInfo.device[widget.index]["deviceId"], boundaryParameters);
                          if (result == "success") {
                            // showDialog(
                            //   context: context,
                            //   barrierDismissible: false,
                            //   builder: (BuildContext context) {
                            //     return Center(
                            //       child: CircularProgressIndicator(),
                            //     );
                            //   },
                            // );
                            // String result = await getBoundaryImage(
                            //     deviceInfo.device[widget.index]["deviceId"], deviceInfo);1
                            // Navigator.of(context).pop(); // Close the loading dialog
                            // if (result == "success") {
                            //   Navigator.pop(context);
                            //   Navigator.push(context, MaterialPageRoute(builder: (context) => BedCompletePage(index: widget.index)));
                            // } else {
                            //   showDialog(
                            //     context: context,
                            //     builder: (context) => HttpAlertDialog(errorMessage: result),
                            //   );
                            // }
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) => HttpAlertDialog(errorMessage: result),
                            );
                          }
                          // print(
                          //     'Relative positions: ${relativePositions.map((p) => '(${p.dx.toStringAsFixed(2)}, ${p.dy.toStringAsFixed(2)})')}');
                        },
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.w, vertical: 10.h),
                          decoration: BoxDecoration(
                            color: Color(0xFF70B1B8),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              "確定上傳",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 40.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// extension OffsetExtension on Offset {
//   Offset clamp(Offset min, Offset max) {
//     return Offset(
//       dx.clamp(min.dx, max.dx),
//       dy.clamp(min.dy, max.dy),
//     );
//   }
// }
