import 'dart:math' as math;
import 'package:bmi_calculator/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:bmi_calculator/input_page/height/height_styles.dart';
import 'package:bmi_calculator/input_page/height/height_slider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HeightPicker extends StatefulWidget {
  final int maxHeight;
  final int minHeight;
  final int height;
  final double widgetHeight;
  final ValueChanged<int> onChange;

  HeightPicker(
      {Key key,
      this.height,
      this.widgetHeight,
      this.onChange,
      this.maxHeight = 190,
      this.minHeight = 145})
      : super(key: key);

  int get totalUnits => maxHeight - minHeight;

  @override
  _HeightPickerState createState() => _HeightPickerState();
}

class _HeightPickerState extends State<HeightPicker> {
  double startDragYOffset;
  int startDragHeight;

  double get _pixelsPerUnit => _drawingHeight / widget.totalUnits;

  double get _sliderPosition {
    double halfOfBottomLabel = labelsFontSize / 2;
    int unitsFromBottom = widget.height - widget.minHeight;
    return halfOfBottomLabel + unitsFromBottom * _pixelsPerUnit;
  }

  double get _drawingHeight {
    double totalHeight = widget.widgetHeight;
    double marginBottom = marginBottomAdapted(context);
    double marginTop = marginTopAdapted(context);
    return totalHeight - (marginBottom + marginTop + labelsFontSize);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTapDown: _onTapDown,
      onVerticalDragStart: _onDragStart,
      onVerticalDragUpdate: _onDragUpdate,
      child: Stack(
        children: <Widget>[
          _drawPersonImage(),
          _drawSlider(),
          _drawLabels(),
        ],
      ),
    );
  }

  void _onTapDown(TapDownDetails tapDownDetails) {
    int height = _globalOffsetToHeight(tapDownDetails.globalPosition);
    widget.onChange(_normalizeHeight(height));
  }

  void _onDragStart(DragStartDetails dragStartDetails) {
    int newHeight = _globalOffsetToHeight(dragStartDetails.globalPosition);
    widget.onChange(newHeight);

    setState(() {
      startDragYOffset = dragStartDetails.globalPosition.dy;
      startDragHeight = newHeight;
    });
  }

  void _onDragUpdate(DragUpdateDetails dragUpdateDetails) {
    double currnetYOffset = dragUpdateDetails.globalPosition.dy;
    double verticalDiffernce = startDragYOffset - currnetYOffset;
    int diffHeight = verticalDiffernce ~/ _pixelsPerUnit;
    int height = _normalizeHeight(startDragHeight + diffHeight);
    setState(() {
      widget.onChange(height);
    });
  }

  int _normalizeHeight(int height) {
    return math.max(widget.minHeight, math.min(widget.maxHeight, height));
  }

  int _globalOffsetToHeight(Offset globalOffset) {
    RenderBox getBox = context.findRenderObject();
    Offset localPosition = getBox.globalToLocal(globalOffset);
    double dy = localPosition.dy;
    dy = dy - marginTopAdapted(context) - labelsFontSize / 2;
    int height = widget.maxHeight - (dy ~/ _pixelsPerUnit);
    return height;
  }

  Widget _drawPersonImage() {
    double personImageHeight = _sliderPosition + marginBottomAdapted(context);
    return Align(
      alignment: Alignment.bottomCenter,
      child: SvgPicture.asset(
        'images/person.svg',
        width: personImageHeight / 3,
        height: personImageHeight,
      ),
    );
  }

  Widget _drawSlider() {
    return Positioned(
      child: HeightSlider(height: widget.height),
      left: 0,
      right: 0,
      bottom: _sliderPosition,
    );
  }

  Widget _drawLabels() {
    int labelsToDisplay = widget.totalUnits ~/ 5 + 1;
    List<Widget> labels = List.generate(
      labelsToDisplay,
      (idx) => Text(
            "${widget.maxHeight - 5 * idx}",
            style: labelsTextStyle,
          ),
    );

    return Align(
      alignment: Alignment.centerRight,
      child: IgnorePointer(
        child: Padding(
          padding: EdgeInsets.only(
            right: screenAwareSize(12.0, context),
            bottom: marginBottomAdapted(context),
            top: marginTopAdapted(context),
          ),
          child: Column(
            children: labels,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
        ),
      ),
    );
    // return
  }
}
