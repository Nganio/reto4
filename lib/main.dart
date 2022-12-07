import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gps_tracking/controlador/controladorGen.dart';

import 'interfaz/principal.dart';

void main() {
  Get.put(controladorGen());
  runApp(const MyApp());
}
