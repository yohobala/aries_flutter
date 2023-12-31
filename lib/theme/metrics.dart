import 'dart:ui';

import 'package:aries_design_flutter/aries_design_flutter.dart';
import 'package:flutter/material.dart';

/// 间距
///
/// 一般是用于widget之间的间距
class AriThemeInsets {
  final double extraSmall = 3;
  final double small = 5;
  final double standard = 10;
  final double medium = 15;
  final double large = 20;
  final double extraLarge = 30;
}

/// widget与屏幕的间距
///
/// 一般用于设定与屏幕的间距
/// 设备垂直时一般只设置left和right
/// 设备水平时一般只设置top和bottom
class AriThemeWindowsInsets {
  final double top = AriTheme.insets.medium;
  final double bottom = AriTheme.insets.medium;
  final double left = AriTheme.insets.medium;
  final double right = AriTheme.insets.medium;
}

/// 圆角
class AriThemeBorderRadius {
  final Radius zero = Radius.zero;
  final Radius extraSmall = Radius.circular(4);
  final Radius small = Radius.circular(8);
  final Radius standard = Radius.circular(12);
  final Radius large = Radius.circular(16);
  final Radius extraLarge = Radius.circular(28);

  /// 圆形
  final Radius circle = Radius.circular(99999);
}

class _Duration {
  static Duration zero = Duration.zero;
  static Duration fast1 = Duration(milliseconds: 50);
  static Duration fast2 = Duration(milliseconds: 100);
  static Duration fast3 = Duration(milliseconds: 150);
  static Duration fast4 = Duration(milliseconds: 200);
  static Duration medium1 = Duration(milliseconds: 250);
  static Duration medium2 = Duration(milliseconds: 300);
  static Duration medium3 = Duration(milliseconds: 350);
  static Duration medium4 = Duration(milliseconds: 400);
  static Duration long1 = Duration(milliseconds: 450);
  static Duration long2 = Duration(milliseconds: 500);
  static Duration long3 = Duration(milliseconds: 550);
  static Duration long4 = Duration(milliseconds: 600);
  static Duration extralong1 = Duration(milliseconds: 700);
  static Duration extralong2 = Duration(milliseconds: 800);
  static Duration extralong3 = Duration(milliseconds: 900);
  static Duration extralong4 = Duration(milliseconds: 1000);
}

/// 动画时间
class AriThemeDuration {
  final Duration zero = _Duration.zero;
  final Duration fast1 = _Duration.fast1;
  final Duration fast2 = _Duration.fast2;
  final Duration fast3 = _Duration.fast3;
  final Duration fast4 = _Duration.fast4;
  final Duration medium1 = _Duration.medium1;
  final Duration medium2 = _Duration.medium2;
  final Duration medium3 = _Duration.medium3;
  final Duration medium4 = _Duration.medium4;
  final Duration long1 = _Duration.long1;
  final Duration long2 = _Duration.long2;
  final Duration long3 = _Duration.long3;
  final Duration long4 = _Duration.long4;
  final Duration extralong1 = _Duration.extralong1;
  final Duration extralong2 = _Duration.extralong2;
  final Duration extralong3 = _Duration.extralong3;
  final Duration extralong4 = _Duration.extralong4;

  /// 默认动画时间
  final Duration standard = _Duration.medium1;

  /// 页面切换的动画时间
  final Duration pageDration = _Duration.medium1;

  /// 按钮缩放的动画时间
  final Duration buttonScaleDuration = _Duration.medium1;

  /// 地图动画时间
  final Duration mapDuration = _Duration.long4;

  final Duration heroDuration = _Duration.long2;
}

class AriThemeIconSize {
  static double extraSmall = 16;
  static double small = 20;
  static double standard = 24;
  static double medium = 32;
  static double large = 40;
  static double extraLarge = 48;
}

/// 字体大小
class AriThemeFontSize {
  static double displayLarge = 57;
  static double displayMedium = 45;
  static double displaySmall = 36;
  static double headlineLarge = 32;
  static double headlineMedium = 28;
  static double headlineSmall = 24;
  static double titleLarge = 22;
  static double titleMedium = 16;
  static double titleSmall = 14;
  static double bodyLarge = 16;
  static double bodyMedium = 14;
  static double bodySmall = 12;
  // 按钮等默认这个大小
  static double labelLarge = 14;
  static double labelMedium = 12;
  static double labelSmall = 11;
}

