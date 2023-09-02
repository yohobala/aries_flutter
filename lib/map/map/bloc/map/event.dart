import 'package:flutter/animation.dart';
import 'package:latlong2/latlong.dart';
import 'package:aries_design_flutter/aries_design_flutter.dart';

abstract class AriMapEvent {}

/***************  初始化、权限有关事件 ***************/

/// {@template InitAriMapEvent}
/// 初始化
///
/// 在这里面会检查权限，并开启定位监听，
/// 但是因为定位需要时间，不能马上就发出[InitAriMapState]，
/// 这样会造成GoToPositionEvent失败
/// {@endtemplate}
class InitAriMapEvent extends AriMapEvent {}

/// 初始化完成
///
/// 开启了定位监听后，通过触发这个事件，发出[InitAriMapState]
class InitAriMapCompleteEvent extends AriMapEvent {}

/// {@template CheckGeoLocationAvailableEvent}
/// 检查是否支持定位
/// {@endtemplate}
class CheckGeoLocationAvailableEvent extends AriMapEvent {
  /// {@macro CheckGeoLocationAvailableEvent}
  CheckGeoLocationAvailableEvent();
}

/***************  地图有关事件  ***************/

/// 监听map的mapEventStream，当地图移动时，可以通知
///
/// emit:
/// - [IsCenterOnPostion]
class MapMoveEvent extends AriMapEvent {
  MapMoveEvent({
    required this.isCenter,
  });
  final bool isCenter;
}

/***************  位置有关事件  ***************/

/// 地图移动到当前定位
///
/// emit:
///  - [MapLocationState]
///  - [IsCenterOnPostion]
class GoToPositionEvent extends AriMapEvent {
  GoToPositionEvent({
    this.animationController,
  });

  AnimationController? animationController;
}

/// GPS定位发生改变
class ChangeLocationEvent extends AriMapEvent {
  ChangeLocationEvent({
    required this.latLng,
  });
  final LatLng latLng;
}

/// 更新定位标记
class UpdateLocationMarkerEvent extends AriMapEvent {
  UpdateLocationMarkerEvent({
    required this.latLng,
  });
  final LatLng latLng;
}

/***************  图层有关事件  ***************/

/// 更新图层
class UpdateLayerEvent extends AriMapEvent {
  UpdateLayerEvent({
    required this.layers,
  });
  final List<AriLayerModel> layers;
}