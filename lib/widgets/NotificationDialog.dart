import 'package:cab_driver/brand_colors.dart';
import 'package:cab_driver/datamodels/tripdetails.dart';
import 'package:cab_driver/widgets/BrandDivier.dart';
import 'package:cab_driver/widgets/TaxiButton.dart';
import 'package:cab_driver/widgets/TaxiOutlineButton.dart';
import 'package:flutter/material.dart';

class NotificationDialog extends StatelessWidget {

  final TripDetails tripDetails;

  NotificationDialog({this.tripDetails});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.all(4),
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4)
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[

            SizedBox(height: 30.0,),

            Image.asset('images/taxi.png', width: 100,),

            SizedBox(height: 16.0,),

            Text('NEW TRIP REQUEST',
              style: TextStyle(fontFamily: 'Brand-Bold', fontSize: 18),),

            SizedBox(height: 30.0,),

            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(

                children: <Widget>[

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Image.asset(
                        'images/pickicon.png', height: 16, width: 16,),
                      SizedBox(width: 18,),

                      Expanded(child: Container(child: Text(
                        tripDetails.pickupAddress, style: TextStyle(
                          fontSize: 18),)))


                    ],
                  ),

                  SizedBox(height: 15,),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Image.asset(
                        'images/desticon.png', height: 16, width: 16,),
                      SizedBox(width: 18,),

                      Expanded(child: Container(child: Text(
                        tripDetails.destinationAddress, style: TextStyle(
                          fontSize: 18),)))


                    ],
                  ),

                ],
              ),
            ),

            SizedBox(height: 20,),

            BrandDivider(),

            SizedBox(height: 8,),

            Padding(
              padding: EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  Expanded(
                    child: Container(
                      child: TaxiOutlineButton(
                        title: 'Odrzuć',
                        color: BrandColors.colorPrimary,
                        onPressed: () async {
                          // assetsAudioPlayer.stop();
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),

                  SizedBox(width: 10,),

                  Expanded(
                    child: Container(
                      child: TaxiButton(
                        title: 'Akceptuj',
                        color: BrandColors.colorGreen,
                        onPressed: () async {
                          // assetsAudioPlayer.stop();
                          //  checkAvailablity(context);
                        },
                      ),
                    ),
                  ),

                ],
              ),
            ),

            SizedBox(height: 10.0,),

          ],
        ),
      ),
    );
  }
}