/// 文本样式
class AriThemeTextStyle {
  /// 对话框\弹出框标题
  final TextStyle containerTitle = TextStyle(
    fontSize: AriThemeFontSize.headlineMedium,
    fontWeight: FontWeight.w600,
  );

  /// 对话框\弹出框容器标题
  final TextStyle containerItemTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );

  /// 页面标题
  final TextStyle pageTitle = TextStyle(
    fontSize: AriThemeFontSize.displayMedium,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );

  /// 页面渐变标题
  final TextStyle pageTitleGradient = TextStyle(
    fontSize: AriThemeFontSize.displaySmall,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    color: Colors.white,
  );

  /// 用于相比于正常文字,需要突出显示的文本
  ///
  /// 比如设置项的标题
  final TextStyle tipTitle = TextStyle(
    fontSize: AriThemeFontSize.titleMedium,
    fontWeight: FontWeight.w500,
  );
}

/// 模糊效果
class AriThemeFilter {
  /// 标准模糊效果
  final ImageFilter standard = ImageFilter.blur(sigmaX: 20, sigmaY: 20);
}

class AriThemeOpacity {
  final double opaque = 0;
  final double standard = 0.8;
  final double blurOpacity = 0.7;
  final double semiTransparent = 0.5;
}

/// 按钮
///
/// 如果要获得MaterialStateProperty<T>中的T，请使用如下代码，其中
/// - resolve() 方法时传入一个空的状态集合，表示获得默认的值
/// - resolve({MaterialState.pressed}) 表示获得按下时的值
/// ```dart
///   Size? size = AriTheme.button.buttonSize.resolve({});
/// ```
class AriThemeButton {
  // MODULE:
  // 按钮的通用样式

  /// 形状,
  /// 目前定义的是圆角按钮
  final MaterialStateProperty<OutlinedBorder?> standardShape =
      MaterialStateProperty.all<RoundedRectangleBorder>(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.all(AriTheme.borderRadius.circle),
      side: BorderSide.none,
    ),
  );

  /// 间距
  final MaterialStateProperty<EdgeInsetsGeometry?> padding =
      MaterialStateProperty.all<EdgeInsetsGeometry>(
          EdgeInsets.all(AriTheme.insets.standard));

  /// 用于定义按钮或其他可点击组件的触摸区域的大小
  MaterialTapTargetSize get tapTargetSize => MaterialTapTargetSize.shrinkWrap;

  /// 按钮的尺寸
  final MaterialStateProperty<Size> buttonSize =
      MaterialStateProperty.all<Size>(Size(80, 40));

  /// icon按钮的尺寸
  final MaterialStateProperty<Size> iconButtonSize =
      MaterialStateProperty.all<Size>(Size(40, 40));

  final double unselectedMarker = 20;

  // MODULE:
  // 分段按钮

  /// segmentedIconButton容器的样式
  final BoxDecoration segmentedIconButtonContainer = BoxDecoration(
    borderRadius: BorderRadius.all(AriTheme.borderRadius.standard),
  );

  /// segmentedIconButton的尺寸
  ///
  /// 因为是圆形或正方形，所以长宽一样
  final double segmentedIconButtonSize = 40;
}

/// 弹出框
class AriThemeModal {
  // MODULE:
  // 底部弹出框
  /// 底部弹出框的样式
  final BoxDecoration bottomSheet = BoxDecoration(
    borderRadius: BorderRadius.only(
      topLeft: AriTheme.borderRadius.standard,
      topRight: AriTheme.borderRadius.standard,
    ),
  );

  /// 底部弹出框的容器样式
  final Container bottomSheetContainer = Container(
    padding: EdgeInsets.only(
      top: AriTheme.insets.large,
      bottom: AriTheme.insets.large,
    ),
  );

  /// MODULE:
  /// message-bar
  final double messageBarHeight = 40;
  final double messageBarWidthFactor = 0.8;

  final BoxDecoration messageBarDecoration = BoxDecoration(
    borderRadius: BorderRadius.all(AriTheme.borderRadius.standard),
  );
}

/// 输入框
class AriThemeTextField {
  // MODULE:
  // 带边框的输入框 样式
  final InputDecoration borderTextfieldInputDecoration = InputDecoration(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(AriTheme.borderRadius.standard),
      borderSide: BorderSide.none,
    ),
  );
  final EdgeInsetsGeometry borderTextfieldInputDecorationIconPadding =
      EdgeInsets.symmetric(horizontal: AriTheme.insets.large);
}
