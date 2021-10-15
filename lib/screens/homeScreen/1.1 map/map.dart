import 'package:agelgil_user_end/screens/homeScreen/1.1%20map/mapWidgets/compass_button.dart';
import 'package:agelgil_user_end/screens/homeScreen/1.1%20map/mapWidgets/location_button.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'package:geolocator/geolocator.dart';

class MapCenter extends StatefulWidget {
  LatLng initialPosition;
  Map<MarkerId, Marker> loungeMarkers = <MarkerId, Marker>{};
  Future<dynamic> updateLounges;
  MapCenter({this.loungeMarkers, this.initialPosition, this.updateLounges});
  @override
  _MapCenterState createState() => _MapCenterState();
}

class _MapCenterState extends State<MapCenter> with TickerProviderStateMixin {
  bool cartVisibiliy = false;
  int categoryList = 0;
  List categoryItems = [];
  double distance = 0;
  double deliveryDistance = 0;
  double deliveryRadius = 0;
  String loungeId = '';
  String loungeName = '';
  String loungePic = '';
  double loungeLongitude = 0;
  double loungeLatitude = 0;

  BitmapDescriptor pinLocationIcon;
  BitmapDescriptor eateriesIcon;
  BitmapDescriptor supermarketIcon;
  GoogleMapController _controller;
  LatLng _initialPosition;
  bool positionLoading = false;
  LatLng _lastMapPosition;
  double _zoom;
  double _bearing = 0;

  String _mapStyle;
  AnimationController animationController;
  @override
  void initState() {
    super.initState();
    _initialPosition = widget.initialPosition;
    rootBundle.loadString('assets/custom_google_maps.txt').then((string) {
      _mapStyle = string;
    });

    BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 0.5),
            'images/others/person.png')
        .then((onValue) {
      pinLocationIcon = onValue;
    });
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: 0.5), 'images/others/food.png')
        .then((onValue) {
      eateriesIcon = onValue;
    });
    BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 0.5),
            'images/others/supermarket.png')
        .then((onValue) {
      supermarketIcon = onValue;
    });

    // animationController = new AnimationController(
    //   vsync: this,
    //   duration: new Duration(milliseconds: 360),
    // );
    // animationController.forward();
    // animationController.addListener(() {
    //   setState(() {
    //     if (animationController.status == AnimationStatus.completed) {
    //       animationController.repeat();
    //     }
    //   });
    // });
  }

  void _getUserLocation() async {
    setState(() {
      positionLoading = true;
    });

    Position position =
        await getCurrentPosition(desiredAccuracy: LocationAccuracy.best);

    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);

      widget.loungeMarkers[MarkerId('me')] = Marker(
          markerId: MarkerId('me'),
          position: _initialPosition,
          icon: pinLocationIcon);
      positionLoading = false;
    });

    if (_controller != null) {
      _controller.animateCamera(CameraUpdate.newCameraPosition(
          new CameraPosition(
              bearing: 0,
              // _bearing,
              target:
                  LatLng(_initialPosition.latitude, _initialPosition.longitude),
              tilt: 60,
              zoom: 17.00)));
    }
  }

  _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
    _zoom = position.zoom;
    _bearing = position.bearing;
  }

  void setCompass() {
    _controller.animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(
        bearing: 0,
        target: LatLng(_lastMapPosition.latitude, _lastMapPosition.longitude),
        tilt: 60,
        zoom: _zoom)));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
            child: GoogleMap(
          mapType: MapType.normal,

          tiltGesturesEnabled: false,
          initialCameraPosition: CameraPosition(
            tilt: 60,
            bearing: 0,
            target: _initialPosition,
            zoom: 17.00,
          ),
          markers: Set<Marker>.of(widget.loungeMarkers.values),
          // _markers,
          compassEnabled: false,
          onCameraMove: _onCameraMove,
          zoomControlsEnabled: false,
          // rotateGesturesEnabled: false,
          mapToolbarEnabled: false,
          onMapCreated: (GoogleMapController controller) {
            _controller = controller;
            _controller.setMapStyle(_mapStyle);
            setState(() {
              widget.loungeMarkers[MarkerId('me')] = Marker(
                  markerId: MarkerId('me'),
                  position: _initialPosition,
                  icon: pinLocationIcon);
            });
          },
        )),
        Positioned(
            bottom: 80.0, right: 0.0, child: LocationAndCompassBackground()),
        Positioned(child: LocationButton()),
        // Positioned(child: CompassButton()),
      ],
    );
  }

  LocationAndCompassBackground() {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: Container(
        // height: 22.0,
        width: 60.0,
        child: Image(
            image: AssetImage("images/others/opacitybehind.png"),
            fit: BoxFit.fill,
            color: Colors.white),
      ),
    );
  }

  LocationButton() {
    return Stack(
      children: <Widget>[
        Positioned(
          bottom: 80.0,
          right: 0.0,
          child: Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Center(
              child: InkWell(
                  onTap: () async{
                    _getUserLocation();
                   await widget.updateLounges;
                  },
                  child: LocationButtonWidget(
                    positionLoading: positionLoading,
                  )),
            ),
          ),
        ),
      ],
    );
  }

  // CompassButton() {
  //   return Stack(
  //     children: <Widget>[
  //       Positioned(
  //         bottom: 125.0,
  //         right: 0.0,
  //         child: Padding(
  //           padding: const EdgeInsets.only(right: 20.0),
  //           child: Center(
  //             child: InkWell(
  //                 onTap: () {
  //                   setCompass();
  //                 },
  //                 child: CompassButtonWidget(
  //                   animationController: animationController,
  //                   bearing: _bearing,
  //                 )),
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }
}
