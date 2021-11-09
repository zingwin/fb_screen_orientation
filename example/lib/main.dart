import 'package:flutter/material.dart';
import 'package:fb_screen_orientation/fb_screen_orientation.dart';
import 'package:flutter/services.dart';

void main() {
  // 竖屏显示

  runApp(MyApp());

  SystemChrome.setPreferredOrientations(const [
    DeviceOrientation.portraitUp,
  ]);
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String ori = "";

  @override
  void initState() {
    super.initState();
  }

  void _initListener() {
    FbScreenOrientation.instance().init();
    FbScreenOrientation.instance().listenerOrientation((e) {
      if (e == FbScreenOrientation.portraitUp) {
        if (ori == "portraitUp") return;
        setState(() {
          ori = "portraitUp";
        });
        print("摄像头在上");
      } else if (e == FbScreenOrientation.portraitDown) {
        if (ori == "portraitDown") return;
        setState(() {
          ori = "portraitDown";
        });
        print("摄像头在下");
      } else if (e == FbScreenOrientation.landscapeLeft) {
        if (ori == "landscapeLeft") return;
        setState(() {
          ori = "landscapeLeft";
        });
        print("landscapeLeftv 摄像头在左");
      } else if (e == FbScreenOrientation.landscapeRight) {
        if (ori == "landscapeRight") return;
        setState(() {
          ori = "landscapeRight";
        });
        print("landscapeLeftv 摄像头在右");
      }
    });
  }

  void _cancelListener() {
    FbScreenOrientation.instance().cancel();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Plugin example app'),
          ),
          body: Column(
            children: [
              Text('设备方向： $ori'),
              ElevatedButton(onPressed: _initListener, child: Text('开始监听')),
              ElevatedButton(onPressed: _cancelListener, child: Text('取消监听')),
            ],
          )),
    );
  }
}
