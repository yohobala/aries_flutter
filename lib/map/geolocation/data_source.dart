import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_compass/flutter_compass.dart';

const geoLocationSettings =
    LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 10);

class AriGeoLocationDevice {
  Stream<LatLng> get locationStream => _locationStreamController.stream;

  Stream<double> get compassStream => _compassStream.stream;

  /***************  私有变量  ***************/

  /// 使用 _locationStreamController 来创建自己的流
  late StreamController<LatLng> _locationStreamController;
  late StreamController<double> _compassStream;

  bool _isOpenLocationStream = false;
  bool _isOpenCompassStream = false;

  LatLng? _currentLocation;

  /***************  公有方法  ***************/

  /// 获取当前位置
  ///
  /// 如果开启了流，则会返回流中的位置
  Future<LatLng> getCurrentLocation() async {
    if (_currentLocation == null) {
      Position position = await Geolocator.getCurrentPosition();
      LatLng latLng = LatLng(position.latitude, position.longitude);
      _currentLocation = latLng;
      return latLng;
    } else {
      return _currentLocation!;
    }
  }

  /// 检查是否有定位权限
  Future<LocationPermission> checkPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    return permission;
  }

  /// 开始监听位置变化
  void registerLocationListener() {
    // NOTE:
    // 如果开启了监听，则先取消监听,再注册监听
    if (_isOpenLocationStream) {
      unregisterLocationListener();
    }
    _createLocationStreamController();

    // NOTE:
    // 如果开启了流，则会返回流中的位置
    // 如果没有开启流，则会返回当前位置
    if (_currentLocation != null) {
      _locationStreamController.add(_currentLocation!);
    } else {
      Geolocator.getCurrentPosition().then((Position position) {
        LatLng location = _posToLatLng(position);
        _currentLocation = location;
        _locationStreamController.add(location);
      });
    }
    Geolocator.getPositionStream(
      locationSettings: geoLocationSettings,
    ).listen(
      (Position position) {
        _isOpenLocationStream = true;
        LatLng location = _posToLatLng(position);
        if (location != _currentLocation &&
            !_locationStreamController.isClosed) {
          _currentLocation = location;
          _locationStreamController.add(location); // 向流中添加新的位置数据
        }

        // 其他逻辑...
      },
      onError: (error) {
        // 处理错误...
        _locationStreamController.addError(error);
        unregisterLocationListener();
      },
    );

    // 当流不再使用时，取消订阅
    _locationStreamController.onCancel = () {
      _locationStreamController.close();
    };
  }

  /// 停止监听位置变化
  void unregisterLocationListener() {
    _isOpenLocationStream = false;
    if (!_locationStreamController.isClosed) {
      _locationStreamController.close();
    }
  }

  /// 开始监听罗盘
  void registerCompassListener() {
    if (_isOpenCompassStream) {
      unregisterCompassListener();
    }

    _createCompassStreamController();

    FlutterCompass.events?.first.then((event) {
      if (event.heading != null) {
        _isOpenLocationStream = true;
        _compassStream.add(event.heading!);
      }
    });

    FlutterCompass.events?.listen(((event) {
      if (event.heading != null) {
        _isOpenLocationStream = true;
        _compassStream.add(event.heading!);
      }
    }), onError: (Object error, [StackTrace? stackTrace]) {
      _compassStream.addError('error');
    });

    // 当流不再使用时，取消订阅
    _compassStream.onCancel = () {
      _compassStream.close();
    };
  }

  /// 停止监听罗盘
  void unregisterCompassListener() {
    _isOpenCompassStream = false;
    _compassStream.close();
  }

  /***************  私有方法  ***************/

  /// [Position]转换为[LatLng]
  ///
  /// - `position`: 位置
  ///
  /// *return*
  /// - `位置`: [LatLng]类型的位置
  LatLng _posToLatLng(Position position) {
    LatLng latLng = LatLng(position.latitude, position.longitude);
    return latLng;
  }

  void _createLocationStreamController() {
    _locationStreamController = StreamController<LatLng>();
  }

  void _createCompassStreamController() {
    _compassStream = StreamController<double>();
  }
}
