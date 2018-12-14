
import 'package:flutter/widgets.dart';

abstract class Styles {

  static const baseTextStyle = TextStyle(
    color: Color.fromRGBO(10, 10, 8, 1.0),
    fontFamily: 'NotoSans',
    fontSize: 16.0,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.normal,
  );

  static const leadingText = TextStyle(
    color: Color.fromRGBO(255, 255, 255, 0.9),
    fontFamily: 'NotoSans',
    fontSize: 24.0,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.normal,
  );

  static const leadingBorder = const Border(
    top: BorderSide(color: Color(0xff606060)),
    left: BorderSide(color: Color(0xff606060)),
    bottom: BorderSide(color: Color(0xff606060)),
    right: BorderSide(color: Color(0xff606060)),
  );

}