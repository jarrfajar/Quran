// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran/app/data/constant/colors.dart';
import 'package:timeline_tile/timeline_tile.dart';

class RsTimeline extends StatefulWidget {
  final String img;
  final String value;
  final String label;
  final bool isFirst;
  final bool isLast;

  const RsTimeline({
    Key? key,
    required this.img,
    required this.value,
    required this.label,
    required this.isFirst,
    required this.isLast,
  }) : super(key: key);

  @override
  State<RsTimeline> createState() => _RsTimelineState();
}

class _RsTimelineState extends State<RsTimeline> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TimelineTile(
        isFirst: widget.isFirst,
        isLast: widget.isLast,
        // isLast: index == 4 ? true : false,
        alignment: TimelineAlign.manual,
        lineXY: 0.0,
        indicatorStyle: const IndicatorStyle(
          color: appPurpleLight1,
          padding: EdgeInsets.symmetric(vertical: 10),
        ),
        afterLineStyle: LineStyle(
          color: Get.isDarkMode ? appPurpleLight4 : appPurpleLight3,
          thickness: 3.5,
        ),
        beforeLineStyle: LineStyle(
          color: Get.isDarkMode ? appPurpleLight4 : appPurpleLight3,
          thickness: 3.5,
        ),
        endChild: Padding(
          padding: const EdgeInsets.only(left: 20, bottom: 5, top: 5),
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: ListTile(
              leading: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: appPurpleLight1,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Image.asset(
                    widget.img,
                    width: 64.0,
                    height: 64.0,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              title: Text(
                widget.label,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
              subtitle: Text(
                widget.value,
                style: TextStyle(
                  color: Colors.grey[500],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
        startChild: Container(
          color: Colors.green,
        ),
      ),
    );
  }
}
