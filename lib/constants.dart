import 'package:flutter/material.dart';

const requestUrl =
    "https://demo.sidsworld.co.in/job-assignment/dzaro/request.php";

const MaterialColor greyBackgroundColor = MaterialColor(
  0xFFdadada,
  <int, Color>{
    50: Color(0xFFdadada),
    100: Color(0xFFdadada),
    200: Color(0xFFdadada),
    300: Color(0xFFdadada),
    400: Color(0xFFdadada),
    500: Color(0xFFdadada),
    600: Color(0xFFdadada),
    700: Color(0xFFdadada),
    800: Color(0xFFdadada),
    900: Color(0xFFdadada),
  },
);

const MaterialColor primaryColor = MaterialColor(
  0xFFD3003A,
  <int, Color>{
    50: Color(0xFFD3003A),
    100: Color(0xFFD3003A),
    200: Color(0xFFD3003A),
    300: Color(0xFFD3003A),
    400: Color(0xFFD3003A),
    500: Color(0xFFD3003A),
    600: Color(0xFFD3003A),
    700: Color(0xFFD3003A),
    800: Color(0xFFD3003A),
    900: Color(0xFFD3003A),
  },
);

List<BoxShadow> constBoxShadow() {
  return [
    BoxShadow(
      color: Colors.grey.shade400,
      offset: const Offset(2.0, 2.0),
      blurRadius: 3.5,
      spreadRadius: 1.5,
    ),
    BoxShadow(
      color: Colors.grey.shade200,
      offset: const Offset(-0.1, -0.1),
      blurRadius: 2.5,
      spreadRadius: 0.5,
    ),
  ];
}

BoxDecoration constBoxDecoration(Color backgroundColor, double borderRadius,
    Color borderColor, double borderWidth, bool boxShadow) {
  return BoxDecoration(
    color: backgroundColor,
    borderRadius: BorderRadius.circular(borderRadius),
    border: Border.all(
      color: borderColor,
      width: borderWidth,
    ),
    boxShadow: boxShadow ? constBoxShadow() : null,
  );
}
