import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:android_system_font/android_system_font.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _fontFilePath = 'Unknown';
  final _androidSystemFontPlugin = AndroidSystemFont();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  static Future<ByteData> _readFileBytes(String path) async {
    var bytes = await File(path).readAsBytes();
    return ByteData.view(bytes.buffer);
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String fontFilePath;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      fontFilePath =
          await _androidSystemFontPlugin.getFilePath() ?? 'Unknown font file path';
    } on PlatformException {
      fontFilePath = 'Failed to get font file path.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _fontFilePath = fontFilePath;
      var fontLoader = FontLoader('SystemFont');
      fontLoader.addFont(_readFileBytes(fontFilePath));
      fontLoader.load();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: "SystemFont"
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('System font file path is:\n$_fontFilePath'),
        ),
      ),
    );
  }
}
