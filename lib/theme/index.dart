export 'metrics.dart';
export 'light.dart';
export 'dark.dart';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';

import 'light.dart';
import 'dark.dart';
import 'metrics.dart';

class AriThemeController {
  AriThemeController._internal();
  // 单例模式
  static final AriThemeController _instance = AriThemeController._internal();

  factory AriThemeController() {
    return _instance;
  }

  /// 获取对于Brightness模式下的themeData
  ///
  ///  ThemeData是MaterialApp的theme属性，一般是用在MaterialApp的theme属性中,
  /// 代码中获得样式推荐使用AriTheme
  ///
  /// *参数*
  /// - `brightness`: 亮度模式
  ///
  /// *return*
  /// - `ThemeData`: 对应的ThemeData
  ThemeData getThemeData(Brightness? brightness) {
    if (brightness == Brightness.light || brightness == null) {
      return ariThemeDataLight;
    } else {
      return ariThemeDataDark;
    }
  }
}

/// Aries的度量或数值方面的主题设置
///
/// 不涉及到颜色的主题设置，都放在该类中,
/// 使用的时候直接调用[AriTheme]即可，不用实例化
///
/// 例如：
/// ```dart
/// double insets = AriTheme.insets.standard
/// ````
///
/// 颜色方面的主题颜色
///
/// ```dart
/// AriThemeColor themeColor = AriThemeColor.of(context);
/// ```
@immutable
class AriTheme {
  /// 间距
  ///
  /// 一般是用于widget之间的间距
  static final AriThemeInsets insets = AriThemeInsets();

  /// widget与屏幕的间距
  ///
  /// 一般用于设定与屏幕的间距
  static final AriThemeWindowsInsets windowsInsets = AriThemeWindowsInsets();

  /// 圆角
  static final AriThemeBorderRadius borderRadius = AriThemeBorderRadius();

  /// 动画时间
  static final AriThemeDuration duration = AriThemeDuration();

  /// 文本样式
  static final AriThemeTextStyle textStyle = AriThemeTextStyle();

  /// 模糊效果
  static final AriThemeFilter filter = AriThemeFilter();

  static final AriThemeOpacity opacity = AriThemeOpacity();

  /// 按钮
  static final AriThemeButton button = AriThemeButton();

  /// 弹出框
  static final AriThemeModal modal = AriThemeModal();

  /// 输入框
  static final AriThemeTextField textField = AriThemeTextField();
}

/***************  以下是AriThemeColor颜色主题的类 ***************/

/// {@template ari_theme_color}
/// Aries的颜色主题
///
/// ```dart
/// AriThemeColor themeColor = AriThemeColor.of(context);
/// ```
/// {@endtemplate}
@immutable
class AriThemeColor {
  /// {@macro ari_theme_color}
  AriThemeColor({
    required this.colorScheme,
    required this.prime,
    required this.shadow,
    required this.button,
    required this.modal,
    required this.gradient,
    required this.text,
  });

  /// 主色调
  final ColorScheme colorScheme;

  final AriThemeColorPrime prime;

  /// 阴影
  final AriThemeColorBoxShadow shadow;

  /// 按钮
  final AriThemeColorButton button;

  /// 弹出框
  final AriThemeColorModal modal;

  /// 渐变
  final AriThemeColorGradient gradient;

  final AriThemeColorText text;

  /// 获取对于Brightness模式下的AriThemeColor
  ///
  /// AriThemeColor是当前灯光模式下的颜色样式，如果是需要数值方面的样式，调用[AriTheme]即可
  /// 例如：
  /// ```dart
  /// AriThemeColor themeColor = AriThemeColor.of(context);
  /// ```
  ///
  /// *参数*
  /// - `context`: 上下文
  ///
  /// *return*
  /// - `AriThemeColor`: 对应的AriThemeColor
  static AriThemeColor of(BuildContext context) {
    Brightness brightness = MediaQuery.of(context).platformBrightness;
    if (brightness == Brightness.light) {
      return ariThemeLight;
    } else {
      return ariThemeDark;
    }
  }
}

/// Aries的阴影样式
@immutable
class AriThemeColorBoxShadow {
  const AriThemeColorBoxShadow({
    required this.standard,
    required this.surfaceVariant,
    required this.bottomSheet,
    required this.bottomNavigationBar,
    required this.messageBar,
  });

  /// 标准阴影
  final BoxShadow standard;

  /// 背景高亮时的阴影
  final BoxShadow surfaceVariant;

  /// 底部弹出框阴影
  final BoxShadow bottomSheet;

  /// 底部导航栏阴影
  final BoxShadow bottomNavigationBar;

  final BoxShadow messageBar;
}

/// Aries的按钮样式
@immutable
class AriThemeColorButton {
  const AriThemeColorButton({
    required this.gradientButton,
    required this.segmentedIconButton,
    required this.segmentedIconButtonContainer,
    required this.filledIconButton,
    required this.markerIcon,
  });

  /// 渐变按钮
  final ButtonStyle gradientButton;

  ///  segmentedIconButton单个按钮的样式
  final ButtonStyle segmentedIconButton;

  /// segmentedIconButton容器的样式
  final BoxDecoration segmentedIconButtonContainer;

