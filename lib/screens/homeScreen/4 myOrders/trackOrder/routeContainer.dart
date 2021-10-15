import 'package:agelgil_user_end/screens/homeScreen/4%20myOrders/ordersCardWidgets/back.dart';
import 'package:agelgil_user_end/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;

class MapRoute extends StatefulWidget {
  double carrierLat;
  double carrierLong;
  double lat;
  double long;
  double deslat;
  double deslong;
  MapRoute(
      {this.lat,
      this.long,
      this.deslat,
      this.deslong,
      this.carrierLat,
      this.carrierLong});
  @override
  _MapRouteState createState() => _MapRouteState();
}

class _MapRouteState extends State<MapRoute> {
  GoogleMapController _controller;
  Map<MarkerId, Marker> marker = <MarkerId, Marker>{};
  BitmapDescriptor pinLocationIcon;
  BitmapDescriptor pincarrierIcon;
  BitmapDescriptor pinloungeIcon;
  // Object for PolylinePoints
  PolylinePoints polylinePoints;
// List of coordinates to join
  List<LatLng> polylineCoordinates = [];
// Map storing polylines created by connecting
// two points
  Map<PolylineId, Polyline> polylines = {};
  String googleAPIKey = "AIzaSyByQibVskdRB0VCOHIkyLrdunhuC8vDYNA";
  TravelMode travelModeOption = TravelMode.walking;
  bool polylineVisible = false;
  String _mapStyle;
  @override
  void initState() {
    super.initState();
    _getUserLocation();
    rootBundle
        .loadString('assets/custom_google_maps_for_OrderTracking.txt')
        .then((string) {
      _mapStyle = string;
    });
    BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 0.5),
            'images/others/person.png')
        .then((onValue) {
      pinLocationIcon = onValue;
    });
    BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 0.5),
            'images/others/carrier.png')
        .then((onValue) {
      pincarrierIcon = onValue;
    });
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: 0.5), 'images/others/food.png')
        .then((onValue) {
      pinloungeIcon = onValue;
    });
  }

  void _getUserLocation() async {
    Position position =
        await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _createPolylines();
    });
    if (_controller != null) {
      _controller.animateCamera(CameraUpdate.newCameraPosition(
          new CameraPosition(
              bearing: 0,
              target: LatLng(position.latitude, position.longitude),
              tilt: 60,
              zoom: 17.00)));
    }
  }

  // Create the polylines for showing the route between two places

  _createPolylines() async {
    // Initializing PolylinePoints
    polylinePoints = PolylinePoints();

    // Generating the list of coordinates to be used for
    // drawing the polylines
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleAPIKey, // Google Maps API Key
      PointLatLng(widget.lat, widget.long),
      PointLatLng(widget.deslat, widget.deslong),
      travelMode: travelModeOption,
    );

    // Adding the coordinates to the list
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    // Defining an ID
    PolylineId id = PolylineId('poly');

    // Initializing Polyline
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.orange,
      points: polylineCoordinates,
      // width: 5,
    );

    // Adding the polyline to the map
    setState(() {
      polylines[id] = polyline;
      polylineVisible = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      marker[MarkerId('carrier')] = Marker(
          markerId: MarkerId('carrier'),
          position: LatLng(widget.carrierLat, widget.carrierLong),
          icon: pincarrierIcon);
    });
    return Scaffold(
      body: Stack(
        children: [
          !polylineVisible
              ? Loading()
              : GoogleMap(
                  mapType: MapType.normal,

                  tiltGesturesEnabled: false,
                  initialCameraPosition: CameraPosition(
                    tilt: 60,
                    bearing: 0,
                    target: LatLng(widget.lat, widget.long),
                    zoom: 17,
                  ),
                  polylines: Set<Polyline>.of(polylines.values),

                  markers: Set<Marker>.of(marker.values),

                  compassEnabled: false,
                  // onCameraMove: _onCameraMove,
                  zoomControlsEnabled: false,

                  // rotateGesturesEnabled: false,
                  mapToolbarEnabled: false,
                  onMapCreated: (GoogleMapController controller) {
                    _controller = controller;
                    _controller.setMapStyle(_mapStyle);
                    setState(() {
                      marker[MarkerId('lounge')] = Marker(
                          markerId: MarkerId('lounge'),
                          position: LatLng(widget.lat, widget.long),
                          icon: pinloungeIcon);

                      marker[MarkerId('me')] = Marker(
                          markerId: MarkerId('me'),
                          position: LatLng(widget.deslat, widget.deslong),
                          icon: pinLocationIcon);
                    });
                  },
                ),
          Positioned(
            top: 40,
            left: 20.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Back()),
              ],
            ),
          ),
          Positioned(
            top: 40,
            right: 20,
            child: Container(
              height: 50,
              width: MediaQuery.of(context).size.width - 110,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[600],
                    blurRadius: 2.0, //effect of softening the shadow
                    spreadRadius: 0.5, //effecet of extending the shadow
                    offset: Offset(
                        0.0, //horizontal
                        0.0 //vertical
                        ),
                  ),
                ],
                color: Colors.white,
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: Center(
                child: Text(
                  "Track order",
                  style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
