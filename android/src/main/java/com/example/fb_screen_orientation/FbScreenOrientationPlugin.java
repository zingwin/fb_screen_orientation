package com.example.fb_screen_orientation;

import android.content.Context;
import android.hardware.SensorManager;
import android.os.Build;
//import android.provider.Settings;
import android.view.OrientationEventListener;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** FbScreenOrientationPlugin */
public class FbScreenOrientationPlugin implements FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
  private OrientationEventListener mOrientationListener;
  private Context context;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "fb_screen_orientation");
    channel.setMethodCallHandler(this);
    context = flutterPluginBinding.getApplicationContext();
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("init")) {
      initOrientation();
      result.success(true);
    }else if (call.method.equals("cancel")) {
      result.success(cancelOrientaion());
    } else {
      result.notImplemented();
    }
  }

  private boolean cancelOrientaion(){
    if(mOrientationListener != null){
      mOrientationListener.disable();
      mOrientationListener = null;
    }
    return true;
  }

  private void initOrientation() {
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.CUPCAKE) {
      mOrientationListener = new OrientationEventListener(context,
              SensorManager.SENSOR_DELAY_NORMAL) {
        @Override
        public void onOrientationChanged(int orientation) {
//          ????????????????????????????????????????????????
///          int flag = Settings.System.getInt(context.getContentResolver(),
///                  Settings.System.ACCELEROMETER_ROTATION, 1);
///          if(flag != 1) return;
          if (orientation == OrientationEventListener.ORIENTATION_UNKNOWN) {
            return;  //?????????????????????????????????????????????
          }
          //???????????????????????????????????????????????????????????????????????????
          if (orientation > 350 || orientation < 10) { //0???
            //???????????????
            channel.invokeMethod("orientationCallback","1");
          } else if (orientation > 80 && orientation < 100) { //90???
            //???????????????
            channel.invokeMethod("orientationCallback","4");
          } else if (orientation > 170 && orientation < 190) { //180???
            //???????????????
            channel.invokeMethod("orientationCallback","2");
          } else if (orientation > 260 && orientation < 280) { //270???
            //???????????????
            channel.invokeMethod("orientationCallback","3");
          }
        }
      };
      if (mOrientationListener.canDetectOrientation()) {
        mOrientationListener.enable();
      } else {
        mOrientationListener.disable();
      }
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }
}
