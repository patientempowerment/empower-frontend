import 'package:flutter/material.dart';
import 'package:bars_frontend/main.dart';
import 'dart:math';
import 'bubbles.dart';

/// Returns the center image at the given position with given size.
Widget getCenterImage(double width, Offset position) {
  return Positioned(
    child: Image(image: AssetImage('assets/images/man-user.png'), width: width),
    left: position.dx,
    top: position.dy,
  );
}

/// Second prototype with bubbles as input and output representation.
class BubblesPage extends StatefulWidget {
  final HomepageState homePageState;

  BubblesPage(this.homePageState);

  @override
  State<StatefulWidget> createState() {
    return BubblesPageState(homePageState);
  }
}

/// [labelBubbleOffsets] Map of labels and their bubble position to let particles flow there.
class BubblesPageState extends State<BubblesPage> {
  final HomepageState homePageState;
  double imageDimensions;
  Offset imagePosition;
  Map<String, Offset> labelBubbleOffsets = Map();
  List<Particle> particles = List();

  BubblesPageState(this.homePageState);

  @override
  initState() {
    imageDimensions = homePageState.globalHeight / 4;
    imagePosition = Offset(homePageState.globalWidth / 2 - imageDimensions / 2,
        homePageState.globalHeight / 3);
    super.initState();
  }

  /// Returns all widgets of bubble prototype in a list.
  List<Widget> _getWidgets() {
    double labelBubbleDimensions = homePageState.globalHeight / 8;
    List<Widget> widgets = List();

    widgets.add(getCenterImage(imageDimensions, imagePosition));
    _addLabelBubbles(widgets, labelBubbleDimensions);
    _addFeatureBubbles(widgets, labelBubbleDimensions);

    for (Particle particle in particles) {
      widgets.add(particle);
    }

    return widgets;
  }

  /// Arranges and adds label bubbles around center image. Does not check for overlapping bubbles in case of a high number.
  _addLabelBubbles(List<Widget> widgets, double labelBubbleDimensions) {
    var boundingRadius =
        sqrt(pow((imageDimensions / 2), 2) * 2) + labelBubbleDimensions / 2;
    var angle = 0.0;
    var step = (2 * pi) / homePageState.modelsConfig.length;
    Offset imageCenter = Offset(imagePosition.dx + imageDimensions / 2,
        imagePosition.dy + imageDimensions / 2);

    homePageState.modelsConfig.forEach((k, v) {
      //45 comes from bubble container height(90) and width(90) divided by 2
      var x = (boundingRadius * cos(angle) - 45).round();
      var y = (boundingRadius * sin(angle) - 45).round();

      // Actually add label bubble.
      LabelBubble labelBubble = LabelBubble(
          homePageState.modelsConfig[k]["title"],
          Offset(imageCenter.dx + x, imageCenter.dy + y),
          labelBubbleDimensions,
          homePageState);
      widgets.add(labelBubble);

      labelBubbleOffsets[k] = Offset(imageCenter.dx + x, imageCenter.dy + y);
      angle += step;
    });
  }

  /// Adds Feature bubbles and places them at the top bar.
  _addFeatureBubbles(List<Widget> widgets, double labelBubbleDimensions) {
    double featureBubbleOffset = 0.0;
    double featureBubbleWidth =
        (homePageState.globalWidth - STANDARD_PADDING * 4) /
            homePageState.featuresConfig.entries.length;
    for (MapEntry<String, dynamic> feature
    in homePageState.featuresConfig.entries) {
      widgets.add(FeatureBubble(
          Offset(featureBubbleOffset, 0.0),
          featureBubbleWidth - STANDARD_PADDING,
          labelBubbleDimensions,
          homePageState,
          this,
          feature));
      featureBubbleOffset += featureBubbleWidth;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Stack(children: _getWidgets()),
        ),
      ],
    );
  }
}
