import 'package:flutter/material.dart';
import 'package:flutter_app_car/src/theme/theme.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class StoreMapPage extends StatelessWidget {
  final String storeName;
  final String address;
  final LatLng location;

  StoreMapPage({
    required this.storeName,
    required this.address,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Địa chỉ', style: bold18White,),
        backgroundColor: primaryColor,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  storeName,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text( 'Địa chỉ: $address',
                  style: TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: location,
                zoom: 15,
              ),
              markers: {
                Marker(
                  markerId: MarkerId('store_location'),
                  position: location,
                  infoWindow: InfoWindow(
                    title: storeName,
                    snippet: address,
                  ),
                ),
              },
            ),
          ),
        ],
      ),
    );
  }
}