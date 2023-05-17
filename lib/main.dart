import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:movie/ui/HomePage.dart';
import 'MyHttpOverrides.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const HomePageApp());
}
