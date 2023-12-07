import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SubChapterNode extends StatelessWidget {
  final bool isDone;
  final bool left;
  final String title;
  final String description;
  final String number;
  const SubChapterNode({
    super.key,
    required this.isDone,
    required this.left,
    required this.title,
    required this.description,
    required this.number,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(2.w),
      child: Row(
        mainAxisAlignment:
            left ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          left
              ? LearningPathTextDescription(
                  title: title,
                  description: description,
                )
              : Container(),
          SizedBox(width: 2.w),
          Container(
            alignment: Alignment.center,
            height: 10.w,
            width: 10.w,
            decoration: BoxDecoration(
                color: isDone ? Colors.green : Colors.grey,
                borderRadius: BorderRadius.circular(100)),
            child: Text(
              number,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white),
            ),
          ),
          SizedBox(width: 2.w),
          left
              ? Container()
              : LearningPathTextDescription(
                  title: title,
                  description: description,
                )
        ],
      ),
    );
  }
}

class LearningPathTextDescription extends StatelessWidget {
  final String title;
  final String description;
  const LearningPathTextDescription({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50.w,
      height: 9.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          SizedBox(
            height: 1.h,
          ),
          const Text(
            'description about the sub chapter test description it will be too long sometimes',
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: TextStyle(color: Color(0xff888888)),
          )
        ],
      ),
    );
  }
}
