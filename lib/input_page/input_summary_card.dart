import 'package:flutter/material.dart';
import 'package:bmi_calculator/models/gender.dart';
import 'package:bmi_calculator/widget_utils.dart';

class InputSummaryCard extends StatelessWidget {
  final Gender gender;
  final int height;
  final int weight;

  InputSummaryCard({Key key, this.gender, this.height, this.weight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(screenAwareSize(16.0, context)),
      child: SizedBox(
        height: screenAwareSize(32.0, context),
        child: Row(
          children: <Widget>[
            Expanded(child: _genderText()),
            _divider(),
            Expanded(child: _text("${weight}kg")),
            _divider(),
            Expanded(child: _text("${height}cm")),
          ],
        ),
      ),
    );
  }

  Widget _genderText() {
    String genderText = gender == Gender.other
        ? '-'
        : (gender == Gender.male ? 'Male' : 'Female');
    return _text(genderText);
  }

  Widget _divider() {
    return Container(width: 1.0, color: Color.fromRGBO(151, 151, 151, 0.1));
  }

  Widget _text(String text) {
    return Text(
      text,
      style: TextStyle(
        color: Color.fromRGBO(143, 144, 153, 1.0),
        fontSize: 15.0,
      ),
      textAlign: TextAlign.center,
    );
  }
}
