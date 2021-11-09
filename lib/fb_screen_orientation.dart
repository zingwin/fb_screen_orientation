import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

abstract class FbScreenOrientationBase {
  //方向回调
  Function? orientationCallback;
  void setOrientationCallback(Function orientationCallback) {
    this.orientationCallback = orientationCallback;
  }

  //初始化
  Future<void> init();

  //取消监听
  Future<void> cancel();
}

class FbScreenOrientationIos extends FbScreenOrientationBase {
  MethodChannel _channel = const MethodChannel('fb_screen_orientation');

  @override
  Future<void> init() async {
    _channel.setMethodCallHandler((MethodCall call) async {
      if (call.method == "orientationCallback") {
        orientationCallback?.call(int.parse(call.arguments));
      }
    });
    await _channel.invokeMethod('init');
  }

  @override
  Future<void> cancel() async {
    await _channel.invokeMethod('cancel');
  }
}

class FbScreenOrientationAndroid extends FbScreenOrientationBase {
  MethodChannel _channel = const MethodChannel('fb_screen_orientation');
  int lastOrientation = -1;

  @override
  Future<void> init() async {
    _channel.setMethodCallHandler((MethodCall call) async {
      if (call.method == "orientationCallback") {
        int orientation = int.parse(call.arguments);
        if (lastOrientation == orientation) {
          return;
        }
        lastOrientation = orientation;
        orientationCallback?.call(orientation);
      }
    });
    _channel.invokeMethod("init");
  }

  @override
  Future<void> cancel() async {
    await _channel.invokeMethod('cancel');
  }

  @override
  void setOrientationCallback(Function orientationCallback) {
    this.lastOrientation = -1;
    super.setOrientationCallback(orientationCallback);
  }
}

class FbScreenOrientation {
  FbScreenOrientationBase? screenOrientationService;
  static FbScreenOrientation? self;
  static int portraitUp = 1;
  static int portraitDown = 2;
  static int landscapeLeft = 3;
  static int landscapeRight = 4;

  static FbScreenOrientation instance() {
    if (self == null) {
      self = FbScreenOrientation();
    }
    return self!;
  }

  //初始化
  Future<void> init() async {
    if (Platform.isIOS) {
      self!.screenOrientationService = FbScreenOrientationIos();
    } else if (Platform.isAndroid) {
      self!.screenOrientationService = FbScreenOrientationAndroid();
    }
    await self!.screenOrientationService!.init();
  }

  //方向监听
  void listenerOrientation(Function orientationCallback) async {
    self!.screenOrientationService!.setOrientationCallback(orientationCallback);
  }

  Future<void> cancel() async {
    if (Platform.isIOS) {
      self!.screenOrientationService!.cancel();
    } else if (Platform.isAndroid) {
      self!.screenOrientationService!.cancel();
    }
  }
}
