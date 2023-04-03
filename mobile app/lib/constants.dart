import 'package:flutter/material.dart';

const kTextFieldDecoration = InputDecoration(
  /*floatingLabelAlignment: FloatingLabelAlignment.start,
  floatingLabelBehavior: FloatingLabelBehavior.auto,
  labelStyle: const TextStyle(
    color: Colors.white,
  ),
  enabledBorder: const UnderlineInputBorder(
    borderSide: BorderSide(
      color: Colors.white,
      width: 2.0,
    ),
  ),
  focusedBorder: const UnderlineInputBorder(
    borderSide: BorderSide(
      color: Color(0xFF184045),
      width: 2.0,
    ),
  ),*/
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  fillColor: Colors.white,
  filled: true,
  hintStyle: TextStyle(
    color: Color(0xE8184045),
  ),
  border: OutlineInputBorder(
    borderSide: BorderSide.none,
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xE8184045), width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
  ),
);

//Api key bdd64b44460e4a238f141f941c9a8faa
const kApiKey = 'bdd64b44460e4a238f141f941c9a8faa';
