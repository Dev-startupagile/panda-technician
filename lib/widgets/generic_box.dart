import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:panda_technician/models/requests/detailedRequestM.dart';
import 'package:panda_technician/widgets/rating_page.dart';

class GenericBox extends StatelessWidget {
  final Color? fillColor;
  final Color? borderColor;
  final GestureTapCallback? onTap;
  final Widget child;

  const GenericBox({
    Key? key,
    this.fillColor,
    this.borderColor,
    this.onTap,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52.h,
        decoration: BoxDecoration(
          border:
              Border.all(color: borderColor ?? fillColor ?? Colors.transparent),
          color: fillColor,
        ),
        child: child,
      ),
    );
  }
}

Widget customRating(
        BuildContext context, double value, int reviewCount, Info datum) =>
    GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ReviewPage(
                  customerInfo: datum,
                )));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.star,
                color: Colors.black54,
                size: 24,
              ),
              Text(value.toStringAsFixed(1)),
            ],
          ),
          Text("$reviewCount reviews")
        ],
      ),
    );
