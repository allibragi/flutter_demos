import 'package:favorite_places/models/place.dart';
import 'package:flutter/material.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    super.key,
    required this.location,
    this.isSelecting = true,
    // this.location = const PlaceLocation(
    //   latitude: 37.422,
    //   longitude: -122.084,
    //   address: '',
    // ),
  });

  final PlaceLocation location;
  final bool isSelecting;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLong? _pickedLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.isSelecting ? 'Pick your location' : 'Your location'),
        actions: [
          if (widget.isSelecting)
            IconButton(
              onPressed: () {
                Navigator.of(context).pop(_pickedLocation);
              },
              icon: const Icon(Icons.save),
            )
        ],
      ),
      body: FlutterLocationPicker(
          initPosition: _pickedLocation ??
              LatLong(widget.location.latitude, widget.location.longitude),
          initZoom: 16,
          minZoomLevel: 5,
          maxZoomLevel: 16,
          onPicked: (pickedData) {
            setState(() {
              _pickedLocation = pickedData.latLong;
            });
          }),
    );
  }
}
