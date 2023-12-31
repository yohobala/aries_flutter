import 'dart:async';

import 'package:app_settings/app_settings.dart';
import 'package:aries_design_flutter/aries_design_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// 定位按钮的状态
enum LocationButtonEnum {
  /// 当地图中心偏离当前GPS位置时
  offset,

  /// 当地图中心是GPS位置时
  aligned,

  /// 当前GPS位置不可用时
  unauthorized
}

/// 定位按钮
///
/// 必须依赖于AriMap使用
///
/// *功能*
/// 1. 点击按钮后，如果当前地图中心不是GPS位置，则会移动到GPS位置图标变成[LocationButtonEnum.aligned].
///    如果当前地图中心是GPS位置，则不会移动
/// 2. 当地图中心不是GPS位置时，图标变成[LocationButtonEnum.offset]
///
/// *示例代码*
/// ```dart
/// AriSegmentedIconButton(buttons: [
///   AriLocationButton().build(),
///])
class AriLocationButton extends AriIconButton {
  AriLocationButton({
    GlobalKey<AriIconButtonState>? key,
    this.positionColor,
    this.disabledPermissionColor,
  }) : super(
          key: key,
          icons: [
            Icon(
              Icons.near_me_outlined,
            ),
            Icon(
              Icons.near_me,
              color: positionColor,
            ),
            Icon(
              Icons.near_me_disabled_outlined,
              color: disabledPermissionColor,
            )
          ],
          selectIndex: ValueNotifier(LocationButtonEnum.offset.index),
          rotateAngle: 0,
        );

  final Color? positionColor;

  final Color? disabledPermissionColor;

  @override
  AriLocationButtonState createState() => AriLocationButtonState();
}

class AriLocationButtonState extends AriIconButtonState {
  /***************  私有变量  ***************/

  /// 监听mapBloc的流
  StreamSubscription? _streamSubscription;

  /// 地图中心是否位于GPS位置的上一个状态
  late bool _beforeIsCenterOnLocation = false;

  late AriMapBloc mapBloc;

  /***************  生命周期 ***************/

  @override
  void initState() {
    super.initState();
    mapBloc = context.read<AriMapBloc>();
    _streamSubscription = mapBloc.stream.listen((state) {
      if (state is InitAriMapState) {
        handlerIsGeoLocationAvailable();
      }
      // NOTE:
      // 更新定位权限状态
      if (state is UpdateGeoLocationAvailableState) {
        handlerIsGeoLocationAvailable();
      }
      // NOTE:
      // 判断当前地图中心是否与定位一致
      if (state is IsCenterOnLocation) {
        if (_beforeIsCenterOnLocation != state.isCenter) {
          setState(() {
            if (state.isCenter) {
              widget.selectIndex.value = LocationButtonEnum.aligned.index;
            } else {
              widget.selectIndex.value = LocationButtonEnum.offset.index;
            }
            _beforeIsCenterOnLocation = state.isCenter;
            super.animationForward();
          });
        }
      }
    });

    // NOTE:
    // 按钮点击回调
    onPressedCallback = (selectIndex, animationController) {
      if (mapBloc.geoLocationAvailable) {
        if (selectIndex.value == LocationButtonEnum.offset.index) {
          mapBloc.add(MoveToLocationEvent());
          selectIndex.value = LocationButtonEnum.aligned.index;
        }
      } else {
        selectIndex.value = LocationButtonEnum.unauthorized.index;

        // 标题
        Widget title = Text(
          AriLocalizations.of(context)!.locatio_services_failed_title,
          textAlign: TextAlign.center,
        );
        // 内容
        Widget content = Text(
          AriLocalizations.of(context)!.locatio_services_failed_content,
          textAlign: TextAlign.center,
        );

        List<Widget> buttonBuilder(BuildContext innerContext) {
          return [
            // 打开设置按钮
            FilledButton.tonal(
                onPressed: () => {
                      //关闭

                      Navigator.pop(innerContext,
                          AriLocalizations.of(context)!.confirm_button),
                      // 跳到系统设置里
                      //ios平台
                      AppSettings.openAppSettings(
                          type: AppSettingsType.settings),
                    },
                child: Text(AriLocalizations.of(innerContext)!
                    .location_server_failed_open)),
            // 取消按钮
            TextButton(
                onPressed: () => {
                      Navigator.pop(innerContext,
                          AriLocalizations.of(context)!.cancel_button)
                    },
                child: Text(AriLocalizations.of(innerContext)!
                    .location_server_failed_cancel))
          ];
        }

        showAriDialog(context,
            title: title,
            content: content,
            buttonBuilder: buttonBuilder,
            barrierDismissible: false);
      }
    };
  }

  @override
  void dispose() {
    _streamSubscription?.cancel(); // 不要忘记取消订阅
    super.dispose();
  }

  void handlerIsGeoLocationAvailable() {
    if (!mapBloc.geoLocationAvailable) {
      setState(() {
        widget.selectIndex.value = LocationButtonEnum.unauthorized.index;
      });
    } else {
      setState(() {
        widget.selectIndex.value = LocationButtonEnum.offset.index;
      });
    }
  }
}
