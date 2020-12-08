import 'dart:io';

import 'package:flutter/material.dart';

class ActionImage<T> extends StatelessWidget {
  final String src;

  final double width;

  final double height;

  final Function onTapped;

  const ActionImage({
    this.src,
    this.width = 100,
    this.height = 100,
    this.onTapped,
  });

  @override
  Widget build(BuildContext context) {
    final exists = File(src).existsSync();
    if (exists == true) {
      return Row(
        children: [
          SizedBox(
            width: width,
            height: height,
            child: FittedBox(
              fit: BoxFit.cover,
              child: GestureDetector(
                child: Image.file(File(src)),
                onTap: () {
                  if (onTapped != null) {
                    onTapped();
                  }
                },
              ),
            ),
          ),
          Spacer(),
        ],
      );
    } else {
      return Container();
    }
  }
}
