import 'dart:async';

import 'package:cab_driver/brand_colors.dart';
import 'package:cab_driver/datamodels/tripdetails.dart';
import 'package:cab_driver/globalvariables.dart';
import 'package:cab_driver/helpers/helpermethods.dart';
import 'package:cab_driver/widgets/ProgressDialog.dart';
import 'package:cab_driver/widgets/TaxiButton.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NewTripPage extends StatefulWidget {

  final TripDetails tripDetails;
  NewTripPage({this.tripDetails});
  @override
  _NewTripPageState createState() => _NewTripPageState();
}

class _NewTripPageState extends State<NewTripPage> {

  GoogleMapController rideMapController;
  Completer<GoogleMapController> _controller = Completer();
  double mapPaddingBottom = 0;

  Set<Marker> _markers = Set<Marker>();
  Set<Circle> _circles = Set<Circle>();
  Set<Polyline> _polylines = Set<Polyline>();

  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    acceptTrip();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
            padding: EdgeInsets.only(bottom: mapPaddingBottom),
            myLocationEnabled: true,
            compassEnabled: true,
            mapToolbarEnabled: true,
            trafficEnabled: true,
            myLocationButtonEnabled: true,
            mapType: MapType.normal,
            circles: _circles,
            markers: _markers,
            polylines: _polylines,
            initialCameraPosition: googlePlex,
            onMapCreated: (GoogleMapController controller) async {
              _controller.complete(controller);
              rideMapController = controller;

              setState(() {
                mapPaddingBottom = 260;
              });

              var currentLatLng = LatLng(currentPosition.latitude, currentPosition.longitude);
              var pickupLatLng = widget.tripDetails.pickup;

              await getDirection(currentLatLng, pickupLatLng);


            },

          ),

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 15.0,
                    spreadRadius: 0.5,
                    offset: Offset(
                      0.7,
                      0.7,
                    )
                  )
                ]
              ),
              height: 255,
              child: Padding(
                padding:  EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[

                    Text(
                      '14 mins',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Brand-Bold',
                        color: BrandColors.colorAccentPurple
                      ),
                    ),
                    SizedBox(height: 5,),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Daniel Jones', style: TextStyle(fontSize: 22, fontFamily: 'Brand-Bold'),),

                        Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: Icon(Icons.call),

                        ),
                      ],
                    ),
                    SizedBox(height: 25,),

                    Row(
                      children: <Widget>[
                        Image.asset('images/pickicon.png', height: 16, width: 16,),
                        SizedBox(width: 18,),

                        Expanded(
                          child: Container(
                            child: Text(
                              'Wykroty Polska',
                              style: TextStyle(fontSize: 18),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),

                      ],
                    ),

                    SizedBox(height: 15,),

                    Row(
                      children: <Widget>[
                        Image.asset('images/desticon.png', height: 16, width: 16,),
                        SizedBox(width: 18,),

                        Expanded(
                          child: Container(
                            child: Text(
                              'Wrocław Polska',
                              style: TextStyle(fontSize: 18),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),

                      ],
                    ),


                    SizedBox(height: 25,),

                    TaxiButton(
                      title: 'Przyjazd',
                      color: BrandColors.colorGreen,
                      onPressed: (){

                      },

                    )


                  ],
                ),
              ),
            ),
          )



        ],

      ),
    );
  }

  void acceptTrip(){
    String rideID = widget.tripDetails.rideID;
    rideRef = FirebaseDatabase.instance.reference().child('rideRequest/$rideID');

    rideRef.child('status').set('accepted');
    rideRef.child('driver_name').set(currentDriverInfo.fullName);
    rideRef.child('car_details').set('${currentDriverInfo.carColor} - ${currentDriverInfo.carModel}');
    rideRef.child('driver_phone').set(currentDriverInfo.phone);
    rideRef.child('driver_id').set(currentDriverInfo.id);

    Map locationMap = {
      'latitude': currentPosition.latitude.toString(),
      'longitude': currentPosition.longitude.toString(),
    };

    rideRef.child('driver_location').set(locationMap);




  }

  Future<void> getDirection(LatLng pickupLatLng, LatLng destinationLatLng) async {


    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => ProgressDialog(
          status: "Proszę czekać...",
        ));

    var thisDetails =
    await HelperMethods.getDirectionDetails(pickupLatLng, destinationLatLng);


    Navigator.pop(context);

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> results =
    polylinePoints.decodePolyline(thisDetails.encodePoints);
    polylineCoordinates.clear();
    if (results.isNotEmpty) {
      results.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    _polylines.clear();

    setState(() {
      Polyline polyline = Polyline(
        polylineId: PolylineId('polyid'),
        color: Color.fromARGB(255, 95, 109, 237),
        points: polylineCoordinates,
        jointType: JointType.round,
        width: 4,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );
      _polylines.add(polyline);
    });
    //dopasowywanie polyline

    LatLngBounds bounds;

    if (pickupLatLng.latitude > destinationLatLng.latitude &&
        pickupLatLng.longitude > destinationLatLng.longitude) {
      bounds =
          LatLngBounds(southwest: destinationLatLng, northeast: pickupLatLng);
    } else if (pickupLatLng.longitude > destinationLatLng.longitude) {
      bounds = LatLngBounds(
        southwest: LatLng(pickupLatLng.latitude, destinationLatLng.longitude),
        northeast: LatLng(destinationLatLng.latitude, pickupLatLng.longitude),
      );
    } else if (pickupLatLng.latitude > destinationLatLng.latitude) {
      bounds = LatLngBounds(
        southwest: LatLng(destinationLatLng.latitude, pickupLatLng.longitude),
        northeast: LatLng(pickupLatLng.latitude, destinationLatLng.longitude),
      );
    } else {
      bounds =
          LatLngBounds(southwest: pickupLatLng, northeast: destinationLatLng);
    }

    rideMapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 70));

    Marker pickupMarker = Marker(
      markerId: MarkerId('pickup'),
      position: pickupLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    );

    Marker destinationMarker = Marker(
      markerId: MarkerId('destination'),
      position: destinationLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),

    );

    setState(() {
      _markers.add(pickupMarker);
      _markers.add(destinationMarker);
    });

    Circle pickupCircle = Circle(
      circleId: CircleId('pickup'),
      strokeColor: Colors.green,
      strokeWidth: 3,
      radius: 12,
      center: pickupLatLng,
      fillColor: BrandColors.colorGreen,
    );

    Circle destinationCircle = Circle(
      circleId: CircleId('destination'),
      strokeColor: BrandColors.colorAccentPurple,
      strokeWidth: 3,
      radius: 12,
      center: destinationLatLng,
      fillColor: BrandColors.colorAccentPurple,
    );

    setState(() {
      _circles.add(pickupCircle);
      _circles.add(destinationCircle);
    });
  }
}
