//
// Generated file. Do not edit.
//

// ignore_for_file: directives_ordering
// ignore_for_file: lines_longer_than_80_chars
// ignore_for_file: depend_on_referenced_packages

import 'package:audioplayers/web/audioplayers_web.dart';
import 'package:cloud_firestore_web/cloud_firestore_web.dart';
import 'package:firebase_core_web/firebase_core_web.dart';
import 'package:firebase_storage_web/firebase_storage_web.dart';
import 'package:flutter_secure_storage_web/flutter_secure_storage_web.dart';
import 'package:fluttertoast/fluttertoast_web.dart';
import 'package:package_info_plus_web/package_info_plus_web.dart';
import 'package:record_web/record_web.dart';
import 'package:shared_preferences_web/shared_preferences_web.dart';

import 'package:flutter_web_plugins/flutter_web_plugins.dart';

// ignore: public_member_api_docs
void registerPlugins(Registrar registrar) {
  AudioplayersPlugin.registerWith(registrar);
  FirebaseFirestoreWeb.registerWith(registrar);
  FirebaseCoreWeb.registerWith(registrar);
  FirebaseStorageWeb.registerWith(registrar);
  FlutterSecureStorageWeb.registerWith(registrar);
  FluttertoastWebPlugin.registerWith(registrar);
  PackageInfoPlugin.registerWith(registrar);
  RecordPluginWeb.registerWith(registrar);
  SharedPreferencesPlugin.registerWith(registrar);
  registrar.registerMessageHandler();
}