  /// 背景填充的iconButton样式
  final ButtonStyle filledIconButton;

  /// 标记的icon颜色
  final Color markerIcon;
}

/// Aries的弹出框样式
@immutable
class AriThemeColorModal {
  const AriThemeColorModal({
    required this.bottomSheet,
  });

  /// 底部弹出框
  final BoxDecoration bottomSheet;
}

/// Aries的渐变样式
@immutable
class AriThemeColorGradient {
  const AriThemeColorGradient({
    required this.loginBackgroundGradient,
  });

  final Gradient loginBackgroundGradient;
}

@immutable
class AriThemeColorText {
  const AriThemeColorText({
    required this.messageBar,
  });

  final TextStyle messageBar;
}

/// 自定义的色彩
///
/// 变量名组成: [on?]颜色名[数字]
/// - 后缀不带数字的默认为500,例如: onGrey等于onGrey500,它代表着标准颜色
///   - 在Ligth下,后缀数字越大,颜色越深
///   - 在Dark下,后缀数字越大,颜色越浅
/// - 不带on的使用在容器,背景等颜色上,
///   带on的使用在字体,图标等颜色上
@immutable
class AriThemeColorPrime extends ThemeExtension<AriThemeColorPrime> {
  const AriThemeColorPrime({
    required this.blue,
    required this.green,
    required this.red,
    required this.yellow,
    required this.orange,
    required this.purple,
    required this.grey,
    required this.grey600,
    required this.onGrey,
    required this.onGrey600,
    required this.onGrey700,
    required this.white,
  });

  final Color? blue;
  final Color? green;
  final Color? red;
  final Color? yellow;
  final Color? orange;
  final Color? purple;
  final Color? grey;
  final Color? grey600;
  final Color? onGrey;
  final Color? onGrey600;
  final Color? onGrey700;
  final Color? white;

  @override
  AriThemeColorPrime copyWith({
    Color? blue,
    Color? green,
    Color? red,
    Color? yellow,
    Color? orange,
    Color? purple,
    Color? grey,
    Color? grey600,
    Color? onGrey,
    Color? onGrey600,
    Color? onGrey700,
    Color? white,
  }) {
    return AriThemeColorPrime(
      blue: blue ?? this.blue,
      green: green ?? this.green,
      red: red ?? this.red,
      yellow: yellow ?? this.yellow,
      orange: orange ?? this.orange,
      purple: purple ?? this.purple,
      grey: grey ?? this.grey,
      grey600: grey600 ?? this.grey600,
      onGrey: onGrey ?? this.onGrey,
      onGrey600: onGrey600 ?? this.onGrey600,
      onGrey700: onGrey700 ?? this.onGrey700,
      white: white ?? this.white,
    );
  }

  @override
  AriThemeColorPrime lerp(ThemeExtension<AriThemeColorPrime>? other, double t) {
    if (other is! AriThemeColorPrime) {
      return this;
    }
    return AriThemeColorPrime(
      blue: Color.lerp(blue, other.blue, t),
      green: Color.lerp(green, other.green, t),
      red: Color.lerp(red, other.red, t),
      yellow: Color.lerp(yellow, other.yellow, t),
      orange: Color.lerp(orange, other.orange, t),
      purple: Color.lerp(purple, other.purple, t),
      grey: Color.lerp(grey, other.grey, t),
      grey600: Color.lerp(grey600, other.grey600, t),
      onGrey: Color.lerp(onGrey, other.onGrey, t),
      onGrey600: Color.lerp(onGrey600, other.onGrey600, t),
      onGrey700: Color.lerp(onGrey700, other.onGrey700, t),
      white: Color.lerp(white, other.white, t),
    );
  }

  /// Returns an instance of [AriThemeColorPrime] in which the following custom
  /// colors are harmonized with [dynamic]'s [ColorScheme.primary].
  ///   * [AriThemeColorPrime.blue]
  ///   * [AriThemeColorPrime.green]
  ///   * [AriThemeColorPrime.red]
  ///   * [AriThemeColorPrime.yellow]
  ///   * [AriThemeColorPrime.orange]
  ///   * [AriThemeColorPrime.grey]
  ///  * [AriThemeColorPrime.white]
  ///
  /// See also:
  ///   * <https://m3.material.io/styles/color/the-color-system/custom-colors#harmonization>
  AriThemeColorPrime harmonized(ColorScheme dynamic) {
    return copyWith(
      blue: blue!.harmonizeWith(dynamic.primary),
      green: green!.harmonizeWith(dynamic.primary),
      red: red!.harmonizeWith(dynamic.primary),
      yellow: yellow!.harmonizeWith(dynamic.primary),
      orange: orange!.harmonizeWith(dynamic.primary),
      purple: purple!.harmonizeWith(dynamic.primary),
      grey: grey!.harmonizeWith(dynamic.primary),
      grey600: grey600!.harmonizeWith(dynamic.primary),
      onGrey: onGrey!.harmonizeWith(dynamic.primary),
      onGrey600: onGrey600!.harmonizeWith(dynamic.primary),
      onGrey700: onGrey700!.harmonizeWith(dynamic.primary),
      white: white!.harmonizeWith(dynamic.primary),
    );
  }
}
