import 'dart:ffi';

import 'package:aries_design_flutter/aries_design_flutter.dart';
import 'package:flutter/material.dart';

/// 点击事件
///
/// - `selectIndex` 当前icon的索引
/// - `animationController` 动画控制器
typedef AriIconButtonOnPressed = void Function(
    ValueNotifier<int> selectIndex, AnimationController animationController);

/// 图标按钮
class AriIconButton extends StatefulWidget {
  //*--- 构造函数 ---*
  /// 图标按钮
  ///
  /// - `icons` 图标列表，根据[selectIndex]显示相应的图标
  /// - `selectIndex` 选择的图标,默认为0
  /// - `rotateAngle` 旋转角度，默认为0.0
  /// - `onPressed` 点击事件
  /// - `borderRadius` 圆角
  /// - `style` 按钮样式，默认为[ButtonStyle]
  AriIconButton(
      {Key? key,
      required this.icons,
      ValueNotifier<int>? selectIndex,
      double rotateAngle = 0.0,
      this.onPressed,
      BorderRadiusGeometry? borderRadius,
      ButtonStyle? style})
      : selectIndex = selectIndex ?? ValueNotifier<int>(0),
        rotateAngle = ValueNotifier<double>(rotateAngle),
        borderRadius = ValueNotifier<BorderRadiusGeometry?>(borderRadius),
        style = ValueNotifier<ButtonStyle>(style ?? ButtonStyle()),
        super(key: key);

  //*--- 公有变量 ---*
  /// 图标列表，根据[selectIndex]显示相应的图标
  final List<Widget?> icons;

  /// 选择的图标
  final ValueNotifier<int> selectIndex;

  /// 旋转角度
  final ValueNotifier<double> rotateAngle;

  /// 点击事件
  final AriIconButtonOnPressed? onPressed;

  /// 圆角
  final ValueNotifier<BorderRadiusGeometry?> borderRadius;

  /// 按钮样式
  final ValueNotifier<ButtonStyle> style;

  @override
  State<StatefulWidget> createState() => AriIconButtonState();
}

class AriIconButtonState extends State<AriIconButton>
    with TickerProviderStateMixin {
  //*--- 公有变量 ---*
  bool isFav = false;

  /// 点击事件，回调函数
  ///
  /// - `selectIndex` 当前icon的索引
  /// - `animationController` 动画控制器
  ///
  /// 这个方法主要是为了继承AriIconButtonState时触发onPressed。
  /// 如果是直接使用AriIconButton创建widget用不到
  ///
  /// 效果等同于AriIconButton中的onPressed
  AriIconButtonOnPressed? onPressedCallback;

  /// 亮度
  Brightness? brightness;

  //*--- 私有变量 ---*
  /// 动画控制器
  late List<AnimationController> _animationControllers;

  late int preSelectIndex;

  late List<Widget> _elements;

  //*--- 生命周期 ---*
  @override
  void initState() {
    super.initState();

    preSelectIndex = widget.selectIndex.value;
    _animationControllers =
        ariIconSwitchAnimationController(this, widget.icons.length);
    _elements = _build();

    widget.style.addListener(() {
      setState(() {});
    });

    widget.selectIndex.addListener(() {
      animationForward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: _elements,
    );
  }

  //*--- 公有方法 ---*
  /// 播放动画
  ///
  /// `@return` 动画控制器
  ///
  /// 用于在触发图标切换动画
  void animationForward() {
    if (widget.icons.length > 1) {
      // NOTE:
      // 如果当前图标为null，则不进行动画
      if (widget.icons[preSelectIndex] == null) {
        if (widget.icons[widget.selectIndex.value] != null) {
          if (_animationControllers[widget.selectIndex.value].value == 0.0) {
            _animationControllers[widget.selectIndex.value].forward();
          } else {
            _animationControllers[widget.selectIndex.value].reverse();
          }
        }
        preSelectIndex = widget.selectIndex.value;
      }
      // NOTE:
      // 当前动画为正向动画时，点击后反向动画
      else if (_animationControllers[preSelectIndex].value == 1.0) {
        _animationControllers[preSelectIndex].reverse().then((value) {
          if (widget.icons[widget.selectIndex.value] != null) {
            if (_animationControllers[widget.selectIndex.value].value == 0.0) {
              _animationControllers[widget.selectIndex.value].reset();
              _animationControllers[widget.selectIndex.value].forward();
            } else {
              _animationControllers[widget.selectIndex.value].reverse();
            }
          }
          preSelectIndex = widget.selectIndex.value;
        });
      }
      // NOTE:
      // 当前动画为反向动画时，点击后正向动画
      else {
        _animationControllers[preSelectIndex].forward().then((value) {
          if (widget.icons[widget.selectIndex.value] != null) {
            if (_animationControllers[widget.selectIndex.value].value == 0.0) {
              _animationControllers[widget.selectIndex.value].reset();
              _animationControllers[widget.selectIndex.value].forward();
            } else {
              _animationControllers[widget.selectIndex.value].reverse();
            }
          }

          preSelectIndex = widget.selectIndex.value;
        });
      }
    } else if (widget.icons.length == 1) {
      _animationControllers[0].reset();
      _animationControllers[0].forward();
    }
  }

  //*--- 私有方法 ---*
  /// 点击事件
  void _onPressed() {
    AnimationController pressAnimationController = AnimationController(
      vsync: this,
    );

    widget.onPressed?.call(widget.selectIndex, pressAnimationController);
    if (onPressedCallback != null) {
      onPressedCallback!.call(widget.selectIndex, pressAnimationController);
    }
  }

  List<Widget> _build() {
    Widget iconWidget(int index) => Transform.rotate(
          angle: widget.rotateAngle.value,
          // child: FractionallySizedBox(
          //   widthFactor: 1,
          //   heightFactor: 1,
          child: widget.icons[index],
          // ),
        );

    List<Widget> elements = [];
    if (widget.icons.length > 1) {
      for (int i = 0; i < widget.icons.length; i++) {
        bool isSelected = i == widget.selectIndex.value;
        var animation = ariIconSwitchAnimatedBuilder(
          iconWidget(i),
          _animationControllers[i],
          reverse: !isSelected,
        );
        Widget element = IconButton(
          onPressed: _onPressed,
          icon: animation,
          style: widget.style.value,
        );
        elements.add(element);
      }
    } else if (widget.icons.length == 1) {
      var animation = ariIconSwitchAnimatedBuilder(
        iconWidget(0),
        _animationControllers[0],
        signle: true,
      );
      Widget element = IconButton(
        onPressed: _onPressed,
        icon: animation,
        style: widget.style.value,
      );
      elements.add(element);
    }
    return elements;
  }
}
