import 'dart:async';

import 'package:cab_driver/brand_colors.dart';
import 'package:cab_driver/datamodels/tripdetails.dart';
import 'package:cab_driver/globalvariables.dart';
import 'package:cab_driver/widgets/TaxiButton.dart';
import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
            myLocationEnabled: true,
            compassEnabled: true,
            mapToolbarEnabled: true,
            trafficEnabled: true,
            myLocationButtonEnabled: true,
            mapType: MapType.normal,
            initialCameraPosition: googlePlex,
            onMapCreated: (GoogleMapController controller){
              _controller.complete(controller);
              rideMapController = controller;


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
}
