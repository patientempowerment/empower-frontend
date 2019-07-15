import 'package:flutter/material.dart';
import 'package:bars_frontend/main.dart';
import '../predictions.dart';
import '../utils.dart';
import 'dialogs.dart';
import 'bubbles.dart';

Widget getPatientImage(double width, Offset position) {
  return Positioned(
    child: Image(image: AssetImage('assets/man-user.png'), width: width),
    left: position.dx,
    top: position.dy,
  );
}

Widget getTopBubbleBar(MyHomePageState homePageState, Map<String, dynamic> modelConfig,
    double globalWidth, double globalHeight) {
  double imageDimensions = 200;
  double xOffset = globalWidth / 2 - imageDimensions / 2;
  double yOffset = globalHeight / 4;
  Offset imagePosition = Offset(xOffset, yOffset);

  return Expanded(
    child: Row(
      children: <Widget>[
        Expanded(
          child: Stack(
            children: <Widget>[
              DragBubble(Offset(0.0, 0.0), homePageState, modelConfig, "sex",
                  "Sex", asyncSexInputDialog),
              DragBubble(Offset(100.0, 0.0), homePageState, modelConfig,
                  "wheezeInChestInLastYear", "Wheeze", asyncWheezeInputDialog),
              DragBubble(Offset(200.0, 0.0), homePageState, modelConfig,
                  "COPD", "COPD", asyncCOPDInputDialog),
              DragBubble(Offset(300, 0.0), homePageState, modelConfig,
                  "neverSmoked", "Never Smoked", asyncNeverSmokedInputDialog),
              getPatientImage(imageDimensions, imagePosition),
              DiseaseBubble(
                  "COPD",
                  Offset(imagePosition.dx - 90, imagePosition.dy),
                  homePageState),
              DiseaseBubble(
                  "Asthma",
                  Offset(imagePosition.dx + imageDimensions, imagePosition.dy),
                  homePageState),
              DiseaseBubble(
                  "Tuberculosis",
                  Offset(imagePosition.dx - 90,
                      imagePosition.dy + imageDimensions - 40),
                  homePageState),
              DiseaseBubble(
                  "Diabetes",
                  Offset(imagePosition.dx + imageDimensions,
                      imagePosition.dy + imageDimensions - 40),
                  homePageState),
            ],
          ),
        ),
      ],
    ),
  );
}
